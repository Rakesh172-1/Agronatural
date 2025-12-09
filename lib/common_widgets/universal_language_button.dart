import 'package:flutter/material.dart';
import 'package:vriddhiapps/features/settings/presentation/sheets/language_settings_sheet.dart';

/// Universal language button widget that can be added to any AppBar
/// Usage: Add to AppBar.actions: [const UniversalLanguageButton()]
class UniversalLanguageButton extends StatelessWidget {
  final String tooltip;

  const UniversalLanguageButton({
    super.key,
    this.tooltip = 'Change Language',
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.language),
      tooltip: tooltip,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => const LanguageSettingsSheet(),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        );
      },
    );
  }
}
