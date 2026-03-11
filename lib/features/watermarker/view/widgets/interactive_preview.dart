import 'package:flutter/material.dart';

import '../../../../core/image_engine/watermark_painter.dart';
import '../../model/watermark_settings.dart';

class InteractivePreview extends StatelessWidget {
  const InteractivePreview({
    super.key,
    required this.imageBytes,
    required this.settings,
  });

  final MemoryImage imageBytes;
  final WatermarkSettings settings;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerLow,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: ColoredBox(color: cs.surfaceContainerHighest),
                ),
                Image(
                  image: imageBytes,
                  fit: BoxFit.contain,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: WatermarkOverlayPainter(settings: settings),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
