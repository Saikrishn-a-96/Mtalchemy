import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';

/// ---------------------------------------------------------------------------
/// Responsive helpers
/// ---------------------------------------------------------------------------
enum ScreenType { mobile, tablet, desktop }

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ScreenType type) builder;
  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) =>
      builder(context, screenTypeOf(context));
}

ScreenType screenTypeOf(BuildContext context) {
  final w = MediaQuery.sizeOf(context).width;
  if (w < 700) return ScreenType.mobile;
  if (w < 1080) return ScreenType.tablet;
  return ScreenType.desktop;
}

bool isMobile(BuildContext context) =>
    MediaQuery.sizeOf(context).width < 700;

/// Content container with a consistent max width and gutters.
class PageWidth extends StatelessWidget {
  final Widget child;
  final double max;
  final EdgeInsetsGeometry padding;
  const PageWidth({
    super.key,
    required this.child,
    this.max = 1240,
    this.padding = const EdgeInsets.symmetric(horizontal: 24),
  });

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final pad = w < 700
        ? const EdgeInsets.symmetric(horizontal: 18)
        : padding;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: max),
        child: Padding(padding: pad, child: child),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Imagery with graceful fallback (prototype-safe)
/// ---------------------------------------------------------------------------
class NetworkImg extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? radius;

  const NetworkImg({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFE8EEF7), Color(0xFFF6F8FC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Center(
            child: SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stack) => Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.deepBlue, AppColors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Center(
          child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 30),
        ),
      ),
    );

    if (radius == null) return image;
    return ClipRRect(borderRadius: radius!, child: image);
  }
}

/// ---------------------------------------------------------------------------
/// Buttons
/// ---------------------------------------------------------------------------
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool compact;
  final bool wide;

  /// Set to true when the button sits on a dark section background;
  /// the button then uses the soft-yellow brand accent for contrast.
  final bool onDark;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.compact = false,
    this.wide = false,
    this.onDark = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final pad = widget.compact
        ? const EdgeInsets.symmetric(horizontal: 16, vertical: 11)
        : const EdgeInsets.symmetric(horizontal: 26, vertical: 17);
    final onDark = widget.onDark;
    final gradient = onDark
        ? const LinearGradient(
            colors: [AppColors.softYellow, Color(0xFFFFD873)])
        : const LinearGradient(
            colors: [AppColors.deepBlue, AppColors.indigo]);
    final fg = onDark ? AppColors.deepBlue : Colors.white;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: 220.ms,
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translateByDouble(0.0, _hover ? -2.0 : 0.0, 0.0, 1.0),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: (onDark ? AppColors.softYellow : AppColors.deepBlue)
                  .withValues(alpha: _hover ? 0.40 : 0.22),
              blurRadius: _hover ? 22 : 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: pad,
              child: Row(
                mainAxisSize: widget.wide ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: fg,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  if (widget.icon != null) ...[
                    const SizedBox(width: 8),
                    Icon(widget.icon, color: fg, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GhostButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool compact;

  /// Set to true when the button sits on a dark section background.
  final bool light;
  const GhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.compact = false,
    this.light = false,
  });

  @override
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final onDark = widget.light;
    final borderColor = onDark
        ? (const Color(0x66FFFFFF))
        : AppColors.deepBlue;
    final bg = onDark
        ? (_hover ? Colors.white : Colors.transparent)
        : (_hover ? AppColors.deepBlue : Colors.transparent);
    final fg = onDark
        ? (onDark && _hover ? AppColors.deepBlue : Colors.white)
        : (_hover ? Colors.white : AppColors.deepBlue);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: 220.ms,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _hover ? (onDark ? Colors.white : AppColors.deepBlue) : borderColor),
        ),
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: widget.compact
                ? const EdgeInsets.symmetric(horizontal: 15, vertical: 10)
                : const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                if (widget.icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(
                    widget.icon,
                    size: 18,
                    color: fg,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// Section headings & typography helpers
/// ---------------------------------------------------------------------------
class SectionHeader extends StatelessWidget {
  final String eyebrow;
  final String title;
  final String? subtitle;
  final bool light;
  final CrossAxisAlignment align;

  const SectionHeader({
    super.key,
    required this.eyebrow,
    required this.title,
    this.subtitle,
    this.light = false,
    this.align = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = light ? Colors.white : AppColors.ink;
    final subColor = light ? Colors.white.withValues(alpha: .78) : AppColors.muted;

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.softYellow.withValues(alpha: .22),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.softYellow),
          ),
          child: Text(
            eyebrow.toUpperCase(),
            style: TextStyle(
              fontSize: 11.5,
              letterSpacing: 1.4,
              fontWeight: FontWeight.w800,
              color: light ? AppColors.softYellow : AppColors.deepBlue,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          textAlign: align == CrossAxisAlignment.center
              ? TextAlign.center
              : TextAlign.left,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: titleColor,
                fontSize: 38,
              ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 14),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Text(
              subtitle!,
              textAlign: align == CrossAxisAlignment.center
                  ? TextAlign.center
                  : TextAlign.left,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: subColor),
            ),
          ),
        ],
      ],
    );
  }
}

/// Entrance animation used across sections for a polished feel.
class Reveal extends StatelessWidget {
  final Widget child;
  final double dy;
  final int delayMs;

  const Reveal({
    super.key,
    required this.child,
    this.dy = 0.06,
    this.delayMs = 0,
  });

  @override
  Widget build(BuildContext context) => child
      .animate(delay: Duration(milliseconds: delayMs))
      .fadeIn(duration: 620.ms, curve: Curves.easeOutCubic)
      .slideY(begin: dy, end: 0, duration: 620.ms, curve: Curves.easeOutCubic);
}

class FadeInLeft extends StatelessWidget {
  final Widget child;
  final int delayMs;
  const FadeInLeft({super.key, required this.child, this.delayMs = 0});

  @override
  Widget build(BuildContext context) => child
      .animate(delay: Duration(milliseconds: delayMs))
      .fadeIn(duration: 600.ms)
      .slideX(begin: -0.05, end: 0, duration: 600.ms, curve: Curves.easeOutCubic);
}

/// ---------------------------------------------------------------------------
/// Small building blocks
/// ---------------------------------------------------------------------------
class Tag extends StatelessWidget {
  final String label;
  final Color color;
  const Tag({super.key, required this.label, this.color = AppColors.purple});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: .35)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: .3,
          ),
        ),
      );
}

class RatingStar extends StatelessWidget {
  final double rating;
  const RatingStar({super.key, required this.rating});

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: AppColors.softYellow),
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: AppColors.ink,
            ),
          ),
        ],
      );
}

class MoneyText extends StatelessWidget {
  final double value;
  final double size;
  const MoneyText(this.value, {super.key, this.size = 18});

  @override
  Widget build(BuildContext context) => Text(
        'RM${value.toStringAsFixed(2)}',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: size,
          color: AppColors.deepBlue,
        ),
      );
}

/// Glass-style stat tile used on dashboards.
class StatTile extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color accent;

  const StatTile({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    this.accent = AppColors.deepBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: accent.withValues(alpha: .06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accent.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 20, color: accent),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: -.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.muted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded section wrapper with the soft background band.
class Band extends StatelessWidget {
  final Widget child;
  final Color color;
  final EdgeInsetsGeometry padding;
  const Band({
    super.key,
    required this.child,
    this.color = AppColors.surface,
    this.padding = const EdgeInsets.symmetric(vertical: 64),
  });

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color: color,
        child: PageWidth(padding: padding, child: child),
      );
}

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final Widget? action;
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppColors.purpleSoft,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(icon, size: 36, color: AppColors.purple),
              ),
              const SizedBox(height: 20),
              Text(title,
                  style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Text(message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              if (action != null) ...[const SizedBox(height: 22), action!],
            ],
          ),
        ),
      );
}

/// A titled card used across dashboards.
class Panel extends StatelessWidget {
  final String? title;
  final Widget child;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  const Panel({
    super.key,
    this.title,
    required this.child,
    this.trailing,
    this.padding = const EdgeInsets.all(20),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepBlue.withValues(alpha: .05),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }
}
