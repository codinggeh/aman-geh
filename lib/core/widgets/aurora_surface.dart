import 'package:flutter/material.dart';

/// Shared page container with consistent spacing and max width.
class AuroraBackground extends StatelessWidget {
  const AuroraBackground({
    super.key,
    required this.child,
    this.padding,
    this.topSafeArea = true,
    this.bottomSafeArea = true,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool topSafeArea;
  final bool bottomSafeArea;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: topSafeArea,
        bottom: bottomSafeArea,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// Primary content container.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.gradient,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius borderRadius;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final panel = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? cs.surface : null,
        gradient: gradient,
        borderRadius: borderRadius,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: child,
    );

    if (margin == null) return panel;
    return Padding(padding: margin!, child: panel);
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.trailing,
    this.margin = const EdgeInsets.only(bottom: 10),
  });

  final String title;
  final Widget? trailing;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: margin,
      child: Row(
        children: [
          Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
          ?trailing,
        ],
      ),
    );
  }
}
