import 'package:flutter/material.dart';

import '../theme/makambako_theme.dart';

/// Section heading with an optional trailing action link.
class SectionHeading extends StatelessWidget {
  const SectionHeading({super.key, required this.title, this.action, this.onAction});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: MakambakoColors.ink,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (action case final label?)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: MakambakoColors.green,
              visualDensity: VisualDensity.compact,
            ),
            child: Row(
              children: [
                Text(label, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 3),
                const Icon(Icons.arrow_forward_ios_rounded, size: 11),
              ],
            ),
          ),
      ],
    );
  }
}
