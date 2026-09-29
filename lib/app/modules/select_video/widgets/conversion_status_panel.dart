import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/conversion_job.dart';
import '../../../routes/app_pages.dart';
import '../../../services/batch_conversion_service.dart';

class ConversionStatusPanel extends GetView<BatchConversionService> {
  const ConversionStatusPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.jobs.isEmpty) return const SizedBox.shrink();
      final current = controller.currentJob.value;
      final progress = controller.overallProgress;
      final finishedCount = controller.completedCount + controller.failedCount;
      final hasFailure = controller.failedCount > 0;
      return Material(
        color: const Color(0xFFEFF6FF),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 6, 4, 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    controller.isProcessing.value
                        ? Icons.sync
                        : hasFailure
                        ? Icons.error_outline
                        : Icons.task_alt,
                    size: 20,
                    color: const Color(0xFF3182F6),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      current == null
                          ? '${'conversion_complete'.tr} · $finishedCount/${controller.jobs.length}'
                          : '${current.statusMessage.value.tr} · $finishedCount/${controller.jobs.length}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Text(
                    '${(progress * 100).round()}%',
                    style: const TextStyle(
                      color: Color(0xFF4E5968),
                      fontSize: 12,
                    ),
                  ),
                  if (current != null)
                    IconButton(
                      tooltip: 'cancel'.tr,
                      onPressed: controller.cancelCurrent,
                      visualDensity: VisualDensity.compact,
                      icon: const Icon(Icons.stop_circle_outlined, size: 20),
                    ),
                  PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    iconSize: 20,
                    onSelected: (value) {
                      if (value == 'clear') controller.clearFinished();
                      if (value == 'results') _showJobs(context);
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(value: 'results', child: Text('Results')),
                      PopupMenuItem(
                        value: 'clear',
                        child: Text('Clear completed'),
                      ),
                    ],
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 3,
                  backgroundColor: const Color(0xFFD7E7FB),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showJobs(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.7,
        child: Obx(
          () => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.jobs.length,
            itemBuilder: (_, index) {
              final job = controller.jobs[index];
              return Obx(
                () => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: _statusIcon(job.status.value),
                  title: Text(job.fileName, maxLines: 1),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${job.options.format} · ${job.statusMessage.value.tr}',
                      ),
                      LinearProgressIndicator(value: job.progress.value),
                    ],
                  ),
                  trailing: _actionFor(job),
                  onTap: job.status.value == ConversionJobStatus.completed
                      ? () {
                          Get.back();
                          Get.toNamed(
                            Routes.CONVERT_RESULT,
                            arguments: {
                              'outputPath': job.outputPath.value,
                              'originalPath': job.inputPath,
                              'savedToGallery': job.savedToGallery.value,
                            },
                          );
                        }
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget? _actionFor(ConversionJob job) {
    if (job.status.value == ConversionJobStatus.queued) {
      return IconButton(
        onPressed: () => controller.cancelQueued(job.id),
        icon: const Icon(Icons.close),
      );
    }
    if (job.status.value == ConversionJobStatus.failed ||
        job.status.value == ConversionJobStatus.cancelled) {
      return IconButton(
        onPressed: () => controller.retry(job),
        icon: const Icon(Icons.refresh),
      );
    }
    if (job.status.value == ConversionJobStatus.completed) {
      return const Icon(Icons.chevron_right);
    }
    return null;
  }

  Widget _statusIcon(ConversionJobStatus status) => switch (status) {
    ConversionJobStatus.completed => const Icon(
      Icons.check_circle,
      color: Colors.green,
    ),
    ConversionJobStatus.failed => const Icon(Icons.error, color: Colors.red),
    ConversionJobStatus.cancelled => const Icon(
      Icons.cancel,
      color: Colors.grey,
    ),
    ConversionJobStatus.queued => const Icon(
      Icons.schedule,
      color: Colors.orange,
    ),
    _ => const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(strokeWidth: 2),
    ),
  };
}
