import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Official MT Alchemy brand mark (user-supplied artwork).
///
/// The mark artwork carries its own dark backdrop, so it is always
/// presented on a matching ink tile — this keeps it crisp on both
/// light and dark surfaces.
class AppLogoMark extends StatelessWidget {
  /// Height of the tile; width follows [aspect].
  final double size;
  final double aspect;
  final double radius;

  const AppLogoMark({
    super.key,
    this.size = 40,
    this.aspect = 1.1,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'MT Alchemy logo',
      image: true,
      child: Container(
        width: size * aspect,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: Colors.white.withValues(alpha: .14),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepBlue.withValues(alpha: .28),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          'assets/logo-mark.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => const Center(
            child: Text(
              'MT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: .5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Full lockup: brand mark plus wordmark text, as used in nav headers.
class AppLogo extends StatelessWidget {
  final double markSize;
  final VoidCallback? onTap;
  final Color wordmarkColor;
  final Color? subtitleColor;

  /// When true, only the mark tile is shown (for narrow bars).
  final bool compact;

  const AppLogo({
    super.key,
    this.markSize = 40,
    this.onTap,
    this.wordmarkColor = AppColors.ink,
    this.subtitleColor,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLogoMark(size: markSize),
          if (!compact) ...[
            const SizedBox(width: 11),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MT ALCHEMY',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16.5,
                    letterSpacing: .6,
                    color: wordmarkColor,
                  ),
                ),
                Text(
                  'CONSULTANCY · TRAINING · OD',
                  style: TextStyle(
                    fontSize: 9.5,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w700,
                    color: subtitleColor ?? AppColors.muted,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
