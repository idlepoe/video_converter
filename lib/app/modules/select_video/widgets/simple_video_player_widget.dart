import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class SimpleVideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController videoController;
  final double maxVideoHeight;
  final String fileName;
  final int? videoWidth;
  final int? videoHeight;
  final Duration? videoDuration;
  final String filePath;

  const SimpleVideoPlayerWidget({
    Key? key,
    required this.videoController,
    required this.maxVideoHeight,
    required this.fileName,
    required this.videoWidth,
    required this.videoHeight,
    required this.videoDuration,
    required this.filePath,
  }) : super(key: key);

  @override
  State<SimpleVideoPlayerWidget> createState() =>
      _SimpleVideoPlayerWidgetState();
}

class _SimpleVideoPlayerWidgetState extends State<SimpleVideoPlayerWidget> {
  bool _isDragging = false;
  double _dragValue = 0.0;
  VideoPlayerController? _currentController;

  @override
  void initState() {
    super.initState();
    _currentController = widget.videoController;
    _currentController?.addListener(_videoListener);
  }

  @override
  void didUpdateWidget(SimpleVideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoController != widget.videoController) {
      // 기존 컨트롤러에서 리스너 제거
      _currentController?.removeListener(_videoListener);
      // 새 컨트롤러에 리스너 추가
      _currentController = widget.videoController;
      _currentController?.addListener(_videoListener);
      // 드래그 상태 초기화
      setState(() {
        _isDragging = false;
        _dragValue = 0.0;
      });
    }
  }

  @override
  void dispose() {
    _currentController?.removeListener(_videoListener);
    super.dispose();
  }

  void _videoListener() {
    if (mounted && !_isDragging) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // 컨트롤러가 초기화되지 않았거나 dispose된 경우 처리
    if (!widget.videoController.value.isInitialized) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 32,
                height: widget.maxVideoHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      Container(
                        color: Colors.black,
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final duration = widget.videoController.value.duration;
    final position = _isDragging
        ? Duration(milliseconds: (_dragValue * duration.inMilliseconds).toInt())
        : widget.videoController.value.position;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 비디오 플레이어
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 32,
              height: widget.maxVideoHeight,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (widget.videoController.value.isInitialized) {
                      if (widget.videoController.value.isPlaying) {
                        widget.videoController.pause();
                      } else {
                        widget.videoController.play();
                      }
                    }
                  },
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: widget.maxVideoHeight,
                        color: Colors.black,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox(
                            width: widget.videoController.value.size.width,
                            height: widget.videoController.value.size.height,
                            child: VideoPlayer(widget.videoController),
                          ),
                        ),
                      ),
                      // 재생/일시정지 아이콘
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            widget.videoController.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      // 비디오 정보 (우측 하단)
                      Positioned(
                        bottom: 14,
                        right: 14,
                        child: Container(
                          width: 116,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                ' ${widget.fileName}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                '${widget.videoWidth ?? 0} x ${widget.videoHeight ?? 0}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDuration(
                                  widget.videoDuration ?? Duration.zero,
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatFileSize(
                                  File(widget.filePath).lengthSync(),
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 비디오 진행 슬라이더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              children: [
                Text(
                  _formatDuration(position),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.blue,
                      inactiveTrackColor: const Color(0xFFE5E8EB),
                      thumbColor: Colors.blue,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: duration.inMilliseconds > 0
                          ? position.inMilliseconds.toDouble() /
                                duration.inMilliseconds.toDouble()
                          : 0,
                      onChanged: (value) {
                        setState(() {
                          _isDragging = true;
                          _dragValue = value;
                        });
                      },
                      onChangeEnd: (value) {
                        if (widget.videoController.value.isInitialized) {
                          final newPosition = Duration(
                            milliseconds: (value * duration.inMilliseconds)
                                .toInt(),
                          );
                          widget.videoController.seekTo(newPosition);
                        }
                        setState(() {
                          _isDragging = false;
                        });
                      },
                    ),
                  ),
                ),
                Text(
                  _formatDuration(duration),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _formatFileSize(int size) {
    if (size < 1024) {
      return "$size bytes";
    } else if (size < 1024 * 1024) {
      return "${(size / 1024).toStringAsFixed(2)} KB";
    } else if (size < 1024 * 1024 * 1024) {
      return "${(size / (1024 * 1024)).toStringAsFixed(2)} MB";
    } else {
      return "${(size / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB";
    }
  }
}
