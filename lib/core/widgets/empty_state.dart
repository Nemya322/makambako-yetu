import 'package:flutter/material.dart';

import '../theme/makambako_theme.dart';

/// Generic empty-state block used across the discovery surfaces.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 18),
      child: Column(
        children: [
          Icon(icon, color: MakambakoColors.green, size: 42),
          const SizedBox(height: 13),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: MakambakoColors.ink,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: MakambakoColors.muted, height: 1.45),
          ),
        ],
      ),
    );
  }
}
