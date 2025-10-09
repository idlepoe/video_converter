import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:android_intent_plus/android_intent.dart';

class ConvertResultController extends GetxController {
  final videoPlayerController = Rxn<VideoPlayerController>();
  final outputPath = Rxn<String>();
  final originalPath = Rxn<String>();
  final savedToGallery = false.obs;
  final fileSize = Rxn<int>();
  final isVideoInitialized = false.obs;
  final videoWidth = Rxn<int>();
  final videoHeight = Rxn<int>();
  final videoDuration = Rxn<Duration>();
  final fileName = Rxn<String>();
  final isWebP = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    videoPlayerController.value?.dispose();
    super.onClose();
  }

  void _initializeFromArguments() {
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      outputPath.value = arguments['outputPath'] as String?;
      originalPath.value = arguments['originalPath'] as String?;
      savedToGallery.value = arguments['savedToGallery'] as bool? ?? false;

      if (outputPath.value != null) {
        _checkFileType();
        _getFileSize();
        if (!isWebP.value) {
          _initializeVideoPlayer();
        }
      }
    }
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      if (outputPath.value != null) {
        videoPlayerController.value = VideoPlayerController.file(
          File(outputPath.value!),
        );
        await videoPlayerController.value!.initialize();

        // 비디오 정보 설정
        final size = videoPlayerController.value!.value.size;
        videoWidth.value = size.width.toInt();
        videoHeight.value = size.height.toInt();
        videoDuration.value = videoPlayerController.value!.value.duration;

        // 파일명 설정
        final file = File(outputPath.value!);
        fileName.value = file.path.split('/').last;

        isVideoInitialized.value = true;
      }
    } catch (e) {
      print('Video player initialization error: $e');
    }
  }

  void _checkFileType() {
    if (outputPath.value != null) {
      final file = File(outputPath.value!);
      final fileName = file.path.split('/').last.toLowerCase();
      isWebP.value = fileName.endsWith('.webp');

      // 파일명 설정 (WebP와 비디오 모두)
      this.fileName.value = file.path.split('/').last;
    }
  }

  void _getFileSize() {
    if (outputPath.value != null) {
      final file = File(outputPath.value!);
      if (file.existsSync()) {
        fileSize.value = file.lengthSync();
      }
    }
  }

  String _formatFileSize(int size) {
    if (size < 1024) {
      return "$size bytes";
    } else if (size < 1024 * 1024) {
      return "${(size / 1024).toStringAsFixed(2)} KB";
    } else if (size < 1024 * 1024 * 1024) {
      return "${(size / (1024 * 1024)).toStringAsFixed(2)} MB";
    } else {
      return "${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB";
    }
  }

  String get formattedFileSize {
    if (fileSize.value != null) {
      return _formatFileSize(fileSize.value!);
    }
    return 'Unknown';
  }

  Future<void> openGallery() async {
    try {
      // 갤러리 앱 열기 (여러 방법 시도)
      AndroidIntent? intent;

      // 방법 1: 갤러리 앱 직접 열기
      try {
        intent = AndroidIntent(
          action: 'android.intent.action.VIEW',
          data: 'content://media/external/images/media/',
          type: 'vnd.android.cursor.dir/image',
          flags: [268435456], // Intent.FLAG_ACTIVITY_NEW_TASK
        );
        await intent.launch();
        print('Gallery Intent: Successfully launched gallery app (method 1)');
        return;
      } catch (e) {
        print('Gallery Intent: Method 1 failed - $e');
      }

      // 방법 2: 일반적인 이미지 뷰어 열기
      try {
        intent = AndroidIntent(
          action: 'android.intent.action.VIEW',
          type: 'image/*',
          flags: [268435456], // Intent.FLAG_ACTIVITY_NEW_TASK
        );
        await intent.launch();
        print('Gallery Intent: Successfully launched gallery app (method 2)');
        return;
      } catch (e) {
        print('Gallery Intent: Method 2 failed - $e');
      }

      // 방법 3: 파일 매니저 열기
      try {
        intent = AndroidIntent(
          action: 'android.intent.action.VIEW',
          data:
              'content://com.android.externalstorage.documents/root/primary/Pictures',
          flags: [268435456], // Intent.FLAG_ACTIVITY_NEW_TASK
        );
        await intent.launch();
        print('Gallery Intent: Successfully launched file manager (method 3)');
        return;
      } catch (e) {
        print('Gallery Intent: Method 3 failed - $e');
      }

      // 모든 방법 실패
      throw Exception('All gallery launch methods failed');
    } catch (e) {
      print('Gallery Intent: Failed to launch gallery - $e');
      Get.snackbar(
        'Info',
        'Gallery app not found. Please check your gallery manually.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }
}
