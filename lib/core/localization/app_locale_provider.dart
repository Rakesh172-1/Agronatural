import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/core/localization/app_localizations.dart';

// List of supported locales
const List<String> supportedLocales = ['en', 'hi', 'pa', 'mr', 'bn'];

// Map of locale codes to display names
const Map<String, String> localeNames = {
  'en': 'English',
  'hi': 'हिंदी',
  'pa': 'ਪੰਜਾਬੀ',
  'mr': 'मराठी',
  'bn': 'বাংলা',
};

/// Provider for managing app language/locale
final appLocaleProvider = StateProvider<String>((ref) => 'en');

/// Provider for app localizations
final appLocalizationsProvider =
    FutureProvider.family<AppLocalizations, String>((ref, locale) async {
  final localizations = AppLocalizations(locale);
  await localizations.load();
  return localizations;
});

/// Provider for current app localizations based on selected locale
final currentLocalizationsProvider = FutureProvider<AppLocalizations>((ref) async {
  final locale = ref.watch(appLocaleProvider);
  return ref.watch(appLocalizationsProvider(locale).future);
});
