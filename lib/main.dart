import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:video_converter/app/data/translations/app_translations.dart';
import 'package:video_converter/app/services/notification_service.dart';
import 'package:video_converter/app/services/batch_conversion_service.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 알림 서비스 초기화
  await NotificationService.initialize();
  Get.put(BatchConversionService(), permanent: true);

  runApp(
    GetMaterialApp(
      title: "WebpConverter",
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en'),
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3182F6),
          brightness: Brightness.light,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Color(0xFF3182F6),
          linearTrackColor: Color(0xFFE5E8EB),
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: Color(0xFF3182F6),
          thumbColor: Color(0xFF3182F6),
          overlayColor: Color(0x223182F6),
        ),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => Container(
        color: Colors.white,
        child: SafeArea(child: child ?? const SizedBox.shrink()),
      ),
    ),
  );
}
