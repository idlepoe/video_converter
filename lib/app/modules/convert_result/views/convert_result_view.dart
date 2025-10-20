import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/convert_result_controller.dart';
import '../../select_video/widgets/simple_video_player_widget.dart';

class ConvertResultView extends GetView<ConvertResultController> {
  const ConvertResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Text(
          'conversion_complete'.tr,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.offAllNamed(Routes.SELECT_VIDEO),
        ),
      ),
      body: Obx(() {
        if (controller.outputPath.value == null) {
          return Center(child: Text('no_converted_file'.tr));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 성공 메시지
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
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 36,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'conversion_complete_title'.tr,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      controller.savedToGallery.value
                          ? 'video_saved_to_gallery'.tr
                          : 'file_ready_for_download'.tr,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 파일 타입에 따른 표시
              Obx(() {
                if (controller.isWebP.value) {
                  // WebP 이미지 표시
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        children: [
                          // 이미지 표시
                          Container(
                            height: 220,
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
                                          size: 48,
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
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'file_name_label'.tr +
                                      ' ${controller.fileName.value ?? 'unknown'.tr}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'file_size_label'.tr +
                                      ' ${controller.formattedFileSize}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'format_webp'.tr,
                                  style: const TextStyle(
                                    fontSize: 13,
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
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SimpleVideoPlayerWidget(
                          videoController:
                              controller.videoPlayerController.value!,
                          maxVideoHeight: 220,
                          fileName: controller.fileName.value ?? 'unknown'.tr,
                          videoWidth: controller.videoWidth.value,
                          videoHeight: controller.videoHeight.value,
                          videoDuration: controller.videoDuration.value,
                          filePath: controller.outputPath.value!,
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
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
              const SizedBox(height: 16),

              // 갤러리 저장 상태
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(12),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black.withOpacity(0.05),
              //         blurRadius: 8,
              //         offset: const Offset(0, 2),
              //       ),
              //     ],
              //   ),
              //   child: Row(
              //     children: [
              //       Icon(
              //         controller.savedToGallery.value
              //             ? Icons.check_circle
              //             : Icons.error_outline,
              //         color: controller.savedToGallery.value
              //             ? Colors.green
              //             : Colors.orange,
              //         size: 20,
              //       ),
              //       const SizedBox(width: 10),
              //       Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               controller.savedToGallery.value
              //                   ? 'saved_to_gallery'.tr
              //                   : 'not_saved_to_gallery'.tr,
              //               style: TextStyle(
              //                 fontSize: 14,
              //                 fontWeight: FontWeight.w600,
              //                 color: controller.savedToGallery.value
              //                     ? Colors.green
              //                     : Colors.orange,
              //               ),
              //             ),
              //             const SizedBox(height: 3),
              //             Text(
              //               controller.savedToGallery.value
              //                   ? 'gallery_save_success_message'.tr
              //                   : 'gallery_save_failed_message'.tr,
              //               style: TextStyle(
              //                 fontSize: 12,
              //                 color: Colors.grey[600],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 16),

              // 액션 버튼들
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => controller.openGallery(),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: const Color(0xFF6B7280),
                        foregroundColor: Colors.white,
                        elevation: 0,
                      ),
                      child: Text(
                        'view_in_gallery'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // 다른 비디오 변환
                        Get.offAllNamed('/select-video');
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: const Color(0xFF0064FF),
                        foregroundColor: Colors.white,

                        elevation: 0,
                      ),
                      child: Text(
                        'convert_another'.tr,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
