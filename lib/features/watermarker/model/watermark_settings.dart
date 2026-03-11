import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

/// Pure business entity describing how a watermark should be rendered.
///
/// All size-related values are expressed as ratios of the target image
/// dimensions, making the configuration resolution-independent.
@immutable
class WatermarkSettings {
  const WatermarkSettings({
    this.text = defaultWatermarkText,
    this.opacity = defaultOpacity,
    this.fontSizeRatio = defaultFontSizeRatio,
    this.rotation = defaultRotationDegrees,
    this.isPatternMode = true,
    this.textColor = Colors.white,
    this.spacingRatio = defaultSpacingRatio,
  });

  final String text;
  final double opacity;
  final double fontSizeRatio;
  final double rotation;
  final bool isPatternMode;
  final Color textColor;
  final double spacingRatio;

  WatermarkSettings copyWith({
    String? text,
    double? opacity,
    double? fontSizeRatio,
    double? rotation,
    bool? isPatternMode,
    Color? textColor,
    double? spacingRatio,
  }) {
    return WatermarkSettings(
      text: text ?? this.text,
      opacity: opacity ?? this.opacity,
      fontSizeRatio: fontSizeRatio ?? this.fontSizeRatio,
      rotation: rotation ?? this.rotation,
      isPatternMode: isPatternMode ?? this.isPatternMode,
      textColor: textColor ?? this.textColor,
      spacingRatio: spacingRatio ?? this.spacingRatio,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatermarkSettings &&
          text == other.text &&
          opacity == other.opacity &&
          fontSizeRatio == other.fontSizeRatio &&
          rotation == other.rotation &&
          isPatternMode == other.isPatternMode &&
          textColor == other.textColor &&
          spacingRatio == other.spacingRatio;

  @override
  int get hashCode => Object.hash(
        text,
        opacity,
        fontSizeRatio,
        rotation,
        isPatternMode,
        textColor,
        spacingRatio,
      );
}
