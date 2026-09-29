import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_converter/app/models/conversion_job.dart';
import 'package:video_converter/app/services/batch_conversion_service.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_converter/app/models/selected_video_item.dart';
import '../widgets/video_rotate_screen.dart';
import '../widgets/video_trim_screen.dart';
import '../dialogs/convert_options_dialog.dart';

class SelectVideoController extends GetxController {
  final videoFile = Rxn<XFile>();
  final originalVideoFile = Rxn<XFile>();
  final videoPlayerController = Rxn<VideoPlayerController>();
  final isVideoSelected = false.obs;
  final videoInfo = Rxn<Map<String, dynamic>>();
  final isTrimmed = false.obs;
  final videoWidth = Rxn<int>();
  final videoHeight = Rxn<int>();
  final videoDuration = Rxn<Duration>();
  final selectedVideos = <SelectedVideoItem>[].obs;
  final focusedItem = Rxn<SelectedVideoItem>();
  final isPickingVideos = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    try {
      // 업데이트 확인
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        // 즉시 업데이트 수행
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      // 업데이트 실패 시 로그만 출력 (사용자에게는 알리지 않음)
      print('In-app update failed: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // 비디오 플레이어 컨트롤러 안전하게 dispose
    if (videoPlayerController.value != null) {
      videoPlayerController.value!.dispose();
      videoPlayerController.value = null;
    }
    super.onClose();
  }

  Future<void> _initVideoPlayer(XFile file) async {
    try {
      // 기존 컨트롤러가 있다면 안전하게 dispose
      if (videoPlayerController.value != null) {
        await videoPlayerController.value!.dispose();
        videoPlayerController.value = null;
      }

      final controller = VideoPlayerController.file(File(file.path));
      await controller.initialize();

      // 컨트롤러가 여전히 유효한지 확인
      if (controller.value.isInitialized) {
        videoPlayerController.value = controller;
        videoDuration.value = controller.value.duration;
        videoWidth.value = controller.value.size.width.toInt();
        videoHeight.value = controller.value.size.height.toInt();
        isVideoSelected.value = true;
        final item = focusedItem.value;
        if (item != null && item.file.path == file.path) {
          item.width = videoWidth.value!;
          item.height = videoHeight.value!;
          item.duration = videoDuration.value!;
          selectedVideos.refresh();
        }
      } else {
        await controller.dispose();
      }
    } catch (e) {
      // 비디오 플레이어 초기화 오류 처리
      print('Video player initialization error: $e');

      // Crashlytics에 에러 정보 전송
      FirebaseCrashlytics.instance.recordError(
        e,
        StackTrace.current,
        reason: 'Video player initialization failed',
        information: [
          'File Path: ${file.path}',
          'File Name: ${file.name}',
          'File Size: ${await file.length()}',
          'Video Width: ${videoWidth.value ?? 'Unknown'}',
          'Video Height: ${videoHeight.value ?? 'Unknown'}',
          'Video Duration: ${videoDuration.value?.inSeconds ?? 'Unknown'} seconds',
        ],
      );

      videoPlayerController.value = null;
      isVideoSelected.value = false;
    }
  }

  Future<void> selectOtherVideo() async {
    await pickVideo();
  }

  Future<void> _clearFocusedVideo() async {
    isVideoSelected.value = false;
    videoFile.value = null;
    originalVideoFile.value = null;

    // 비디오 플레이어 컨트롤러 안전하게 dispose
    if (videoPlayerController.value != null) {
      await videoPlayerController.value!.dispose();
      videoPlayerController.value = null;
    }

    videoInfo.value = null;
    isTrimmed.value = false;
    videoWidth.value = null;
    videoHeight.value = null;
    videoDuration.value = null;
  }

  void openRotateScreen() async {
    if (videoFile.value == null) {
      Get.snackbar('Error', 'Please select a video file first');
      return;
    }

    // 비디오 회전 화면으로 네비게이션
    await Get.to(
      () => VideoRotateScreen(
        filePath: videoFile.value!.path,
        fileName: videoFile.value!.name,
        onRotateComplete: (String rotatedFilePath) {
          // 회전된 파일로 교체
          final rotatedFile = XFile(rotatedFilePath);
          videoFile.value = rotatedFile;
          focusedItem.value?.file = rotatedFile;
          selectedVideos.refresh();
          isTrimmed.value = false; // 회전 후에는 trim 상태 초기화
          _initVideoPlayer(rotatedFile);

          // 성공 메시지
          Get.back(); // 회전 화면 닫기
        },
        onCancel: () {
          Get.back(); // 회전 화면 닫기
        },
      ),
    );
  }

  Future<void> restoreOriginal() async {
    if (originalVideoFile.value == null) {
      Get.snackbar('Error', 'No original file available');
      return;
    }

    try {
      videoFile.value = originalVideoFile.value;
      focusedItem.value?.file = originalVideoFile.value!;
      selectedVideos.refresh();
      isTrimmed.value = false;
      await _initVideoPlayer(originalVideoFile.value!);
      Get.snackbar('Success', 'Original video restored');
    } catch (e) {
      // 원본 비디오 복원 실패 시 Crashlytics로 전송
      FirebaseCrashlytics.instance.recordError(
        e,
        StackTrace.current,
        reason: 'Failed to restore original video',
        information: [
          'Original File Path: ${originalVideoFile.value?.path ?? 'Unknown'}',
          'Current File Path: ${videoFile.value?.path ?? 'Unknown'}',
          'Is Trimmed: ${isTrimmed.value}',
        ],
      );

      Get.snackbar('Error', 'Failed to restore original video');
    }
  }

  Future<void> saveConvertSettings({
    required int selectedResolution,
    required double fps,
    required double quality,
    required String format,
    required double speed,
    required String selectedFormat,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('convert_resolution', selectedResolution);
      await prefs.setDouble('convert_fps', fps);
      await prefs.setDouble('convert_quality', quality);
      await prefs.setString('convert_format', format);
      await prefs.setDouble('convert_speed', speed);
      await prefs.setString('convert_selected_format', selectedFormat);
    } catch (e) {
      // 설정 저장 실패 시 Crashlytics로 전송
      FirebaseCrashlytics.instance.recordError(
        e,
        StackTrace.current,
        reason: 'Failed to save convert settings',
        information: [
          'Selected Resolution: $selectedResolution',
          'FPS: $fps',
          'Quality: $quality',
          'Format: $format',
          'Speed: $speed',
          'Selected Format: $selectedFormat',
        ],
      );

      Get.snackbar('Error', 'Failed to save convert settings');
    }
  }

  // 설정 불러오기
  Future<Map<String, dynamic>> loadConvertSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      return {
        'selectedResolution':
            prefs.getInt('convert_resolution') ?? 0, // 기본값은 원본 해상도
        'fps': prefs.getDouble('convert_fps') ?? 30.0,
        'quality': prefs.getDouble('convert_quality') ?? 75.0,
        'format': prefs.getString('convert_format') ?? 'webp',
        'speed': prefs.getDouble('convert_speed') ?? 1.0,
        'selectedFormat': prefs.getString('convert_selected_format') ?? 'WebP',
      };
    } catch (e) {
      // 설정 불러오기 실패 시 Crashlytics로 전송
      FirebaseCrashlytics.instance.recordError(
        e,
        StackTrace.current,
        reason: 'Failed to load convert settings',
        information: [
          'Error Type: ${e.runtimeType}',
          'Error Message: ${e.toString()}',
        ],
      );

      return {
        'selectedResolution': 0, // 기본값은 원본 해상도
        'fps': 30.0,
        'quality': 75.0,
        'format': 'webp',
        'speed': 1.0,
        'selectedFormat': 'WebP',
      };
    }
  }

  // Trim 화면으로 이동
  void openTrimScreen() async {
    if (videoFile.value == null) {
      Get.snackbar('Error', 'Please select a video file first');
      return;
    }

    // Trim 화면으로 네비게이션 (Get.to 사용하여 기존 컨트롤러 유지)
    final result = await Get.to(
      () => VideoTrimScreen(),
      arguments: {
        'filePath': videoFile.value!.path,
        'fileName': videoFile.value!.name,
      },
    );

    if (result != null && result is String) {
      // Trim된 파일로 교체
      final trimmedFile = XFile(result);
      videoFile.value = trimmedFile;
      focusedItem.value?.file = trimmedFile;
      selectedVideos.refresh();
      isTrimmed.value = true; // Trim 상태 업데이트
      await _initVideoPlayer(trimmedFile);

      Get.snackbar('Success', 'Video trimmed successfully');
    }
  }

  Future<void> pickVideo() async {
    try {
      isPickingVideos.value = true;
      final result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: true,
      );
      if (result == null) return;

      final defaults = ConversionOptions.fromMap(await loadConvertSettings());
      final existingPaths = selectedVideos
          .map((item) => item.originalFile.path)
          .toSet();
      final added = <SelectedVideoItem>[];

      for (final picked in result.files) {
        final path = picked.path;
        if (path == null || existingPaths.contains(path)) continue;
        final file = XFile(path, name: picked.name);
        final metadataController = VideoPlayerController.file(File(path));
        try {
          await metadataController.initialize();
          added.add(
            SelectedVideoItem(
              id: '${DateTime.now().microsecondsSinceEpoch}_${added.length}',
              originalFile: file,
              file: file,
              width: metadataController.value.size.width.toInt(),
              height: metadataController.value.size.height.toInt(),
              duration: metadataController.value.duration,
              options: defaults,
            ),
          );
          existingPaths.add(path);
        } finally {
          await metadataController.dispose();
        }
      }

      selectedVideos.addAll(added);
      if (focusedItem.value == null && selectedVideos.isNotEmpty) {
        await focusVideo(selectedVideos.first);
      }
    } catch (e) {
      // 비디오 선택 실패 시 Crashlytics로 전송
      FirebaseCrashlytics.instance.recordError(
        e,
        StackTrace.current,
        reason: 'Failed to pick video from gallery',
        information: [
          'Error Type: ${e.runtimeType}',
          'Error Message: ${e.toString()}',
          'Picker Source: ImageSource.gallery',
        ],
      );

      // CommonSnackBar.error(
      //     'error'.tr, 'An error occurred while selecting the video.'.tr);
      print('Error picking video: $e');
    } finally {
      isPickingVideos.value = false;
    }
  }

  Future<void> focusVideo(SelectedVideoItem item) async {
    focusedItem.value = item;
    videoFile.value = item.file;
    originalVideoFile.value = item.originalFile;
    isTrimmed.value = item.file.path != item.originalFile.path;
    await _initVideoPlayer(item.file);
  }

  Future<void> removeVideo(SelectedVideoItem item) async {
    final wasFocused = focusedItem.value?.id == item.id;
    selectedVideos.removeWhere((candidate) => candidate.id == item.id);
    if (!wasFocused) return;
    await _clearFocusedVideo();
    if (selectedVideos.isNotEmpty) await focusVideo(selectedVideos.first);
  }

  void showItemOptions(BuildContext context, SelectedVideoItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ConvertOptionsDialog(
        originalWidth: item.width,
        originalHeight: item.height,
        videoDurationSeconds: item.duration.inSeconds,
        videoFilePath: item.file.path,
        savedSettings: item.options.toMap(),
        submitText: 'Apply',
        onConvert: (options) async {
          item.options = ConversionOptions.fromMap(options);
          selectedVideos.refresh();
        },
      ),
    );
  }

  void convertVideo() {
    if (videoFile.value != null) {
      // 비디오 변환 로직 구현
      Get.snackbar('Success', 'Video conversion started!');
    }
  }

  void showConvertDialog(BuildContext context) async {
    final originalWidth = videoWidth.value ?? 0;
    final originalHeight = videoHeight.value ?? 0;
    final videoDurationSeconds = videoDuration.value?.inSeconds ?? 0;
    final videoFilePath = videoFile.value!.path;

    final savedSettings =
        focusedItem.value?.options.toMap() ?? await loadConvertSettings();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return ConvertOptionsDialog(
          originalWidth: originalWidth,
          originalHeight: originalHeight,
          videoDurationSeconds: videoDurationSeconds,
          videoFilePath: videoFilePath,
          savedSettings: savedSettings,
          onConvert: (options) async {
            print('--------------------options: $options');
            await handleConvert(options);
          },
        );
      },
    );
  }

  Future<void> handleConvert(Map<String, dynamic> options) async {
    try {
      // 비디오 플레이어가 재생 중이라면 중지
      if (videoPlayerController.value != null &&
          videoPlayerController.value!.value.isPlaying) {
        await videoPlayerController.value!.pause();
      }

      // 변환 설정 저장
      await saveConvertSettings(
        selectedResolution: options['selectedResolution'],
        fps: options['fps'],
        quality: options['quality'],
        format: options['format'],
        speed: options['speed'],
        selectedFormat: options['selectedFormat'], // selectedFormat 추가
      );

      final file = videoFile.value;
      if (file == null) {
        throw Exception('No video selected');
      }

      final queue = Get.find<BatchConversionService>();
      final item = focusedItem.value;
      if (item != null) item.options = ConversionOptions.fromMap(options);
      queue.enqueue(
        ConversionJob(
          id: '${DateTime.now().microsecondsSinceEpoch}',
          inputPath: file.path,
          fileName: file.name,
          width: videoWidth.value ?? 0,
          height: videoHeight.value ?? 0,
          duration: videoDuration.value ?? Duration.zero,
          options: ConversionOptions.fromMap(options),
        ),
      );

      await Fluttertoast.showToast(
        msg:
            '${'starting_conversion'.tr}\n${file.name} · ${options['selectedFormat']}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: const Color(0xE629333D),
        textColor: Colors.white,
        fontSize: 14,
      );

      if (item != null) {
        await removeVideo(item);
      } else {
        await _clearFocusedVideo();
      }
    } catch (e) {
      // 변환 시작 실패 시 Crashlytics로 전송
      FirebaseCrashlytics.instance.recordError(
        e,
        StackTrace.current,
        reason: 'Failed to start video conversion',
        information: [
          'Video File Path: ${videoFile.value?.path ?? 'Unknown'}',
          'Video File Name: ${videoFile.value?.name ?? 'Unknown'}',
          'Video Width: ${videoWidth.value ?? 'Unknown'}',
          'Video Height: ${videoHeight.value ?? 'Unknown'}',
          'Video Duration: ${videoDuration.value?.inSeconds ?? 'Unknown'} seconds',
          'Is Trimmed: ${isTrimmed.value}',
          'Options: $options',
        ],
      );

      Get.snackbar('Error', 'Failed to start conversion: $e');
    }
  }

  Future<void> enqueueAllVideos() async {
    if (selectedVideos.isEmpty) return;
    final items = List<SelectedVideoItem>.from(selectedVideos);
    final queue = Get.find<BatchConversionService>();
    for (final item in items) {
      queue.enqueue(
        ConversionJob(
          id: '${DateTime.now().microsecondsSinceEpoch}_${item.id}',
          inputPath: item.file.path,
          fileName: item.file.name,
          width: item.width,
          height: item.height,
          duration: item.duration,
          options: item.options,
        ),
      );
    }
    await Fluttertoast.showToast(
      msg: '${items.length} videos added to conversion queue',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xE629333D),
      textColor: Colors.white,
    );
    selectedVideos.clear();
    await _clearFocusedVideo();
  }
}
