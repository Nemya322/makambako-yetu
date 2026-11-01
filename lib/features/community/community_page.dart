import 'package:flutter/material.dart';

import '../../../core/l10n/app_text.dart';
import '../../../core/theme/makambako_theme.dart';
import '../../../core/widgets/empty_state.dart';

/// Community destination from the product architecture
/// (Home | search | Explore | Activity | Community | Profile).
///
/// Shows an honest not-connected state: no news, events, or announcements are
/// fabricated before an approved editorial source exists.
class CommunityPage extends StatelessWidget {
  const CommunityPage({required this.isEnglish, super.key});

  final bool isEnglish;

  @override
  Widget build(BuildContext context) {
    return ListView(
      key: const PageStorageKey('community-page'),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
      children: [
        Text(
          tx(isEnglish, 'Jamii', 'Community'),
          style: const TextStyle(
            color: MakambakoColors.ink,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          tx(
            isEnglish,
            'Taarifa na matukio ya jamii ya Makambako.',
            'Makambako community news and events.',
          ),
          style: const TextStyle(color: MakambakoColors.muted, height: 1.4),
        ),
        const SizedBox(height: 8),
        EmptyState(
          icon: Icons.campaign_outlined,
          title: tx(
            isEnglish,
            'Habari bado hazijawasilishwa',
            'No community feed yet',
          ),
          message: tx(
            isEnglish,
            'Matukio, taarifa na matangazo ya jamii yataonekana hapa baada ya '
                'chanzo kilichothibitishwa kuchaguliwa.',
            'Events, news, and community announcements will appear here once '
                'an approved source is connected.',
          ),
        ),
      ],
    );
  }
}
