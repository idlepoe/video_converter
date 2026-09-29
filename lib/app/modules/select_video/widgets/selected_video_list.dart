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
                  '${controller.selectedVideos.length}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                IconButton(
                  onPressed: controller.isPickingVideos.value
                      ? null
                      : controller.pickVideo,
                  icon: const Icon(Icons.add, size: 18),
                  tooltip: 'Add videos',
                ),
                PopupMenuButton<String>(
                  tooltip: 'Apply settings to all',
                  icon: const Icon(Icons.tune, size: 20),
                  onSelected: (value) {
                    if (value == 'custom') {
                      controller.showBatchOptions(context);
                    } else {
                      controller.applyPreset(value);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'custom',
                      child: Text('Custom settings…'),
                    ),
                    PopupMenuDivider(),
                    PopupMenuItem(
                      value: 'high',
                      child: Text('High quality MP4'),
                    ),
                    PopupMenuItem(value: 'compact', child: Text('Compact MP4')),
                    PopupMenuItem(value: 'webp', child: Text('WebP preset')),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 72,
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
      return GestureDetector(
        onTap: () => controller.focusVideo(item),
        child: Container(
          width: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E8EB),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: focused ? const Color(0xFF3182F6) : Colors.transparent,
              width: 3,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (item.thumbnailData != null)
                Image.memory(item.thumbnailData!, fit: BoxFit.cover)
              else
                const Icon(Icons.video_file, color: Color(0xFF3182F6)),
              Positioned(
                left: 3,
                bottom: 3,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: Text(
                      item.options.format,
                      style: const TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 1,
                top: 1,
                child: IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 28,
                    height: 28,
                  ),
                  style: IconButton.styleFrom(backgroundColor: Colors.black45),
                  onPressed: () => controller.removeVideo(item),
                  icon: const Icon(Icons.close, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
