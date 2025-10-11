import 'dart:io';
import 'package:get/get.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:ffmpeg_kit_flutter_new/session.dart';
import 'package:ffmpeg_kit_flutter_new/statistics.dart';
import 'package:ffmpeg_kit_flutter_new/log.dart';
import 'package:path_provider/path_provider.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:video_converter/app/routes/app_pages.dart';
import 'package:video_converter/app/modules/select_video/controllers/select_video_controller.dart';
import 'package:video_converter/app/services/notification_service.dart';
import 'package:video_converter/app/services/android_version_handler.dart';

class LoadingController extends GetxController {
  final count = 0.obs;
  final isLoading = true.obs;
  final progress = 0.0.obs;
  final statusMessage = 'preparing_conversion'.tr.obs;
  final outputPath = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _startLoading();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _startLoading() async {
    try {
      // Android 버전 핸들러 초기화
      await AndroidVersionHandler.instance.initialize();

      // 디바이스 정보 로깅
      AndroidVersionHandler.instance.logDeviceInfo();

      // FFmpeg 호환성 체크
      final isFFmpegCapable = await AndroidVersionHandler.instance
          .checkFFmpegCapability();
      if (!isFFmpegCapable) {
        statusMessage.value = 'FFmpeg is not available on this device';
        isLoading.value = false;
        return;
      }

      // SelectVideoController에서 비디오 파일 정보 가져오기
      final selectVideoController = Get.find<SelectVideoController>();
      final videoFile = selectVideoController.videoFile.value;

      if (videoFile == null) {
        statusMessage.value = 'no_video_selected'.tr;
        isLoading.value = false;
        return;
      }

      statusMessage.value = 'starting_conversion'.tr;

      // 저장된 변환 설정 가져오기
      final savedSettings = await selectVideoController.loadConvertSettings();
      print('LoadingController: Loaded settings: $savedSettings');
      final quality = savedSettings['quality'] ?? 75.0;
      final fps = savedSettings['fps'] ?? 30.0;
      final speed = savedSettings['speed'] ?? 1.0;
      final selectedResolution = savedSettings['selectedResolution'] ?? 0;
      final selectedFormat = savedSettings['selectedFormat'] ?? 'WebP';
      print('LoadingController: Selected format: $selectedFormat');

      // 출력 파일 경로 생성 (임시 디렉토리에 저장 후 갤러리로 이동)
      final tempDir = await getTemporaryDirectory();
      final fileExtension = _getFileExtension(selectedFormat);
      final outputFileName =
          'video_converter_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final outputFile = File('${tempDir.path}/$outputFileName');
      outputPath.value = outputFile.path;

      statusMessage.value = 'converting_to_format'.trParams({
        'format': selectedFormat,
        'quality': quality.toInt().toString(),
        'fps': fps.toInt().toString(),
      });

      // 원본 비디오 정보 가져오기
      final videoWidth = selectVideoController.videoWidth.value ?? 0;
      final videoHeight = selectVideoController.videoHeight.value ?? 0;

      // 해상도 설정 적용 (0이면 원본 해상도 유지)
      int targetWidth = videoWidth;
      int targetHeight = videoHeight;

      if (selectedResolution > 0) {
        switch (selectedResolution) {
          case 1: // 720p
            targetHeight = 720;
            break;
          case 2: // 480p
            targetHeight = 480;
            break;
          case 3: // 320p
            targetHeight = 320;
            break;
          default:
            targetHeight = videoHeight;
        }

        if (targetHeight < videoHeight) {
          final aspectRatio = videoWidth / videoHeight;
          targetWidth = (targetHeight * aspectRatio).round();
        }
      }

      // FPS 검증 (요청된 FPS가 원본보다 높으면 원본 FPS로 제한)
      double targetFps = fps;
      // 원본 FPS는 비디오 정보에서 가져와야 하지만, 일단 요청된 FPS 사용

      // 비디오 필터 구성 (README 로직 참고)
      List<String> vfOptions = ['scale=$targetWidth:$targetHeight'];

      // 배속 설정이 1.0이 아닌 경우 setpts 필터 추가
      if (speed != 1.0) {
        vfOptions.add('setpts=${1 / speed}*PTS');
      }

      // 버전별 최적화된 FFmpeg 명령어 생성
      final command = AndroidVersionHandler.instance.generateConvertCommand(
        inputPath: videoFile.path,
        outputPath: outputFile.path,
        format: selectedFormat,
        width: targetWidth,
        height: targetHeight,
        fps: targetFps,
        quality: quality,
        speed: speed,
      );

      // FFmpeg 명령어 출력
      print('FFmpeg Command: $command');
      print(
        'Android 버전 카테고리: ${AndroidVersionHandler.instance.versionCategory}',
      );

      // FFmpeg 실행
      await FFmpegKit.executeAsync(
        command,
        (Session session) async {
          // 변환 완료 시 호출
          final returnCode = await session.getReturnCode();
          if (ReturnCode.isSuccess(returnCode)) {
            statusMessage.value = 'saving_to_gallery'.tr;
            print(
              'Gallery Save: Starting to save $selectedFormat to gallery...',
            );
            print('Gallery Save: Output file path: ${outputFile.path}');

            try {
              // GallerySaver를 사용하여 갤러리에 저장 (WebP는 이미지, 나머지는 비디오)
              bool? success;
              if (selectedFormat == 'WebP') {
                print('Gallery Save: Calling GallerySaver.saveImage()...');
                success = await GallerySaver.saveImage(outputFile.path);
              } else {
                print('Gallery Save: Calling GallerySaver.saveVideo()...');
                success = await GallerySaver.saveVideo(outputFile.path);
              }

              print('Gallery Save: GallerySaver result: $success');

              if (success == true) {
                print(
                  'Gallery Save: SUCCESS - $selectedFormat saved to gallery',
                );

                // 갤러리 저장 성공 시 원본 파일 삭제
                try {
                  final originalFile = File(videoFile.path);
                  if (originalFile.existsSync()) {
                    await originalFile.delete();
                    print('Gallery Save: Original file deleted successfully');
                  }
                } catch (e) {
                  print('Gallery Save: Failed to delete original file: $e');
                }

                statusMessage.value = 'conversion_completed_saved'.tr;
                progress.value = 1.0;
                isLoading.value = false;

                // 변환 완료 알림 표시
                await NotificationService.showConversionCompleteNotification(
                  fileName: outputFile.path.split('/').last,
                  format: selectedFormat,
                );

                // 결과 화면으로 이동
                Get.offNamed(
                  Routes.CONVERT_RESULT,
                  arguments: {
                    'outputPath': outputFile.path,
                    'originalPath': videoFile.path,
                    'savedToGallery': true,
                  },
                );
              } else {
                print('Gallery Save: FAILED - GallerySaver returned false');
                statusMessage.value = 'conversion_completed_not_saved'.tr;
                progress.value = 1.0;
                isLoading.value = false;

                // 갤러리 저장 실패해도 결과 화면으로 이동
                Get.offNamed(
                  Routes.CONVERT_RESULT,
                  arguments: {
                    'outputPath': outputFile.path,
                    'originalPath': videoFile.path,
                    'savedToGallery': false,
                  },
                );
              }
            } catch (e) {
              print('Gallery Save: ERROR - Exception occurred: $e');
              statusMessage.value = 'conversion_completed_gallery_failed'
                  .trParams({'error': e.toString()});
              progress.value = 1.0;
              isLoading.value = false;

              // 갤러리 저장 실패해도 결과 화면으로 이동
              Get.offNamed(
                Routes.CONVERT_RESULT,
                arguments: {
                  'outputPath': outputFile.path,
                  'originalPath': videoFile.path,
                  'savedToGallery': false,
                },
              );
            }
          } else {
            statusMessage.value = 'conversion_failed'.tr;
            isLoading.value = false;
            Get.snackbar('Error', 'Video conversion failed');
          }
        },
        (Log log) {
          // 로그 출력 (선택사항)
          // print('FFmpeg Log: ${log.getMessage()}');
        },
        (Statistics statistics) {
          // 진행률 업데이트 (간단한 시간 기반 진행률)
          final timeInSeconds = statistics.getTime() / 1000;
          // 대략적인 진행률 계산 (실제로는 더 정확한 방법이 필요할 수 있음)
          if (timeInSeconds > 0) {
            progress.value = (timeInSeconds / 10).clamp(0.0, 0.9); // 최대 90%까지
          }
        },
      );
    } catch (e) {
      // 디바이스별 에러 정보 로깅
      final androidInfo = AndroidVersionHandler.instance.androidInfo;
      if (androidInfo != null) {
        print('변환 오류 발생 디바이스 정보:');
        print('- 브랜드: ${androidInfo.brand}');
        print('- 모델: ${androidInfo.model}');
        print('- Android 버전: ${androidInfo.version.release}');
        print('- API 레벨: ${androidInfo.version.sdkInt}');
        print('- 지원 아키텍처: ${androidInfo.supportedAbis}');
        print('- 버전 카테고리: ${AndroidVersionHandler.instance.versionCategory}');
      }

      // 사용자에게 친화적인 에러 메시지 표시
      String errorMessage;
      if (e.toString().contains('FFmpeg is not available')) {
        errorMessage = 'error_ffmpeg_not_available'.tr;
      } else if (e.toString().contains('codec')) {
        errorMessage = 'error_format_not_supported'.tr;
      } else if (e.toString().contains('memory') ||
          e.toString().contains('Memory')) {
        errorMessage = 'error_memory_insufficient'.tr;
      } else {
        errorMessage = 'error_conversion_general'.trParams({
          'error': e.toString(),
        });
      }

      statusMessage.value = errorMessage;
      isLoading.value = false;

      // 변환 실패 알림 표시
      await NotificationService.showConversionErrorNotification(
        errorMessage: errorMessage,
      );

      Get.snackbar('Error', errorMessage);
    }
  }

  void increment() => count.value++;

  // 포맷별 파일 확장자 반환
  String _getFileExtension(String format) {
    switch (format) {
      case 'WebP':
        return 'webp';
      case 'MP4':
        return 'mp4';
      case 'MKV':
        return 'mkv';
      case 'AVI':
        return 'avi';
      case 'FLV':
        return 'flv';
      case 'MOV':
        return 'mov';
      default:
        return 'webp';
    }
  }
}
