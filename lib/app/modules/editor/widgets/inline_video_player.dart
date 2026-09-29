import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// 인라인으로 비디오 파일을 재생하는 위젯.
/// [filePath]만 주면 해당 파일을 로드해 재생한다.
class InlineVideoPlayer extends StatefulWidget {
  const InlineVideoPlayer({
    super.key,
    required this.filePath,
    this.aspectRatio = 16 / 9,
    this.autoPlay = false,
  });

  final String filePath;
  final double aspectRatio;
  final bool autoPlay;

  @override
  State<InlineVideoPlayer> createState() => _InlineVideoPlayerState();
}

class _InlineVideoPlayerState extends State<InlineVideoPlayer> {
  final _player = Player();
  late final VideoController _controller;
  bool _initialized = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _controller = VideoController(_player);
    _initializePlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _initializePlayer() async {
    try {
      final path = widget.filePath.replaceAll(r'\', '/');
      final media = Media('file://$path');
      await _player.open(media, play: widget.autoPlay);
      if (mounted) setState(() => _initialized = true);
    } catch (e, st) {
      if (mounted) setState(() => _error = e);
      assert(() {
        // ignore: avoid_print
        print('InlineVideoPlayer init error: $e\n$st');
        return true;
      }());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Container(
        width: double.infinity,
        color: Colors.black,
        child: _error != null
            ? Center(
                child: Text(
                  '영상을 불러올 수 없습니다.',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              )
            : !_initialized
                ? const Center(child: CircularProgressIndicator.adaptive())
                : Video(
                    controller: _controller,
                    fit: BoxFit.contain,
                  ),
      ),
    );
  }
}
