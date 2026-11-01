import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/makambako_theme.dart';

/// Hero tag shared by the top-bar avatar and the profile page avatar.
const String profileAvatarHeroTag = 'mk-profile-avatar';

/// Avatar that scales cleanly (icon included) while a Hero flight resizes it.
///
/// The size is decided by the parent; this widget only keeps a 1:1 circle and
/// scales its icon proportionally.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({this.isGuest = false, super.key});

  final bool isGuest;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE5F0E8), Color(0xFFCDE6D6)],
          ),
        ),
        child: FractionallySizedBox(
          widthFactor: 0.58,
          heightFactor: 0.58,
          child: FittedBox(
            child: Icon(
              isGuest ? Icons.person_outline_rounded : Icons.person_rounded,
              color: MakambakoColors.forest,
            ),
          ),
        ),
      ),
    );
  }
}

/// Opens the profile as a circular reveal that grows out of [origin]
/// (the centre of the top-bar avatar) and shrinks back into it on pop.
/// Combined with a [Hero] on the avatar, the avatar itself visibly enlarges
/// into the profile picture.
class ProfileRevealRoute<T> extends PageRouteBuilder<T> {
  ProfileRevealRoute({required WidgetBuilder builder, required this.origin})
      : super(
          transitionDuration: const Duration(milliseconds: 560),
          reverseTransitionDuration: const Duration(milliseconds: 420),
          pageBuilder: (context, animation, secondaryAnimation) =>
              builder(context),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final reveal = animation.drive(
              CurveTween(curve: Curves.easeInOutCubic),
            );
            return AnimatedBuilder(
              animation: reveal,
              child: child,
              builder: (context, child) {
                return ClipPath(
                  clipper: _CircleRevealClipper(
                    fraction: reveal.value,
                    center: origin,
                  ),
                  child: child,
                );
              },
            );
          },
        );

  /// Global position the reveal grows from.
  final Offset origin;
}

class _CircleRevealClipper extends CustomClipper<Path> {
  const _CircleRevealClipper({required this.fraction, required this.center});

  final double fraction;
  final Offset center;

  @override
  Path getClip(Size size) {
    final corners = [
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ];
    final maxRadius = corners
        .map((corner) => (corner - center).distance)
        .reduce(math.max);
    return Path()
      ..addOval(Rect.fromCircle(center: center, radius: maxRadius * fraction));
  }

  @override
  bool shouldReclip(_CircleRevealClipper oldClipper) =>
      oldClipper.fraction != fraction || oldClipper.center != center;
}

/// Fades and slides [child] in during part of the route transition so the
/// profile attributes appear after the avatar has grown.
class RouteStagger extends StatelessWidget {
  const RouteStagger({
    required this.child,
    this.begin = 0.45,
    this.end = 1.0,
    super.key,
  });

  final Widget child;
  final double begin;
  final double end;

  @override
  Widget build(BuildContext context) {
    final routeAnimation = ModalRoute.of(context)?.animation;
    if (routeAnimation == null) return child;

    final progress = routeAnimation.drive(
      CurveTween(curve: Interval(begin, end, curve: Curves.easeOutCubic)),
    );
    return AnimatedBuilder(
      animation: progress,
      child: child,
      builder: (context, child) => Opacity(
        opacity: progress.value,
        child: Transform.translate(
          offset: Offset(0, (1 - progress.value) * 14),
          child: child,
        ),
      ),
    );
  }
}
