import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLocalization {
  final Map<String, dynamic> _translations;

  AppLocalization(this._translations);

  static Future<AppLocalization> load(String languageCode) async {
    final jsonString = await rootBundle.loadString('assets/i18n/$languageCode.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return AppLocalization(jsonMap);
  }

  String translate(String key) {
    return _translations[key]?.toString() ?? key;
  }

  Map<String, dynamic> get translations => _translations;
}

// Riverpod providers
final appLanguageProvider = StateProvider<String>((ref) => 'en');

final appLocalizationProvider = FutureProvider<AppLocalization>((ref) async {
  final languageCode = ref.watch(appLanguageProvider);
  return AppLocalization.load(languageCode);
});
