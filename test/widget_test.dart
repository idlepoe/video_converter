import 'package:flutter_test/flutter_test.dart';
import 'package:video_converter/app/models/conversion_job.dart';
import 'package:video_converter/app/services/android_version_handler.dart';

void main() {
  test('conversion options create an immutable queue snapshot', () {
    final source = <String, dynamic>{
      'selectedResolution': 1,
      'fps': 24.0,
      'quality': 80.0,
      'speed': 1.5,
      'selectedFormat': 'MP4',
    };
    final options = ConversionOptions.fromMap(source);
    source['selectedFormat'] = 'WebP';

    expect(options.format, 'MP4');
    expect(options.selectedResolution, 1);
    expect(options.fps, 24);
    expect(options.quality, 80);
    expect(options.speed, 1.5);
  });

  test('FFmpeg command quotes paths and removes audio for WebP', () {
    final command = AndroidVersionHandler.instance.generateConvertCommand(
      inputPath: '/storage/emulated/0/video folder/input file.mp4',
      outputPath: '/data/user/0/cache/output file.webp',
      format: 'WebP',
      width: 854,
      height: 480,
      fps: 15,
      quality: 75,
      speed: 1,
    );

    expect(
      command,
      contains('-i "/storage/emulated/0/video folder/input file.mp4"'),
    );
    expect(command, contains('-an'));
    expect(command, isNot(contains('-c:a')));
    expect(command, endsWith('"/data/user/0/cache/output file.webp"'));
  });
}
