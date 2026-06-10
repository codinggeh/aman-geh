import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

import '../../features/watermarker/model/watermark_settings.dart';
import 'watermark_painter.dart';

/// Renders the final watermarked image at the source image's native
/// resolution using [dart:ui] [PictureRecorder].
///
/// Returns JPG-encoded bytes ready to be saved or shared.
class WatermarkRenderer {
  const WatermarkRenderer();

  /// Composites [sourceBytes] with [settings] and returns the result as JPG.
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
      format: ui.ImageByteFormat.rawRgba,
    );

    final width = srcImage.width;
    final height = srcImage.height;
    final rawBytes = byteData!.buffer.asUint8List();

    srcImage.dispose();
    rendered.dispose();

    return Isolate.run(() {
      final imgObj = img.Image.fromBytes(
        width: width,
        height: height,
        bytes: rawBytes.buffer,
        order: img.ChannelOrder.rgba,
      );
      return img.encodeJpg(imgObj, quality: 80);
    });
  }
}
