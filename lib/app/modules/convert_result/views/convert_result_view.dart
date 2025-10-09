import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/convert_result_controller.dart';

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

              // 비디오 플레이어
              Container(
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
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: controller.isVideoInitialized.value
                        ? VideoPlayer(controller.videoPlayerController.value!)
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 비디오 컨트롤
              if (controller.isVideoInitialized.value)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (controller
                              .videoPlayerController
                              .value!
                              .value
                              .isPlaying) {
                            controller.videoPlayerController.value!.pause();
                          } else {
                            controller.videoPlayerController.value!.play();
                          }
                        },
                        icon: Icon(
                          controller
                                  .videoPlayerController
                                  .value!
                                  .value
                                  .isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 32,
                          color: const Color(0xFF0064FF),
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () {
                          controller.videoPlayerController.value!.seekTo(
                            Duration.zero,
                          );
                        },
                        icon: const Icon(
                          Icons.replay,
                          size: 24,
                          color: const Color(0xFF0064FF),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20),

              // 파일 정보
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'File Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(
                          Icons.video_file,
                          color: Color(0xFF0064FF),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Format: ',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const Text(
                          'WebP',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.storage,
                          color: Color(0xFF0064FF),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'File Size: ',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          controller.formattedFileSize,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          controller.savedToGallery.value
                              ? Icons.check_circle
                              : Icons.error_outline,
                          color: controller.savedToGallery.value
                              ? Colors.green
                              : Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          controller.savedToGallery.value
                              ? 'Saved to Gallery'
                              : 'Not saved to Gallery',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: controller.savedToGallery.value
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ],
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
                      onPressed: () {
                        // 갤러리에서 확인
                        Get.snackbar(
                          'Success',
                          'Check your gallery for the converted video',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
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
