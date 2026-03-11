import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/aurora_surface.dart';
import '../../viewmodel/watermark_viewmodel.dart';
import 'opacity_slider.dart';

class WatermarkControls extends ConsumerStatefulWidget {
  const WatermarkControls({super.key});

  @override
  ConsumerState<WatermarkControls> createState() => _WatermarkControlsState();
}

class _WatermarkControlsState extends ConsumerState<WatermarkControls> {
  late final TextEditingController _textCtrl;

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(
      text: ref.read(watermarkSettingsProvider).text,
    );
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(watermarkSettingsProvider);
    final notifier = ref.read(watermarkSettingsProvider.notifier);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (_textCtrl.text != settings.text) {
      _textCtrl.value = TextEditingValue(
        text: settings.text,
        selection: TextSelection.collapsed(offset: settings.text.length),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(title: 'controls_text_section'.tr()),
              TextField(
                controller: _textCtrl,
                onChanged: notifier.setText,
                decoration: InputDecoration(
                  hintText: 'watermark_hint'.tr(),
                  prefixIcon: const Icon(Icons.edit_rounded),
                ),
                maxLength: 80,
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassPanel(
          child: Column(
            children: [
              SectionTitle(title: 'controls_adjustments'.tr()),
              OpacitySlider(
                value: settings.opacity,
                onChanged: notifier.setOpacity,
              ),
              const SizedBox(height: 8),
              LabelledSlider(
                label: 'font_size'.tr(),
                icon: Icons.format_size_rounded,
                value: settings.fontSizeRatio,
                min: minFontSizeRatio,
                max: maxFontSizeRatio,
                onChanged: notifier.setFontSizeRatio,
              ),
              const SizedBox(height: 8),
              LabelledSlider(
                label: 'rotation'.tr(),
                icon: Icons.rotate_left_rounded,
                value: settings.rotation,
                min: minRotation,
                max: maxRotation,
                onChanged: notifier.setRotation,
                displayMultiplier: 1,
                suffix: '°',
              ),
              if (settings.isPatternMode) ...[
                const SizedBox(height: 8),
                LabelledSlider(
                  label: 'pattern_spacing'.tr(),
                  icon: Icons.grid_on_rounded,
                  value: settings.spacingRatio,
                  min: minSpacingRatio,
                  max: maxSpacingRatio,
                  onChanged: notifier.setSpacingRatio,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassPanel(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionTitle(title: 'controls_mode_color'.tr()),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'pattern_mode'.tr(),
                  style: theme.textTheme.titleSmall,
                ),
                subtitle: Text(
                  settings.isPatternMode
                      ? 'pattern_on'.tr()
                      : 'pattern_off'.tr(),
                  style: theme.textTheme.bodySmall,
                ),
                value: settings.isPatternMode,
                onChanged: notifier.setPatternMode,
              ),
              const SizedBox(height: 12),
              Text('text_color'.tr(), style: theme.textTheme.titleSmall),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _ColorChip(
                    color: Colors.white,
                    label: 'white'.tr(),
                    selected: settings.textColor == Colors.white,
                    onTap: () => notifier.setTextColor(Colors.white),
                  ),
                  _ColorChip(
                    color: Colors.black,
                    label: 'black'.tr(),
                    selected: settings.textColor == Colors.black,
                    onTap: () => notifier.setTextColor(Colors.black),
                  ),
                  _ColorChip(
                    color: Colors.red,
                    label: 'red'.tr(),
                    selected: settings.textColor == Colors.red,
                    onTap: () => notifier.setTextColor(Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '${'opacity'.tr()}: ${(settings.opacity * 100).round()}%',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ColorChip extends StatelessWidget {
  const _ColorChip({
    required this.color,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? cs.primaryContainer : cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? cs.primary : cs.outlineVariant),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(color: cs.outlineVariant),
              ),
            ),
            const SizedBox(width: 8),
            Text(label, style: theme.textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}
