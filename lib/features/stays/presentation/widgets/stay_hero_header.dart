import 'package:flutter/material.dart';

import '../../../../core/theme/makambako_theme.dart';

/// Hero image with back button and favorite action for guest house booking.
class StayHeroHeader extends StatelessWidget {
  const StayHeroHeader({
    this.onBack,
    this.isFavorite = false,
    this.onToggleFavorite,
    super.key,
  });

  final VoidCallback? onBack;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 220,
          width: double.infinity,
          child: Image.asset(
            'assets/images/hotel_hero.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F2B1D), Color(0xFF1E3A5F)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(Icons.hotel_rounded, size: 64, color: Colors.white24),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.45),
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: IconButton(
                    key: const ValueKey('guesthouse-back-button'),
                    icon: const Icon(Icons.arrow_back_rounded, color: MakambakoColors.ink, size: 20),
                    onPressed: onBack ?? () => Navigator.maybePop(context),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: IconButton(
                    key: const ValueKey('guesthouse-favorite-button'),
                    icon: Icon(
                      isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: const Color(0xFFDC2626),
                      size: 20,
                    ),
                    onPressed: onToggleFavorite,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
