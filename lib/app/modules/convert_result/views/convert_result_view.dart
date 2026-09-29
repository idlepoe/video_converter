import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../controllers/convert_result_controller.dart';
import '../../select_video/widgets/simple_video_player_widget.dart';
import '../../../theme/app_theme.dart';

class ConvertResultView extends GetView<ConvertResultController> {
  const ConvertResultView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.offAllNamed(Routes.SELECT_VIDEO);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'conversion_complete'.tr,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Get.offAllNamed(Routes.SELECT_VIDEO),
          ),
        ),
        body: Obx(() {
          if (controller.outputPath.value == null) {
            return Center(child: Text('no_converted_file'.tr));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 성공 메시지
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 44,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'conversion_complete_title'.tr,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.savedToGallery.value
                            ? 'video_saved_to_gallery'.tr
                            : 'file_ready_for_download'.tr,
                        style: const TextStyle(
                          fontSize: 15,
                          color: AppColors.textSecondary,
                        ),
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
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
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
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
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      );
                    }
                  }
                }),

                const SizedBox(height: 32),

                // 액션 버튼들
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: () => controller.openGallery(),
                        child: Text(
                          'view_in_gallery'.tr,
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
      ),
    );
  }
}
