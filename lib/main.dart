import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:video_converter/app/data/translations/app_translations.dart';
import 'package:video_converter/app/services/notification_service.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 알림 서비스 초기화
  await NotificationService.initialize();

  runApp(
    GetMaterialApp(
      title: "Application",
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en'),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      builder: (context, child) =>
          SafeArea(child: child ?? const SizedBox.shrink()),
    ),
  );
}
