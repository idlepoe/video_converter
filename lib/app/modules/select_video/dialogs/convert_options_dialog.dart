import 'dart:io';
import 'package:flutter/material.dart';

class ConvertOptionsDialog extends StatefulWidget {
  final int originalWidth;
  final int originalHeight;
  final int videoDurationSeconds;
  final String videoFilePath;
  final Map<String, dynamic> savedSettings;
  final Function(Map<String, dynamic>) onConvert;

  const ConvertOptionsDialog({
    super.key,
    required this.originalWidth,
    required this.originalHeight,
    required this.videoDurationSeconds,
    required this.videoFilePath,
    required this.savedSettings,
    required this.onConvert,
  });

  @override
  State<ConvertOptionsDialog> createState() => _ConvertOptionsDialogState();
}

class _ConvertOptionsDialogState extends State<ConvertOptionsDialog> {
  late int selectedResolution;
  late double fps;
  late double quality;
  late String format;
  late double speed;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() {
      selectedResolution = widget.savedSettings['selectedResolution'];
      fps = widget.savedSettings['fps'];
      quality = widget.savedSettings['quality'];
      format = widget.savedSettings['format'];
      speed = widget.savedSettings['speed'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Convert Options',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),

            // Resolution Section
            const Text(
              'Resolution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            _buildResolutionOptions(),
            const SizedBox(height: 24),

            // Sliders Section
            _buildSliderSection(context),
            const SizedBox(height: 24),

            // File Size Info
            Text(
              'Original File Size: ${_getFileSizeString()}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF6B7280),
                        side: const BorderSide(
                          color: Color(0xFFE5E7EB),
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context); // bottomSheet 먼저 닫기
                        await _saveSettings();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0064FF),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Convert',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _saveSettings() async {
    // 변환 옵션을 onConvert 콜백으로 전달
    final options = {
      'selectedResolution': selectedResolution,
      'fps': fps,
      'quality': quality,
      'format': format,
      'speed': speed,
    };
    await widget.onConvert(options);
  }

  Widget _buildResolutionOptions() {
    final originalWidth = widget.originalWidth;
    final originalHeight = widget.originalHeight;
    final aspectRatio = originalWidth / originalHeight;

    final resolutions = <Map<String, dynamic>>[];

    // Original resolution
    resolutions.add({
      'name': 'original (${originalWidth} x ${originalHeight})',
      'width': originalWidth,
      'height': originalHeight,
      'index': 0,
    });

    // 720p if original is higher
    if (originalHeight > 720) {
      final width = (aspectRatio * 720).round();
      resolutions.add({
        'name': '720p (${width} x 720)',
        'width': width,
        'height': 720,
        'index': 1,
      });
    }

    // 480p if original is higher
    if (originalHeight > 480) {
      final width = (aspectRatio * 480).round();
      resolutions.add({
        'name': '480p (${width} x 480)',
        'width': width,
        'height': 480,
        'index': 2,
      });
    }

    // 320p if original is higher
    if (originalHeight > 320) {
      final width = (aspectRatio * 320).round();
      resolutions.add({
        'name': '320p (${width} x 320)',
        'width': width,
        'height': 320,
        'index': 3,
      });
    }

    return Column(
      children: resolutions.map((resolution) {
        final isSelected = selectedResolution == resolution['index'];
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () {
              setState(() {
                selectedResolution = resolution['index'];
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE9F1FF) : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0064FF)
                      : Colors.grey[300]!,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      resolution['name'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF0064FF)
                            : Colors.black87,
                      ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check, color: Color(0xFF0064FF), size: 20),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSliderSection(BuildContext context) {
    return Column(
      children: [
        _buildSlider(context, 'FPS', fps, 1, 60, (value) {
          setState(() {
            fps = value;
          });
        }),
        const SizedBox(height: 16),
        _buildSlider(context, 'Quality', quality, 1, 100, (value) {
          setState(() {
            quality = value;
          });
        }),
        const SizedBox(height: 16),
        _buildSlider(context, 'Playback Speed', speed, 0.5, 2.0, (value) {
          setState(() {
            speed = value;
          });
        }, isSpeed: true),
      ],
    );
  }

  Widget _buildSlider(
    BuildContext context,
    String label,
    double value,
    double min,
    double max,
    Function(double) onChanged, {
    bool isSpeed = false,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
              activeColor: const Color(0xFF0064FF),
              inactiveColor: Colors.grey[300],
            ),
          ),
        ),
        SizedBox(
          width: 60,
          child: Text(
            isSpeed ? '${value.toStringAsFixed(2)}x' : value.toInt().toString(),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  String _getFileSizeString() {
    try {
      final file = File(widget.videoFilePath);
      final fileSize = file.lengthSync();
      final sizeInMB = fileSize / (1024 * 1024);
      return '${sizeInMB.toStringAsFixed(2)} MB';
    } catch (e) {
      return '0.00 MB';
    }
  }
}
