import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

class LabelledSlider extends StatelessWidget {
  const LabelledSlider({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.displayMultiplier = 100,
    this.suffix = '%',
    this.icon,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final double displayMultiplier;
  final String suffix;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18),
              const SizedBox(width: 6),
            ],
            Expanded(child: Text(label, style: theme.textTheme.titleSmall)),
            Text(
              '${(value * displayMultiplier).round()}$suffix',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        Slider(value: value, min: min, max: max, onChanged: onChanged),
      ],
    );
  }
}

class OpacitySlider extends StatelessWidget {
  const OpacitySlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return LabelledSlider(
      label: 'opacity'.tr(),
      icon: Icons.opacity_rounded,
      value: value,
      min: minOpacity,
      max: maxOpacity,
      onChanged: onChanged,
    );
  }
}
