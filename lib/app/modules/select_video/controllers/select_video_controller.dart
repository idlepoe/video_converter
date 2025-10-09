import 'dart:io';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../video_rotate/video_rotate_screen.dart';
import '../../video_trim/video_trim_screen.dart';

class SelectVideoController extends GetxController {
  final _picker = ImagePicker();
  final videoFile = Rxn<XFile>();
  final originalVideoFile = Rxn<XFile>();
  final videoPlayerController = Rxn<VideoPlayerController>();
  final isVideoSelected = false.obs;
  final videoInfo = Rxn<Map<String, dynamic>>();
  final isTrimmed = false.obs;
  final videoWidth = Rxn<int>();
  final videoHeight = Rxn<int>();
  final videoDuration = Rxn<Duration>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    videoPlayerController.value?.dispose();
    super.onClose();
  }

  Future<void> _initVideoPlayer(XFile file) async {
    try {
      videoPlayerController.value?.dispose();
      videoPlayerController.value = VideoPlayerController.file(File(file.path));
      await videoPlayerController.value!.initialize();
      isVideoSelected.value = true;
      _getVideoInfo(file);

      // 비디오 크기와 길이 정보 설정
      final size = videoPlayerController.value!.value.size;
      videoWidth.value = size.width.toInt();
      videoHeight.value = size.height.toInt();
      videoDuration.value = videoPlayerController.value!.value.duration;
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize video player: $e');
    }
  }

  void _getVideoInfo(XFile file) {
    final fileSize = File(file.path).lengthSync();
    videoInfo.value = {
      'fileName': file.name,
      'filePath': file.path,
      'fileSize': fileSize,
    };
  }

  void selectOtherVideo() {
    isVideoSelected.value = false;
    videoFile.value = null;
    originalVideoFile.value = null;
    videoPlayerController.value?.dispose();
    videoPlayerController.value = null;
    videoInfo.value = null;
    isTrimmed.value = false;
    videoWidth.value = null;
    videoHeight.value = null;
    videoDuration.value = null;
  }

  void openRotateScreen() async {
    if (videoFile.value == null) {
      Get.snackbar('Error', 'Please select a video file first');
      return;
    }

    // 비디오 회전 화면으로 네비게이션
    await Get.to(
      () => VideoRotateScreen(
        filePath: videoFile.value!.path,
        fileName: videoFile.value!.name,
        onRotateComplete: (String rotatedFilePath) {
          // 회전된 파일로 교체
          final rotatedFile = XFile(rotatedFilePath);
          videoFile.value = rotatedFile;
          isTrimmed.value = false; // 회전 후에는 trim 상태 초기화
          _initVideoPlayer(rotatedFile);

          // 성공 메시지
          Get.back(); // 회전 화면 닫기
        },
        onCancel: () {
          Get.back(); // 회전 화면 닫기
        },
      ),
    );
  }

  Future<void> restoreOriginal() async {
    if (originalVideoFile.value == null) {
      Get.snackbar('Error', 'No original file available');
      return;
    }

    try {
      videoFile.value = originalVideoFile.value;
      isTrimmed.value = false;
      await _initVideoPlayer(originalVideoFile.value!);
      Get.snackbar('Success', 'Original video restored');
    } catch (e) {
      Get.snackbar('Error', 'Failed to restore original video');
    }
  }

  Future<void> saveConvertSettings({
    required int selectedResolution,
    required double fps,
    required double quality,
    required String format,
    required double speed,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('convert_resolution', selectedResolution);
      await prefs.setDouble('convert_fps', fps);
      await prefs.setDouble('convert_quality', quality);
      await prefs.setString('convert_format', format);
      await prefs.setDouble('convert_speed', speed);
    } catch (e) {
      Get.snackbar('Error', 'Failed to save convert settings');
    }
  }

  // 설정 불러오기
  Future<Map<String, dynamic>> loadConvertSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      return {
        'selectedResolution':
            prefs.getInt('convert_resolution') ?? 0, // 기본값은 원본 해상도
        'fps': prefs.getDouble('convert_fps') ?? 30.0,
        'quality': prefs.getDouble('convert_quality') ?? 75.0,
        'format': prefs.getString('convert_format') ?? 'webp',
        'speed': prefs.getDouble('convert_speed') ?? 1.0,
      };
    } catch (e) {
      return {
        'selectedResolution': 0, // 기본값은 원본 해상도
        'fps': 30.0,
        'quality': 75.0,
        'format': 'webp',
        'speed': 1.0,
      };
    }
  }

  // Trim 화면으로 이동
  void openTrimScreen() async {
    if (videoFile.value == null) {
      Get.snackbar('Error', 'Please select a video file first');
      return;
    }

    // Trim 화면으로 네비게이션 (Get.to 사용하여 기존 컨트롤러 유지)
    final result = await Get.to(
      () => VideoTrimScreen(),
      arguments: {
        'filePath': videoFile.value!.path,
        'fileName': videoFile.value!.name,
      },
    );

    if (result != null && result is String) {
      // Trim된 파일로 교체
      final trimmedFile = XFile(result);
      videoFile.value = trimmedFile;
      isTrimmed.value = true; // Trim 상태 업데이트
      await _initVideoPlayer(trimmedFile);

      Get.snackbar('Success', 'Video trimmed successfully');
    }
  }

  Future<void> pickVideo() async {
    try {
      final XFile? file = await _picker.pickVideo(source: ImageSource.gallery);
      if (file != null) {
        videoFile.value = file;
        originalVideoFile.value = file; // 원본 파일 저장
        isTrimmed.value = false; // Trim 상태 초기화
        await _initVideoPlayer(file);
      }
    } catch (e) {
      // CommonSnackBar.error(
      //     'error'.tr, 'An error occurred while selecting the video.'.tr);
    }
  }

  void convertVideo() {
    if (videoFile.value != null) {
      // 비디오 변환 로직 구현
      Get.snackbar('Success', 'Video conversion started!');
    }
  }
}
