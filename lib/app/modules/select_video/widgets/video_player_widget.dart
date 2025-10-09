import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/select_video_controller.dart';

class VideoPlayerWidget extends GetView<SelectVideoController> {
  const VideoPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return controller.videoPlayerController.value != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(controller.videoPlayerController.value!),
                Obx(
                  () => GestureDetector(
                    onTap: () {
                      if (controller
                          .videoPlayerController
                          .value!
                          .value
                          .isPlaying) {
                        controller.videoPlayerController.value!.pause();
                      } else {
                        controller.videoPlayerController.value!.play();
                      }
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        controller.videoPlayerController.value!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
