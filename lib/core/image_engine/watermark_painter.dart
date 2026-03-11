import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../features/watermarker/model/watermark_settings.dart';

/// Shared watermark drawing logic used by both the live preview
/// [CustomPainter] and the full-resolution export renderer.
///
/// All dimensions are expressed as ratios of [size] so the same
/// code produces correct output at any resolution.
void drawWatermark(Canvas canvas, Size size, WatermarkSettings settings) {
  if (settings.text.isEmpty) return;

  final double fontSize = size.height * settings.fontSizeRatio;
  final textStyle = TextStyle(
    color: settings.textColor.withValues(alpha: settings.opacity),
    fontSize: fontSize,
    fontWeight: FontWeight.w800,
    letterSpacing: 2,
  );

  if (settings.isPatternMode) {
    _drawPattern(canvas, size, settings, textStyle);
  } else {
    _drawSingle(canvas, size, settings, textStyle);
  }
}

void _drawPattern(
  Canvas canvas,
  Size size,
  WatermarkSettings settings,
  TextStyle style,
) {
  final textSpan = TextSpan(text: settings.text, style: style);
  final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)
    ..layout();

  final spacingX = tp.width + size.width * settings.spacingRatio;
  final spacingY = tp.height + size.height * settings.spacingRatio;
  final radians = settings.rotation * math.pi / 180;

  final diagonal =
      math.sqrt(size.width * size.width + size.height * size.height);

  for (double y = -diagonal; y < diagonal; y += spacingY) {
    for (double x = -diagonal; x < diagonal; x += spacingX) {
      canvas.save();
      canvas.translate(size.width / 2, size.height / 2);
      canvas.rotate(radians);
      canvas.translate(-size.width / 2, -size.height / 2);
      tp.paint(canvas, Offset(x, y));
      canvas.restore();
    }
  }
}

void _drawSingle(
  Canvas canvas,
  Size size,
  WatermarkSettings settings,
  TextStyle style,
) {
  final textSpan = TextSpan(text: settings.text, style: style);
  final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr)
    ..layout();

  final radians = settings.rotation * math.pi / 180;

  canvas.save();
  canvas.translate(size.width / 2, size.height / 2);
  canvas.rotate(radians);
  tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
  canvas.restore();
}

/// [CustomPainter] that renders the watermark overlay on the preview widget.
class WatermarkOverlayPainter extends CustomPainter {
  const WatermarkOverlayPainter({required this.settings});

  final WatermarkSettings settings;

  @override
  void paint(Canvas canvas, Size size) => drawWatermark(canvas, size, settings);

  @override
  bool shouldRepaint(covariant WatermarkOverlayPainter oldDelegate) =>
      settings != oldDelegate.settings;
}
