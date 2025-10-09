  void _showConvertDialog(BuildContext context) async {
    final originalWidth = controller.videoWidth.value ?? 0;
    final originalHeight = controller.videoHeight.value ?? 0;
    final videoDurationSeconds = controller.videoDuration.value?.inSeconds ?? 0;
    final videoFilePath = controller.videoFile.value!.path;

    // 저장된 설정 불러오기
    final savedSettings = await controller.loadConvertSettings();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Obx(() => ConvertOptionsDialog(
              originalWidth: originalWidth,
              originalHeight: originalHeight,
              videoDurationSeconds: videoDurationSeconds,
              videoFilePath: videoFilePath,
              savedSettings: savedSettings,
              isUploading: controller.isUploading.value,
              uploadPercent: controller.uploadPercent.value,
              onConvert: (options) async {
                controller.uploadAndRequestConvert(options);
              },
            ));
      },
    );
  }
