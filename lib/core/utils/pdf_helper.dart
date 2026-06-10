import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Helper to generate a PDF document containing the given image.
abstract final class PdfHelper {
  /// Generates a PDF containing multiple pages with the images centered and rotated.
  static Future<Uint8List> generatePdfFromImages(
    List<Uint8List> imagesBytes, {
    int rotationDegrees = 0,
  }) async {
    final pdf = pw.Document();

    for (final imageBytes in imagesBytes) {
      final image = pw.MemoryImage(imageBytes);
      final radians = rotationDegrees * 3.1415926535897932 / 180;

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Transform.rotateBox(
                angle: radians,
                child: pw.Image(image),
              ),
            );
          },
        ),
      );
    }

    return pdf.save();
  }
}
