import 'package:flutter_test/flutter_test.dart';
import 'package:video_converter/app/models/conversion_job.dart';

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
}
