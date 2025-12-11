import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/core/localization/app_localization.dart';

class LanguageSettingsSheet extends ConsumerWidget {
  const LanguageSettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(appLanguageProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Select Language',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const Divider(),
          _buildLanguageOption(
            context,
            ref,
            'en',
            'English',
            currentLanguage,
          ),
          _buildLanguageOption(
            context,
            ref,
            'hi',
            'हिन्दी',
            currentLanguage,
          ),
          _buildLanguageOption(
            context,
            ref,
            'pa',
            'ਪੰਜਾਬੀ',
            currentLanguage,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    WidgetRef ref,
    String languageCode,
    String languageName,
    String currentLanguage,
  ) {
    final isSelected = currentLanguage == languageCode;

    return ListTile(
      title: Text(languageName),
      trailing: isSelected
          ? const Icon(Icons.check, color: Colors.green)
          : null,
      selected: isSelected,
      selectedTileColor: Colors.green.withOpacity(0.1),
      onTap: () {
        ref.read(appLanguageProvider.notifier).state = languageCode;
        Navigator.pop(context);
      },
    );
  }
}

