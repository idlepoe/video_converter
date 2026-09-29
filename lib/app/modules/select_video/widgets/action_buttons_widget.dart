import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/select_video_controller.dart';

class ActionButtonsWidget extends GetView<SelectVideoController> {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.openRotateScreen,
                    icon: const Icon(Icons.rotate_right, size: 18),
                    label: Text('video_rotate'.tr),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.openTrimScreen,
                    icon: const Icon(Icons.content_cut, size: 18),
                    label: Text('video_trim'.tr),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: controller.enqueueAllVideos,
                icon: const Icon(Icons.sync, size: 18),
                label: Text(
                  controller.selectedVideos.length == 1
                      ? 'convert'.tr
                      : 'convert_video_count'.trParams({
                          'count': '${controller.selectedVideos.length}',
                        }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
