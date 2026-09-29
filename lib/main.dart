import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';

import 'package:get/get.dart';
import 'package:video_converter/app/data/translations/app_translations.dart';
import 'package:video_converter/app/services/notification_service.dart';
import 'package:video_converter/app/services/batch_conversion_service.dart';
import 'package:video_converter/app/theme/app_theme.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();

  // 알림 서비스 초기화
  await NotificationService.initialize();
  Get.put(BatchConversionService(), permanent: true);

  runApp(
    GetMaterialApp(
      title: "WebpConverter",
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en'),
      theme: AppTheme.light,
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
