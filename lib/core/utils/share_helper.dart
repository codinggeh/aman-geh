import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

import 'file_helper.dart';

/// Facilitates direct secure sharing of watermarked images
/// without saving to the public gallery.
abstract final class ShareHelper {
  /// Shares [imagesBytes] as temporary files via the system share sheet.
  ///
  /// The temp files are created in the app cache, shared, and can be
  /// cleaned up by the OS automatically.
  static Future<void> shareImages(
    List<Uint8List> imagesBytes, {
    String subject = 'Watermarked ID Document',
  }) async {
    final files = <XFile>[];
    for (int i = 0; i < imagesBytes.length; i++) {
      final file = await FileHelper.saveToTemp(
        imagesBytes[i], 
        'aman_geh_watermarked_${i + 1}.jpg',
      );
      files.add(XFile(file.path));
    }
    
    await SharePlus.instance.share(
      ShareParams(
        files: files,
        subject: subject,
      ),
    );
  }

  /// Shares [pdfBytes] as a temporary file via the system share sheet.
  static Future<void> sharePdf(
    Uint8List pdfBytes, {
    String fileName = 'aman_geh_watermarked.pdf',
    String subject = 'Watermarked ID Document (PDF)',
  }) async {
    final file = await FileHelper.saveToTemp(pdfBytes, fileName);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: subject,
      ),
    );
  }
}
