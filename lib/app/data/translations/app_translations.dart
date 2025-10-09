import 'package:get/get.dart';
import 'en.dart';
import 'es.dart';
import 'hi.dart';
import 'id.dart';
import 'ja.dart';
import 'ko.dart';
import 'ru.dart';
import 'zh.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': enTranslations,
    'es': esTranslations,
    'hi': hiTranslations,
    'id': idTranslations,
    'ja': jaTranslations,
    'ko': koTranslations,
    'ru': ruTranslations,
    'zh': zhTranslations,
  };
}
