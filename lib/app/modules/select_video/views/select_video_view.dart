import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/select_video_controller.dart';
import '../widgets/empty_video_widget.dart';
import '../widgets/simple_video_player_widget.dart';
import '../widgets/action_buttons_widget.dart';

class SelectVideoView extends GetView<SelectVideoController> {
  const SelectVideoView({super.key});

  @override
  Widget build(BuildContext context) {
    final maxVideoHeight = MediaQuery.of(context).size.height * 0.4;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text(
          'Video Converter',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.videoFile.value == null) {
          return EmptyVideoWidget(onPickVideo: controller.pickVideo);
        } else {
          final videoController = controller.videoPlayerController.value;
          if (videoController == null || !videoController.value.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // 비디오 플레이어 영역
              Expanded(
                child: SimpleVideoPlayerWidget(
                  key: ValueKey(
                    controller.videoFile.value!.path,
                  ), // 파일 경로를 키로 사용
                  videoController: videoController,
                  maxVideoHeight: maxVideoHeight,
                  fileName: controller.videoFile.value!.name,
                  videoWidth: controller.videoWidth.value,
                  videoHeight: controller.videoHeight.value,
                  videoDuration: controller.videoDuration.value,
                  filePath: controller.videoFile.value!.path,
                ),
              ),
              // 액션 버튼들
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const ActionButtonsWidget(),
              ),
            ],
          );
        }
      }),
    );
  }
}
