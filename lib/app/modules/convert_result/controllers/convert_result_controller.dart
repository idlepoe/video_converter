import 'dart:io';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class ConvertResultController extends GetxController {
  final videoPlayerController = Rxn<VideoPlayerController>();
  final outputPath = Rxn<String>();
  final originalPath = Rxn<String>();
  final savedToGallery = false.obs;
  final fileSize = Rxn<int>();
  final isVideoInitialized = false.obs;

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
        _initializeVideoPlayer();
        _getFileSize();
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
        isVideoInitialized.value = true;
      }
    } catch (e) {
      print('Video player initialization error: $e');
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
}
