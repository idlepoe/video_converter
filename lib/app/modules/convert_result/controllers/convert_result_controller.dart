import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

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
    // 비디오가 초기화되었고 WebP가 아닌 경우 자동 재생
    if (isVideoInitialized.value &&
        !isWebP.value &&
        videoPlayerController.value != null) {
      videoPlayerController.value!.play();
    }
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

        // 비디오 초기화 완료 후 자동 재생
        videoPlayerController.value!.play();
      }
    } catch (e) {
      print('Video player initialization error: $e');

      // 비디오 플레이어 초기화 실패 시 Crashlytics로 전송
      FirebaseCrashlytics.instance.recordError(
        e,
        StackTrace.current,
        reason: 'Video player initialization failed in result screen',
        information: [
          'Output Path: ${outputPath.value ?? 'Unknown'}',
          'Original Path: ${originalPath.value ?? 'Unknown'}',
          'File Size: ${fileSize.value ?? 'Unknown'}',
          'Is WebP: ${isWebP.value}',
          'Saved To Gallery: ${savedToGallery.value}',
          'File Exists: ${outputPath.value != null ? File(outputPath.value!).existsSync() : 'Unknown'}',
        ],
      );
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
    return 'unknown'.tr;
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

      // 갤러리 앱 실행 실패 시 Crashlytics로 전송
      FirebaseCrashlytics.instance.recordError(
        e,
        StackTrace.current,
        reason: 'Failed to launch gallery app',
        information: [
          'Output Path: ${outputPath.value ?? 'Unknown'}',
          'File Name: ${fileName.value ?? 'Unknown'}',
          'File Size: ${fileSize.value ?? 'Unknown'}',
          'Is WebP: ${isWebP.value}',
          'Saved To Gallery: ${savedToGallery.value}',
          'Error Type: ${e.runtimeType}',
          'Error Message: ${e.toString()}',
        ],
      );

      Get.snackbar(
        'Info',
        'gallery_app_not_found'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }
}
