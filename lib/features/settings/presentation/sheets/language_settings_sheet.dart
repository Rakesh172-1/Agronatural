import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/core/localization/app_locale_provider.dart';

class LanguageSettingsSheet extends ConsumerWidget {
  const LanguageSettingsSheet({super.key});

  String _getLanguageEmoji(String locale) {
    switch (locale) {
      case 'en':
        return '🇺🇸';
      case 'hi':
        return '🇮🇳';
      case 'pa':
        return '🇵🇰';
      case 'mr':
        return '🇮🇳';
      case 'bn':
        return '🇧🇩';
      default:
        return '🌐';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(appLocaleProvider);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Language',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(),
          // Language options
          Expanded(
            child: ListView.builder(
              itemCount: supportedLocales.length,
              itemBuilder: (context, index) {
                final locale = supportedLocales[index];
                final localeName = localeNames[locale] ?? locale;

                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: currentLocale == locale
                          ? const Color(0xFF52B788)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _getLanguageEmoji(locale),
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  title: Text(
                    localeName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: currentLocale == locale
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  trailing: currentLocale == locale
                      ? const Icon(
                          Icons.check_circle,
                          color: Color(0xFF52B788),
                          size: 24,
                        )
                      : null,
                  onTap: () {
                    ref.read(appLocaleProvider.notifier).state = locale;
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

