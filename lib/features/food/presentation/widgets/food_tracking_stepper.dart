import 'package:flutter/material.dart';

import '../../../../core/l10n/app_text.dart';
import '../../../../core/theme/makambako_theme.dart';

/// Aligned 4-stage tracking stepper for Food Delivery.
class FoodTrackingStepper extends StatelessWidget {
  const FoodTrackingStepper({
    required this.isEnglish,
    this.currentStageIndex = 2, // 0: Confirmed, 1: Cooked, 2: On the way, 3: Delivered
    super.key,
  });

  final bool isEnglish;
  final int currentStageIndex;

  @override
  Widget build(BuildContext context) {
    final isEn = isEnglish;
    final stages = [
      {'label': tx(isEn, 'Imepokelewa', 'Confirmed')},
      {'label': tx(isEn, 'Imepikwa', 'Cooked')},
      {'label': tx(isEn, 'Njiani', 'On the way')},
      {'label': tx(isEn, 'Imefika', 'Delivered')},
    ];

    return Column(
      children: [
        // Circles and connectors centered on the exact same horizontal axis
        Row(
          children: [
            for (int i = 0; i < stages.length; i++) ...[
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: i <= currentStageIndex
                      ? MakambakoColors.forest
                      : const Color(0xFFE2E8F0),
                  shape: BoxShape.circle,
                  boxShadow: i == currentStageIndex
                      ? [
                          BoxShadow(
                            color: MakambakoColors.forest.withValues(alpha: 0.35),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Icon(
                    i <= currentStageIndex ? Icons.check_rounded : Icons.circle,
                    color: i <= currentStageIndex ? Colors.white : const Color(0xFF94A3B8),
                    size: i <= currentStageIndex ? 14 : 7,
                  ),
                ),
              ),
              if (i < stages.length - 1)
                Expanded(
                  child: Container(
                    height: 3,
                    color: i < currentStageIndex
                        ? MakambakoColors.forest
                        : const Color(0xFFE2E8F0),
                  ),
                ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        // Step labels beneath each circle with clean distribution
        Row(
          children: [
            for (int i = 0; i < stages.length; i++)
              Expanded(
                child: Text(
                  stages[i]['label'] as String,
                  textAlign: i == 0
                      ? TextAlign.left
                      : (i == stages.length - 1 ? TextAlign.right : TextAlign.center),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: i == currentStageIndex || i < currentStageIndex
                        ? FontWeight.w800
                        : FontWeight.w600,
                    color: i == currentStageIndex
                        ? MakambakoColors.forest
                        : (i < currentStageIndex
                            ? MakambakoColors.ink
                            : MakambakoColors.muted),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
