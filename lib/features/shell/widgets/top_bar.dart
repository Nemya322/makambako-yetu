import 'package:flutter/material.dart';

import '../../../core/l10n/app_text.dart';
import '../../../core/theme/makambako_theme.dart';
import '../../profile/profile_reveal.dart';

/// App header with brand mark, location scope, language toggle, and the
/// profile shortcut.
class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.isEnglish,
    required this.onProfileTap,
    required this.onLanguageTap,
    this.profileButtonKey,
  });

  final bool isEnglish;
  final VoidCallback onProfileTap;
  final VoidCallback onLanguageTap;

  /// Lets the shell find the avatar's on-screen position so the profile can
  /// grow out of it.
  final GlobalKey? profileButtonKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: MakambakoColors.forest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.location_city_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MAKAMBAKO YETU',
                  style: TextStyle(
                    color: MakambakoColors.forest,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.05,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: MakambakoColors.green,
                      size: 12,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      locationScope,
                      style: const TextStyle(
                        color: MakambakoColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            child: InkWell(
              key: const ValueKey('language-toggle'),
              borderRadius: BorderRadius.circular(13),
              onTap: onLanguageTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.translate_rounded,
                      color: MakambakoColors.forest,
                      size: 17,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isEnglish ? 'SW' : 'EN',
                      style: const TextStyle(
                        color: MakambakoColors.forest,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Container(
            key: profileButtonKey,
            child: Tooltip(
              message: tx(isEnglish, 'Wasifu', 'Profile'),
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                child: InkWell(
                  key: const ValueKey('topbar-profile-button'),
                  customBorder: const CircleBorder(),
                  onTap: onProfileTap,
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Hero(
                      tag: profileAvatarHeroTag,
                      child: SizedBox(
                        width: 34,
                        height: 34,
                        child: ProfileAvatar(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
