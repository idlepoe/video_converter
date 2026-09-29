import 'dart:async';
import 'dart:io';

import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:ffmpeg_kit_flutter_new/session.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../models/conversion_job.dart';
import 'android_version_handler.dart';
import 'notification_service.dart';

class BatchConversionService extends GetxService {
  final jobs = <ConversionJob>[].obs;
  final currentJob = Rxn<ConversionJob>();
  final isProcessing = false.obs;

  Session? _currentSession;
  bool _cancelCurrentRequested = false;
  bool _capabilityChecked = false;
  bool _isCapable = false;

  int get queuedCount => jobs
      .where((job) => job.status.value == ConversionJobStatus.queued)
      .length;

  int get completedCount => jobs
      .where((job) => job.status.value == ConversionJobStatus.completed)
      .length;

  int get failedCount => jobs
      .where((job) => job.status.value == ConversionJobStatus.failed)
      .length;

  double get overallProgress {
    final activeJobs = jobs
        .where((job) => job.status.value != ConversionJobStatus.cancelled)
        .toList();
    if (activeJobs.isEmpty) return 0;
    final total = activeJobs.fold<double>(0, (sum, job) {
      if (job.status.value == ConversionJobStatus.completed ||
          job.status.value == ConversionJobStatus.failed) {
        return sum + 1;
      }
      return sum + job.progress.value;
    });
    return (total / activeJobs.length).clamp(0, 1);
  }

  void enqueue(ConversionJob job) {
    jobs.add(job);
    _processQueue();
  }

  Future<void> cancelCurrent() async {
    final job = currentJob.value;
    if (job == null) return;
    _cancelCurrentRequested = true;
    job.status.value = ConversionJobStatus.cancelled;
    job.statusMessage.value = 'conversion_cancelled';
    await _currentSession?.cancel();
  }

  void cancelQueued(String id) {
    final job = jobs.firstWhereOrNull((item) => item.id == id);
    if (job?.status.value != ConversionJobStatus.queued) return;
    job!.status.value = ConversionJobStatus.cancelled;
    job.statusMessage.value = 'conversion_cancelled';
  }

  void clearFinished() {
    jobs.removeWhere((job) => job.isFinished && job != currentJob.value);
  }

  Future<void> retry(ConversionJob job) async {
    if (job.status.value != ConversionJobStatus.failed &&
        job.status.value != ConversionJobStatus.cancelled) {
      return;
    }
    job
      ..progress.value = 0
      ..errorMessage.value = null
      ..outputPath.value = null
      ..savedToGallery.value = false
      ..status.value = ConversionJobStatus.queued
      ..statusMessage.value = 'preparing_conversion';
    await _processQueue();
  }

  Future<void> _processQueue() async {
    if (isProcessing.value) return;
    isProcessing.value = true;
    try {
      while (true) {
        final next = jobs.firstWhereOrNull(
          (job) => job.status.value == ConversionJobStatus.queued,
        );
        if (next == null) break;
        currentJob.value = next;
        await _convert(next);
      }
    } finally {
      _currentSession = null;
      currentJob.value = null;
      isProcessing.value = false;
    }
  }

  Future<void> _ensureCapability() async {
    if (_capabilityChecked) {
      if (!_isCapable) throw Exception('FFmpeg is not available');
      return;
    }
    await AndroidVersionHandler.instance.initialize();
    _isCapable = await AndroidVersionHandler.instance.checkFFmpegCapability();
    _capabilityChecked = true;
    if (!_isCapable) throw Exception('FFmpeg is not available');
  }

  Future<void> _convert(ConversionJob job) async {
    File? outputFile;
    _cancelCurrentRequested = false;
    try {
      job.status.value = ConversionJobStatus.preparing;
      job.statusMessage.value = 'preparing_conversion';
      await _ensureCapability();

      final inputFile = File(job.inputPath);
      if (!await inputFile.exists()) {
        throw Exception('Input file no longer exists');
      }

      final dimensions = _targetDimensions(job);
      final tempDir = await getTemporaryDirectory();
      final extension = _fileExtension(job.options.format);
      outputFile = File(
        '${tempDir.path}${Platform.pathSeparator}video_converter_${job.id}.$extension',
      );
      job.outputPath.value = outputFile.path;

      final command = AndroidVersionHandler.instance.generateConvertCommand(
        inputPath: job.inputPath,
        outputPath: outputFile.path,
        format: job.options.format,
        width: dimensions.$1,
        height: dimensions.$2,
        fps: job.options.fps,
        quality: job.options.quality,
        speed: job.options.speed,
      );

      job.status.value = ConversionJobStatus.converting;
      job.statusMessage.value = 'converting';
      final completer = Completer<bool>();
      final expectedMilliseconds =
          (job.duration.inMilliseconds / job.options.speed).round();

      _currentSession = await FFmpegKit.executeAsync(
        command,
        (session) async {
          final returnCode = await session.getReturnCode();
          if (!completer.isCompleted) {
            completer.complete(ReturnCode.isSuccess(returnCode));
          }
        },
        (_) {},
        (statistics) {
          if (expectedMilliseconds <= 0) return;
          job.progress.value = (statistics.getTime() / expectedMilliseconds)
              .clamp(0, 0.95);
        },
      );

      final succeeded = await completer.future;
      _currentSession = null;
      if (_cancelCurrentRequested) {
        await _deleteIfPresent(outputFile);
        return;
      }
      if (!succeeded) throw Exception('FFmpeg conversion failed');

      job.status.value = ConversionJobStatus.saving;
      job.statusMessage.value = 'saving_to_gallery';
      final saved = job.options.format == 'WebP'
          ? await GallerySaver.saveImage(outputFile.path)
          : await GallerySaver.saveVideo(outputFile.path);

      job.savedToGallery.value = saved == true;
      job.progress.value = 1;
      job.status.value = ConversionJobStatus.completed;
      job.statusMessage.value = saved == true
          ? 'conversion_completed_saved'
          : 'conversion_completed_not_saved';

      await NotificationService.showConversionCompleteNotification(
        fileName: outputFile.path.split(Platform.pathSeparator).last,
        format: job.options.format,
      );
    } catch (error) {
      if (_cancelCurrentRequested) {
        job.status.value = ConversionJobStatus.cancelled;
        job.statusMessage.value = 'conversion_cancelled';
        if (outputFile != null) await _deleteIfPresent(outputFile);
        return;
      }
      job.status.value = ConversionJobStatus.failed;
      job.statusMessage.value = 'conversion_failed';
      job.errorMessage.value = error.toString();
      await NotificationService.showConversionErrorNotification(
        errorMessage: error.toString(),
      );
    }
  }

  (int, int) _targetDimensions(ConversionJob job) {
    var width = job.width;
    var height = job.height;
    final requestedHeight = switch (job.options.selectedResolution) {
      1 => 720,
      2 => 480,
      3 => 320,
      _ => height,
    };
    if (requestedHeight > 0 && requestedHeight < height && height > 0) {
      width = (requestedHeight * width / height).round();
      height = requestedHeight;
    }
    width = width <= 0 ? 2 : width - (width % 2);
    height = height <= 0 ? 2 : height - (height % 2);
    return (width, height);
  }

  String _fileExtension(String format) => switch (format) {
    'MP4' => 'mp4',
    'MKV' => 'mkv',
    'AVI' => 'avi',
    'FLV' => 'flv',
    'MOV' => 'mov',
    _ => 'webp',
  };

  Future<void> _deleteIfPresent(File file) async {
    if (await file.exists()) await file.delete();
  }
}
