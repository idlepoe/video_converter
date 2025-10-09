import 'package:get/get.dart';
import 'package:video_converter/app/routes/app_pages.dart';

class LoadingController extends GetxController {
  final count = 0.obs;
  final isLoading = true.obs;
  final progress = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _startLoading();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void _startLoading() async {
    // 3초 동안 로딩 시뮬레이션
    for (int i = 0; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      progress.value = i / 100;
    }

    // 로딩 완료 후 결과 화면으로 이동
    isLoading.value = false;
    // Get.offNamed(Routes.CONVERT_RESULT);
  }

  void increment() => count.value++;
}
