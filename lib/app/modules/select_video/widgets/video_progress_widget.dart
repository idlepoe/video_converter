import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/select_video_controller.dart';

class VideoProgressWidget extends GetView<SelectVideoController> {
  final bool outside;

  const VideoProgressWidget({super.key, this.outside = false});

  @override
  Widget build(BuildContext context) {
    final vController = controller.videoPlayerController.value!;
    const active = Color(0xFF0064FF);
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: vController,
      builder: (context, value, _) {
        final Duration duration = value.duration == Duration.zero
            ? const Duration()
            : value.duration;
        final Duration position = value.position;
        final int totalMs = duration.inMilliseconds == 0
            ? 1
            : duration.inMilliseconds;
        final double progress =
            position.inMilliseconds.clamp(0, totalMs) / totalMs;
        final bar = Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                _formatDurationMinutes(position),
                style: TextStyle(
                  fontSize: 10,
                  color: outside ? Colors.black87 : Colors.white,
                ),
              ),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8,
                  ),
                  overlayShape: const RoundSliderOverlayShape(
                    overlayRadius: 16,
                  ),
                ),
                child: Slider(
                  value: progress.isNaN ? 0 : progress,
                  onChanged: (double v) {
                    final int targetMs = (totalMs * v).toInt();
                    vController.seekTo(Duration(milliseconds: targetMs));
                  },
                  activeColor: active,
                  inactiveColor:
                      (outside ? Colors.black.withOpacity(0.15) : Colors.white)
                          .withOpacity(0.4),
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: Text(
                _formatDurationMinutes(duration),
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 10,
                  color: outside ? Colors.black87 : Colors.white,
                ),
              ),
            ),
          ],
        );

        if (outside) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: bar,
          );
        }

        return bar;
      },
    );
  }

  String _formatDurationMinutes(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
