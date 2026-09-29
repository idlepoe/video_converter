import 'package:get/get.dart';

enum ConversionJobStatus {
  queued,
  preparing,
  converting,
  saving,
  completed,
  failed,
  cancelled,
}

class ConversionOptions {
  const ConversionOptions({
    required this.selectedResolution,
    required this.fps,
    required this.quality,
    required this.speed,
    required this.format,
  });

  final int selectedResolution;
  final double fps;
  final double quality;
  final double speed;
  final String format;

  factory ConversionOptions.fromMap(Map<String, dynamic> value) {
    return ConversionOptions(
      selectedResolution: value['selectedResolution'] as int? ?? 0,
      fps: (value['fps'] as num? ?? 30).toDouble(),
      quality: (value['quality'] as num? ?? 75).toDouble(),
      speed: (value['speed'] as num? ?? 1).toDouble(),
      format: value['selectedFormat'] as String? ?? 'WebP',
    );
  }

  Map<String, dynamic> toMap() => {
    'selectedResolution': selectedResolution,
    'fps': fps,
    'quality': quality,
    'speed': speed,
    'format': format.toLowerCase(),
    'selectedFormat': format,
  };
}

class ConversionJob {
  ConversionJob({
    required this.id,
    required this.inputPath,
    required this.fileName,
    required this.width,
    required this.height,
    required this.duration,
    required this.options,
  });

  final String id;
  final String inputPath;
  final String fileName;
  final int width;
  final int height;
  final Duration duration;
  final ConversionOptions options;

  final status = ConversionJobStatus.queued.obs;
  final progress = 0.0.obs;
  final statusMessage = 'preparing_conversion'.obs;
  final outputPath = RxnString();
  final errorMessage = RxnString();
  final savedToGallery = false.obs;

  bool get isFinished =>
      status.value == ConversionJobStatus.completed ||
      status.value == ConversionJobStatus.failed ||
      status.value == ConversionJobStatus.cancelled;
}
