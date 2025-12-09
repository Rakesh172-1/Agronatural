import 'dart:convert';
import 'package:flutter/services.dart';

class AppLocalizations {
  final String locale;
  late Map<String, String> _localizedStrings;

  AppLocalizations(this.locale);

  static AppLocalizations of(String locale) {
    return AppLocalizations(locale);
  }

  Future<bool> load() async {
    try {
      final jsonString = await rootBundle.loadString('assets/i18n/$locale.json');
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      _localizedStrings = jsonMap.cast<String, String>();
      return true;
    } catch (e) {
      // Fallback to English
      final jsonString = await rootBundle.loadString('assets/i18n/en.json');
      final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
      _localizedStrings = jsonMap.cast<String, String>();
      return false;
    }
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }

  String get appName => translate('appName');
  String get home => translate('home');
  String get weather => translate('weather');
  String get cropPlanner => translate('cropPlanner');
  String get mandiPrices => translate('mandiPrices');
  String get fertilizer => translate('fertilizer');
  String get currentWeather => translate('currentWeather');
  String get temperature => translate('temperature');
  String get condition => translate('condition');
  String get humidity => translate('humidity');
  String get windSpeed => translate('windSpeed');
  String get forecast => translate('forecast');
  String get minTemp => translate('minTemp');
  String get maxTemp => translate('maxTemp');
  String get tapToViewDetails => translate('tapToViewDetails');
  String get checkMarketPrices => translate('checkMarketPrices');
  String get planYourCrops => translate('planYourCrops');
  String get fertilizerGuide => translate('fertilizerGuide');
  String get governmentSchemes => translate('governmentSchemes');
  String get viewSchemes => translate('viewSchemes');
  String get blog => translate('blog');
  String get blogDescription => translate('blogDescription');
  String get farmCalculator => translate('farmCalculator');
  String get calculateFarmMetrics => translate('calculateFarmMetrics');
  String get loanSchemes => translate('loanSchemes');
  String get loanSchemesDescription => translate('loanSchemesDescription');
  String get diseaseDetector => translate('diseaseDetector');
  String get diseaseDetectorDescription => translate('diseaseDetectorDescription');
  String get selectState => translate('selectState');
  String get selectDistrict => translate('selectDistrict');
  String get selectCrop => translate('selectCrop');
  String get price => translate('price');
  String get modal => translate('modal');
  String get loading => translate('loading');
  String get error => translate('error');
  String get noData => translate('noData');
  String get retry => translate('retry');
  String get ok => translate('ok');
  String get cancel => translate('cancel');
  String get save => translate('save');
  String get delete => translate('delete');
  String get edit => translate('edit');
  String get back => translate('back');
}
