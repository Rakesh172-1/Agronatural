import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vriddhiapps/features/settings/presentation/sheets/language_settings_sheet.dart';

/// Universal language button widget that can be added to any AppBar
/// Usage: Add to AppBar.actions: [const UniversalLanguageButton()]
class UniversalLanguageButton extends ConsumerWidget {
  final Color? color;
  final double? size;
  final String? tooltip;

  const UniversalLanguageButton({
    super.key,
    this.color,
    this.size = 24,
    this.tooltip = 'Change Language',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(
        Icons.language,
        color: color ?? Colors.white,
        size: size,
      ),
      tooltip: tooltip,
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => const LanguageSettingsSheet(),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
        );
      },
    );
  }
}
