import 'package:image_picker/image_picker.dart';

import 'conversion_job.dart';

class SelectedVideoItem {
  SelectedVideoItem({
    required this.id,
    required this.originalFile,
    required this.file,
    required this.width,
    required this.height,
    required this.duration,
    required this.options,
  });

  final String id;
  final XFile originalFile;
  XFile file;
  int width;
  int height;
  Duration duration;
  ConversionOptions options;
}
