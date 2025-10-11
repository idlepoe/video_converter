import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_new/return_code.dart';
import 'package:get/get.dart';

/// Android 버전별 FFmpeg 처리 분기를 담당하는 유틸리티 클래스
class AndroidVersionHandler {
  static AndroidVersionHandler? _instance;
  static AndroidVersionHandler get instance =>
      _instance ??= AndroidVersionHandler._();

  AndroidVersionHandler._();

  AndroidDeviceInfo? _androidInfo;
  bool _isInitialized = false;

  /// 디바이스 정보 초기화
  Future<void> initialize() async {
    if (_isInitialized) return;

    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      _androidInfo = await deviceInfo.androidInfo;
    }
    _isInitialized = true;
  }

  /// Android 버전 정보 가져오기
  AndroidDeviceInfo? get androidInfo => _androidInfo;

  /// Android API 레벨 가져오기
  int get apiLevel => _androidInfo?.version.sdkInt ?? 0;

  /// 지원되는 아키텍처 목록
  List<String> get supportedAbis => _androidInfo?.supportedAbis ?? [];

  /// 디바이스 브랜드
  String get brand => _androidInfo?.brand ?? 'Unknown';

  /// 디바이스 모델
  String get model => _androidInfo?.model ?? 'Unknown';

  /// Android 버전별 분기 처리
  AndroidVersionCategory get versionCategory {
    if (apiLevel >= 30) return AndroidVersionCategory.modern; // Android 11+
    if (apiLevel >= 24)
      return AndroidVersionCategory.intermediate; // Android 7-10
    return AndroidVersionCategory.legacy; // Android 6 이하
  }

  /// FFmpeg 명령어 호환성 체크
  Future<bool> checkFFmpegCapability() async {
    try {
      // 간단한 테스트 명령어로 FFmpeg 기능 확인
      final testCommand =
          '-f lavfi -i testsrc=duration=1:size=320x240:rate=1 -f null -';
      final session = await FFmpegKit.execute(testCommand);
      final returnCode = await session.getReturnCode();
      return ReturnCode.isSuccess(returnCode);
    } catch (e) {
      print('FFmpeg capability check failed: $e');
      return false;
    }
  }

  /// 비디오 회전 명령어 생성 (버전별 최적화)
  String generateRotateCommand(
    String inputPath,
    String outputPath,
    int rotation,
  ) {
    final escapedInput = _escapePath(inputPath);
    final escapedOutput = _escapePath(outputPath);

    switch (versionCategory) {
      case AndroidVersionCategory.modern:
        return _generateModernRotateCommand(
          escapedInput,
          escapedOutput,
          rotation,
        );
      case AndroidVersionCategory.intermediate:
        return _generateIntermediateRotateCommand(
          escapedInput,
          escapedOutput,
          rotation,
        );
      case AndroidVersionCategory.legacy:
        return _generateLegacyRotateCommand(
          escapedInput,
          escapedOutput,
          rotation,
        );
    }
  }

  /// 비디오 변환 명령어 생성 (버전별 최적화)
  String generateConvertCommand({
    required String inputPath,
    required String outputPath,
    required String format,
    required int width,
    required int height,
    required double fps,
    required double quality,
    required double speed,
  }) {
    final escapedInput = _escapePath(inputPath);
    final escapedOutput = _escapePath(outputPath);

    switch (versionCategory) {
      case AndroidVersionCategory.modern:
        return _generateModernConvertCommand(
          escapedInput,
          escapedOutput,
          format,
          width,
          height,
          fps,
          quality,
          speed,
        );
      case AndroidVersionCategory.intermediate:
        return _generateIntermediateConvertCommand(
          escapedInput,
          escapedOutput,
          format,
          width,
          height,
          fps,
          quality,
          speed,
        );
      case AndroidVersionCategory.legacy:
        return _generateLegacyConvertCommand(
          escapedInput,
          escapedOutput,
          format,
          width,
          height,
          fps,
          quality,
          speed,
        );
    }
  }

  /// 최신 Android용 회전 명령어 (고급 기능 사용)
  String _generateModernRotateCommand(
    String inputPath,
    String outputPath,
    int rotation,
  ) {
    switch (rotation) {
      case 90:
        return '-i $inputPath -vf "transpose=1" -c:a copy -preset fast $outputPath';
      case 180:
        return '-i $inputPath -vf "transpose=1,transpose=1" -c:a copy -preset fast $outputPath';
      case 270:
        return '-i $inputPath -vf "transpose=2" -c:a copy -preset fast $outputPath';
      default:
        throw Exception(
          'error_rotation_general'.trParams({
            'error': 'Unsupported rotation angle: $rotation',
          }),
        );
    }
  }

  /// 중간 Android용 회전 명령어 (안정성 우선)
  String _generateIntermediateRotateCommand(
    String inputPath,
    String outputPath,
    int rotation,
  ) {
    switch (rotation) {
      case 90:
        return '-i $inputPath -vf "transpose=1" -c:a copy -preset medium $outputPath';
      case 180:
        return '-i $inputPath -vf "transpose=1,transpose=1" -c:a copy -preset medium $outputPath';
      case 270:
        return '-i $inputPath -vf "transpose=2" -c:a copy -preset medium $outputPath';
      default:
        throw Exception(
          'error_rotation_general'.trParams({
            'error': 'Unsupported rotation angle: $rotation',
          }),
        );
    }
  }

  /// 구형 Android용 회전 명령어 (호환성 우선)
  String _generateLegacyRotateCommand(
    String inputPath,
    String outputPath,
    int rotation,
  ) {
    switch (rotation) {
      case 90:
        return '-i $inputPath -vf "transpose=1" -c:a copy -preset slow $outputPath';
      case 180:
        return '-i $inputPath -vf "transpose=1,transpose=1" -c:a copy -preset slow $outputPath';
      case 270:
        return '-i $inputPath -vf "transpose=2" -c:a copy -preset slow $outputPath';
      default:
        throw Exception(
          'error_rotation_general'.trParams({
            'error': 'Unsupported rotation angle: $rotation',
          }),
        );
    }
  }

  /// 최신 Android용 변환 명령어
  String _generateModernConvertCommand(
    String inputPath,
    String outputPath,
    String format,
    int width,
    int height,
    double fps,
    double quality,
    double speed,
  ) {
    final videoCodec = _getVideoCodec(format);
    final audioCodec = _getAudioCodec(format);

    String command = '-i $inputPath';
    command += ' -c:v $videoCodec';
    command += ' -c:a $audioCodec';
    command += ' -r $fps';
    command += ' -s ${width}x$height';

    // 포맷별 최적화 옵션
    if (format == 'WebP') {
      command += ' -quality ${quality.toInt()} -loop 0';
    } else if (format == 'MP4' || format == 'MOV') {
      command += ' -crf ${_getCrfValue(quality)} -preset fast';
    } else {
      command += ' -q:v ${_getQValue(quality)}';
    }

    // 배속 처리
    if (speed != 1.0) {
      command += ' -filter:v "setpts=${1 / speed}*PTS"';
    }

    command += ' $outputPath';
    return command;
  }

  /// 중간 Android용 변환 명령어
  String _generateIntermediateConvertCommand(
    String inputPath,
    String outputPath,
    String format,
    int width,
    int height,
    double fps,
    double quality,
    double speed,
  ) {
    final videoCodec = _getVideoCodec(format);
    final audioCodec = _getAudioCodec(format);

    String command = '-i $inputPath';
    command += ' -c:v $videoCodec';
    command += ' -c:a $audioCodec';
    command += ' -r $fps';
    command += ' -s ${width}x$height';

    // 포맷별 옵션 (안정성 우선)
    if (format == 'WebP') {
      command += ' -quality ${quality.toInt()} -loop 0';
    } else if (format == 'MP4' || format == 'MOV') {
      command += ' -crf ${_getCrfValue(quality)} -preset medium';
    } else {
      command += ' -q:v ${_getQValue(quality)}';
    }

    // 단순한 배속 처리
    if (speed != 1.0) {
      command += ' -filter:v "setpts=${1 / speed}*PTS"';
    }

    command += ' $outputPath';
    return command;
  }

  /// 구형 Android용 변환 명령어
  String _generateLegacyConvertCommand(
    String inputPath,
    String outputPath,
    String format,
    int width,
    int height,
    double fps,
    double quality,
    double speed,
  ) {
    final videoCodec = _getVideoCodec(format);
    final audioCodec = _getAudioCodec(format);

    String command = '-i $inputPath';
    command += ' -c:v $videoCodec';
    command += ' -c:a $audioCodec';
    command += ' -r $fps';
    command += ' -s ${width}x$height';

    // 포맷별 옵션 (호환성 우선)
    if (format == 'WebP') {
      command += ' -quality ${quality.toInt()} -loop 0';
    } else if (format == 'MP4' || format == 'MOV') {
      command += ' -crf ${_getCrfValue(quality)} -preset slow';
    } else {
      command += ' -q:v ${_getQValue(quality)}';
    }

    // 배속 처리 (단순화)
    if (speed != 1.0) {
      command += ' -filter:v "setpts=${1 / speed}*PTS"';
    }

    command += ' $outputPath';
    return command;
  }

  /// 비디오 코덱 가져오기
  String _getVideoCodec(String format) {
    switch (format) {
      case 'WebP':
        return 'libwebp';
      case 'MP4':
        return 'libx264';
      case 'MOV':
        return 'libx264';
      case 'MKV':
        return 'libx264';
      case 'AVI':
        return 'libx264';
      case 'FLV':
        return 'libx264';
      default:
        return 'libx264';
    }
  }

  /// 오디오 코덱 가져오기
  String _getAudioCodec(String format) {
    switch (format) {
      case 'WebP':
        return 'aac';
      case 'MP4':
        return 'aac';
      case 'MOV':
        return 'aac';
      case 'MKV':
        return 'aac';
      case 'AVI':
        return 'aac';
      case 'FLV':
        return 'aac';
      default:
        return 'aac';
    }
  }

  /// CRF 값 계산
  int _getCrfValue(double quality) {
    // quality: 0-100 -> CRF: 51-0
    return (51 - (quality * 0.51)).round().clamp(0, 51);
  }

  /// Q 값 계산
  int _getQValue(double quality) {
    // quality: 0-100 -> Q: 31-0
    return (31 - (quality * 0.31)).round().clamp(0, 31);
  }

  /// 파일 경로 이스케이프 처리
  String _escapePath(String path) {
    return path
        .replaceAll(' ', '\\ ')
        .replaceAll('(', '\\(')
        .replaceAll(')', '\\)')
        .replaceAll('[', '\\[')
        .replaceAll(']', '\\]')
        .replaceAll('&', '\\&');
  }

  /// 디바이스 정보 로깅
  void logDeviceInfo() {
    if (_androidInfo != null) {
      print('=== Device Information ===');
      print('Brand: ${_androidInfo!.brand}');
      print('Model: ${_androidInfo!.model}');
      print('Android Version: ${_androidInfo!.version.release}');
      print('API Level: ${_androidInfo!.version.sdkInt}');
      print('Supported ABIs: ${_androidInfo!.supportedAbis}');
      print('Version Category: $versionCategory');
      print('========================');
    }
  }
}

/// Android 버전 카테고리
enum AndroidVersionCategory {
  modern, // Android 11+ (API 30+)
  intermediate, // Android 7-10 (API 24-29)
  legacy, // Android 6 이하 (API 23 이하)
}
