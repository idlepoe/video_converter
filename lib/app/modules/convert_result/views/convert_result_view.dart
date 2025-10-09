import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/convert_result_controller.dart';
import '../../select_video/widgets/simple_video_player_widget.dart';

class ConvertResultView extends GetView<ConvertResultController> {
  const ConvertResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Conversion Complete',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.outputPath.value == null) {
          return const Center(child: Text('No converted file found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 성공 메시지
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Conversion Complete!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.savedToGallery.value
                          ? 'Video saved to gallery'
                          : 'File ready for download',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 파일 타입에 따른 표시
              Obx(() {
                if (controller.isWebP.value) {
                  // WebP 이미지 표시
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        children: [
                          // 이미지 표시
                          Container(
                            height: 300,
                            width: double.infinity,
                            color: Colors.black,
                            child: controller.outputPath.value != null
                                ? Image.file(
                                    File(controller.outputPath.value!),
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          color: Colors.white,
                                          size: 64,
                                        ),
                                      );
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                          // 파일 정보
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'File Name: ${controller.fileName.value ?? 'Unknown'}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'File Size: ${controller.formattedFileSize}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Format: WebP',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // 비디오 파일 표시
                  if (controller.isVideoInitialized.value) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: SimpleVideoPlayerWidget(
                          videoController:
                              controller.videoPlayerController.value!,
                          maxVideoHeight: 300,
                          fileName: controller.fileName.value ?? 'Unknown',
                          videoWidth: controller.videoWidth.value,
                          videoHeight: controller.videoHeight.value,
                          videoDuration: controller.videoDuration.value,
                          filePath: controller.outputPath.value!,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }
                }
              }),
              const SizedBox(height: 20),

              // 갤러리 저장 상태
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      controller.savedToGallery.value
                          ? Icons.check_circle
                          : Icons.error_outline,
                      color: controller.savedToGallery.value
                          ? Colors.green
                          : Colors.orange,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.savedToGallery.value
                                ? 'Saved to Gallery'
                                : 'Not saved to Gallery',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: controller.savedToGallery.value
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.savedToGallery.value
                                ? 'Your converted video is now available in your gallery'
                                : 'Failed to save to gallery. Check file permissions.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 액션 버튼들
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // 다른 비디오 변환
                        Get.offAllNamed('/select-video');
                      },
                      icon: const Icon(Icons.video_library),
                      label: const Text('Convert Another'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B7280),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => controller.openGallery(),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('View in Gallery'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0064FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
