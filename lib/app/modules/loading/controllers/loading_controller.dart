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

class LoadingController extends GetxController {
  final count = 0.obs;
  final isLoading = true.obs;
  final progress = 0.0.obs;
  final statusMessage = 'Preparing conversion...'.obs;
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
      // SelectVideoController에서 비디오 파일 정보 가져오기
      final selectVideoController = Get.find<SelectVideoController>();
      final videoFile = selectVideoController.videoFile.value;

      if (videoFile == null) {
        statusMessage.value = 'No video file selected';
        isLoading.value = false;
        return;
      }

      statusMessage.value = 'Starting conversion...';

      // 저장된 변환 설정 가져오기
      final savedSettings = await selectVideoController.loadConvertSettings();
      final quality = savedSettings['quality'] ?? 75.0;
      final fps = savedSettings['fps'] ?? 30.0;
      final speed = savedSettings['speed'] ?? 1.0;
      final selectedResolution = savedSettings['selectedResolution'] ?? 0;

      // 출력 파일 경로 생성 (임시 디렉토리에 저장 후 갤러리로 이동)
      final tempDir = await getTemporaryDirectory();
      final outputFileName =
          'video_converter_${DateTime.now().millisecondsSinceEpoch}.webp';
      final outputFile = File('${tempDir.path}/$outputFileName');
      outputPath.value = outputFile.path;

      statusMessage.value =
          'Converting to WebP (Quality: ${quality.toInt()}%, FPS: ${fps.toInt()})...';

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

      // FFmpeg 명령어 구성 (README의 fluent-ffmpeg 로직을 명령어로 변환)
      String command = '-i "${videoFile.path}"';
      command += ' -c:v libwebp';
      command += ' -r $targetFps';
      command += ' -quality ${quality.toInt()}';
      command += ' -vf ${vfOptions.join(',')}';
      command += ' -loop 0';
      command += ' -progress pipe:1';
      command += ' "${outputFile.path}"';

      // FFmpeg 실행
      await FFmpegKit.executeAsync(
        command,
        (Session session) async {
          // 변환 완료 시 호출
          final returnCode = await session.getReturnCode();
          if (ReturnCode.isSuccess(returnCode)) {
            statusMessage.value = 'Saving to gallery...';
            print('Gallery Save: Starting to save WebP image to gallery...');
            print('Gallery Save: Output file path: ${outputFile.path}');

            try {
              // GallerySaver를 사용하여 갤러리에 저장 (WebP는 이미지이므로 saveImage 사용)
              print('Gallery Save: Calling GallerySaver.saveImage()...');
              final bool? success = await GallerySaver.saveImage(
                outputFile.path,
              );

              print('Gallery Save: GallerySaver result: $success');

              if (success == true) {
                print('Gallery Save: SUCCESS - WebP image saved to gallery');
                statusMessage.value =
                    'Conversion completed and saved to gallery!';
                progress.value = 1.0;
                isLoading.value = false;

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
                statusMessage.value =
                    'Conversion completed but failed to save to gallery';
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
              statusMessage.value =
                  'Conversion completed but gallery save failed: $e';
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
            statusMessage.value = 'Conversion failed';
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
      statusMessage.value = 'Conversion error: $e';
      isLoading.value = false;
      Get.snackbar('Error', 'Conversion failed: $e');
    }
  }

  void increment() => count.value++;
}
