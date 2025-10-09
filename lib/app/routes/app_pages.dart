import 'package:get/get.dart';

import '../modules/convert_result/bindings/convert_result_binding.dart';
import '../modules/convert_result/views/convert_result_view.dart';
import '../modules/loading/bindings/loading_binding.dart';
import '../modules/loading/views/loading_view.dart';
import '../modules/select_video/bindings/select_video_binding.dart';
import '../modules/select_video/views/select_video_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SELECT_VIDEO;

  static final routes = [
    GetPage(
      name: _Paths.SELECT_VIDEO,
      page: () => const SelectVideoView(),
      binding: SelectVideoBinding(),
    ),
    GetPage(
      name: _Paths.LOADING,
      page: () => const LoadingView(),
      binding: LoadingBinding(),
    ),
    GetPage(
      name: _Paths.CONVERT_RESULT,
      page: () => const ConvertResultView(),
      binding: ConvertResultBinding(),
    ),
  ];
}
