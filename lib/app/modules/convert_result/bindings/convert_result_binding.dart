import 'package:get/get.dart';

import '../controllers/convert_result_controller.dart';

class ConvertResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConvertResultController>(
      () => ConvertResultController(),
    );
  }
}
