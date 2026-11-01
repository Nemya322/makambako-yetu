import 'package:flutter/material.dart';

import '../l10n/app_text.dart';
import '../theme/makambako_theme.dart';

/// The app-wide search input used on the home and explore pages.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.isEnglish,
    required this.onChanged,
  });

  final TextEditingController controller;
  final bool isEnglish;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: tx(
          isEnglish,
          'Tafuta biashara, chakula, huduma, maeneo...',
          'Search businesses, food, services, places...',
        ),
        hintStyle: const TextStyle(color: MakambakoColors.muted, fontSize: 14),
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: MakambakoColors.green,
        ),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                tooltip: tx(isEnglish, 'Futa utafutaji', 'Clear search'),
                onPressed: () {
                  controller.clear();
                  onChanged('');
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: MakambakoColors.muted,
                ),
              ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE9EDE8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: MakambakoColors.green, width: 1.4),
        ),
      ),
    );
  }
}
