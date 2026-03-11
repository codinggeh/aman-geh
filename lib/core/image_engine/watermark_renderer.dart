import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../features/watermarker/model/watermark_settings.dart';
import 'watermark_painter.dart';

/// Renders the final watermarked image at the source image's native
/// resolution using [dart:ui] [PictureRecorder].
///
/// Returns PNG-encoded bytes ready to be saved or shared.
class WatermarkRenderer {
  const WatermarkRenderer();

  /// Composites [sourceBytes] with [settings] and returns the result as PNG.
  Future<Uint8List> render(
    Uint8List sourceBytes,
    WatermarkSettings settings,
  ) async {
    final codec = await ui.instantiateImageCodec(sourceBytes);
    final frame = await codec.getNextFrame();
    final srcImage = frame.image;

    final w = srcImage.width.toDouble();
    final h = srcImage.height.toDouble();

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, w, h));

    canvas.drawImage(srcImage, Offset.zero, Paint());
    drawWatermark(canvas, Size(w, h), settings);

    final picture = recorder.endRecording();
    final rendered = await picture.toImage(srcImage.width, srcImage.height);
    final byteData = await rendered.toByteData(
      format: ui.ImageByteFormat.png,
    );

    srcImage.dispose();
    rendered.dispose();

    return byteData!.buffer.asUint8List();
  }
}
