import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/watermark_settings.dart';

/// ViewModel that manages the mutable [WatermarkSettings] state.
class WatermarkSettingsNotifier extends Notifier<WatermarkSettings> {
  @override
  WatermarkSettings build() => const WatermarkSettings();

  void setText(String text) => state = state.copyWith(text: text);
  void setOpacity(double opacity) => state = state.copyWith(opacity: opacity);
  void setFontSizeRatio(double ratio) =>
      state = state.copyWith(fontSizeRatio: ratio);
  void setRotation(double degrees) =>
      state = state.copyWith(rotation: degrees);
  void togglePatternMode() =>
      state = state.copyWith(isPatternMode: !state.isPatternMode);
  void setPatternMode(bool value) =>
      state = state.copyWith(isPatternMode: value);
  void setTextColor(Color color) => state = state.copyWith(textColor: color);
  void setSpacingRatio(double ratio) =>
      state = state.copyWith(spacingRatio: ratio);
  void reset() => state = const WatermarkSettings();
}

/// Global provider for watermark settings.
final watermarkSettingsProvider =
    NotifierProvider<WatermarkSettingsNotifier, WatermarkSettings>(
  WatermarkSettingsNotifier.new,
);
