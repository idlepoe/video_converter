import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/loading_controller.dart';

class LoadingView extends GetView<LoadingController> {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Converting...',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(
        () => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 원형 프로그레스 인디케이터
                SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    children: [
                      // 배경 원
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 8,
                          ),
                        ),
                      ),
                      // 진행률 원
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: controller.progress.value,
                          strokeWidth: 8,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF0064FF),
                          ),
                        ),
                      ),
                      // 중앙 퍼센트 텍스트
                      Center(
                        child: Text(
                          '${(controller.progress.value * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Converting... 제목
                const Text(
                  'Converting...',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // 설명 텍스트
                Text(
                  'The progress bar is an estimate. Actual conversion speed may vary.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // 작업 중 메시지 박스
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0064FF),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Still working hard on your video!',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0064FF),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('🚀', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 알림 설정 체크박스
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: true,
                            onChanged: (value) {
                              // 체크박스 상태 변경 로직
                            },
                            activeColor: const Color(0xFF0064FF),
                          ),
                          const Text(
                            'Get conversion notification',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Feel free to step out! We\'ll notify you when the conversion is done!',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0064FF),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 상태 메시지
                Obx(
                  () => Text(
                    controller.statusMessage.value,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
