import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Web kontrolü için
import 'dart:ui' as ui; // Web'de dil almak için bunu kullanacağız

class LocalizationService {
  static Map<String, String>? _localizedStrings;
  static String currentLang = 'en';
  static const List<String> supportedLanguages = ['en', 'tr', 'it', 'de', 'es', 'pt', 'ru'];

  static Future<void> load() async {
    String deviceLocale = 'en';

    try {
      if (kIsWeb) {
        // Tarayıcı dili
        deviceLocale = ui.window.locale.languageCode;
      } else {
        // Mobil cihaz dili (dart:io yerine platform kanalı)
        deviceLocale = ui.window.locale.languageCode;
      }
    } catch (e) {
      deviceLocale = 'en';
    }

    currentLang = supportedLanguages.contains(deviceLocale) ? deviceLocale : 'en';
    await _loadJson();
  }

  static Future<void> changeLanguage(String langCode) async {
    if (supportedLanguages.contains(langCode)) {
      currentLang = langCode;
      await _loadJson();
    }
  }

  static Future<void> _loadJson() async {
    // Assets yolunun web'de tam doğru olduğundan emin ol
    String jsonString = await rootBundle.loadString('assets/lang/$currentLang.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  static String get(String key) {
    if (_localizedStrings == null) return key;
    return _localizedStrings![key] ?? key;
  }
}