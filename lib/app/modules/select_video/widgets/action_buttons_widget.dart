import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/select_video_controller.dart';
import '../../../widgets/common/custom_elevated_button.dart';

class ActionButtonsWidget extends GetView<SelectVideoController> {
  const ActionButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Other Video 버튼
        CustomElevatedButton(
          onPressed: controller.selectOtherVideo,
          text: 'other_video'.tr,
          backgroundColor: const Color(0xFF9CA3AF),
          foregroundColor: Colors.white,
        ),

        const SizedBox(height: 8),

        // Video Rotate 버튼
        CustomElevatedButton(
          onPressed: controller.openRotateScreen,
          text: 'video_rotate'.tr,
          backgroundColor: const Color(0xFF8B5CF6),
          foregroundColor: Colors.white,
        ),

        const SizedBox(height: 8),

        // Video Trim 버튼
        CustomElevatedButton(
          onPressed: controller.openTrimScreen,
          text: 'video_trim'.tr,
          backgroundColor: const Color(0xFF34A853),
          foregroundColor: Colors.white,
        ),

        const SizedBox(height: 8),

        // Convert 버튼
        CustomElevatedButton(
          onPressed: () => controller.showConvertDialog(context),
          text: 'convert'.tr,
          backgroundColor: const Color(0xFF4285F4),
          foregroundColor: Colors.white,
        ),

        SizedBox(height: 16),
      ],
    );
  }
}
