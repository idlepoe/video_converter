import 'package:get/get.dart';

import '../controllers/select_video_controller.dart';

class SelectVideoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectVideoController>(
      () => SelectVideoController(),
    );
  }
}
