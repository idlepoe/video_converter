import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/selected_video_item.dart';
import '../controllers/select_video_controller.dart';

class SelectedVideoList extends GetView<SelectVideoController> {
  const SelectedVideoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.selectedVideos.isEmpty) return const SizedBox.shrink();
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  '${controller.selectedVideos.length} videos selected',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: controller.isPickingVideos.value
                      ? null
                      : controller.pickVideo,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
                FilledButton.icon(
                  onPressed: controller.enqueueAllVideos,
                  icon: const Icon(Icons.playlist_add_check, size: 18),
                  label: const Text('Convert all'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 76,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.selectedVideos.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (_, index) {
                  final item = controller.selectedVideos[index];
                  return _VideoCard(item: item);
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _VideoCard extends GetView<SelectVideoController> {
  const _VideoCard({required this.item});

  final SelectedVideoItem item;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final focused = controller.focusedItem.value?.id == item.id;
      return InkWell(
        onTap: () => controller.focusVideo(item),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 210,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: focused ? const Color(0xFFEFF6FF) : const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: focused
                  ? const Color(0xFF3182F6)
                  : const Color(0xFFE5E8EB),
              width: focused ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.video_file, color: Color(0xFF3182F6)),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.file.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${item.options.format} · ${item.width}×${item.height}',
                      maxLines: 1,
                      style: const TextStyle(
                        color: Color(0xFF6B7684),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => controller.showItemOptions(context, item),
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: Icon(Icons.tune, size: 18),
                    ),
                  ),
                  InkWell(
                    onTap: () => controller.removeVideo(item),
                    child: const Padding(
                      padding: EdgeInsets.all(3),
                      child: Icon(Icons.close, size: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
