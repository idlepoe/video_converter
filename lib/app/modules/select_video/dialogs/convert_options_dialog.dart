import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/common/custom_elevated_button.dart';

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
  late String selectedFormat;

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
      selectedFormat = widget.savedSettings['selectedFormat'] ?? 'WebP';
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
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'convert_options'.tr,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),

              // Format Selection Section
              Text(
                'output_format'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              _buildFormatSelector(),
              const SizedBox(height: 24),

              // Resolution Section
              Text(
                'resolution'.tr,
                style: const TextStyle(
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
                'original_file_size'.trParams({'size': _getFileSizeString()}),
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      text: 'cancel'.tr,
                      backgroundColor: const Color(0xFF9CA3AF),
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context); // bottomSheet 먼저 닫기
                        await _saveSettings();
                      },
                      text: 'convert'.tr,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
      'selectedFormat': selectedFormat,
    };
    await widget.onConvert(options);
  }

  Widget _buildFormatSelector() {
    final formats = [
      {
        'name': 'WebP',
        'value': 'WebP',
        'descriptionKey': 'format_webp_description',
      },
      {
        'name': 'MP4',
        'value': 'MP4',
        'descriptionKey': 'format_mp4_description',
      },
      {
        'name': 'MKV',
        'value': 'MKV',
        'descriptionKey': 'format_mkv_description',
      },
      {
        'name': 'AVI',
        'value': 'AVI',
        'descriptionKey': 'format_avi_description',
      },
      {
        'name': 'FLV',
        'value': 'FLV',
        'descriptionKey': 'format_flv_description',
      },
      {
        'name': 'MOV',
        'value': 'MOV',
        'descriptionKey': 'format_mov_description',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedFormat,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          items: formats.map((format) {
            return DropdownMenuItem<String>(
              value: format['value']!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    format['name']!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    format['descriptionKey']!.toString().tr,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedFormat = newValue;
              });
            }
          },
        ),
      ),
    );
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

    // selectedResolution이 사용 가능한 옵션 중에 있는지 확인
    final availableIndices = resolutions.map((r) => r['index'] as int).toList();
    final currentValue = availableIndices.contains(selectedResolution)
        ? selectedResolution
        : availableIndices.first;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: currentValue,
          isExpanded: true,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          items: resolutions.map((resolution) {
            return DropdownMenuItem<int>(
              value: resolution['index'] as int,
              child: Text(
                resolution['name'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: (int? newValue) {
            if (newValue != null) {
              setState(() {
                selectedResolution = newValue;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildSliderSection(BuildContext context) {
    return Column(
      children: [
        _buildSlider(context, 'fps'.tr, fps, 1, 60, (value) {
          setState(() {
            fps = value;
          });
        }, defaultValue: 30.0),
        const SizedBox(height: 16),
        _buildSlider(context, 'quality'.tr, quality, 1, 100, (value) {
          setState(() {
            quality = value;
          });
        }, defaultValue: 85.0),
        const SizedBox(height: 16),
        _buildSlider(
          context,
          'playback_speed'.tr,
          speed,
          0.5,
          2.0,
          (value) {
            setState(() {
              speed = value;
            });
          },
          isSpeed: true,
          defaultValue: 1.0,
        ),
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
    double? defaultValue,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: InkWell(
            onTap: () {
              if (defaultValue != null) {
                onChanged(defaultValue);
              }
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[400]!, width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.blue,
              inactiveTrackColor: const Color(0xFFE5E8EB),
              thumbColor: Colors.blue,
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              onChanged: onChanged,
              activeColor: Colors.blue,
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
