import 'dart:typed_data';

import 'package:share_plus/share_plus.dart';

import 'file_helper.dart';

/// Facilitates direct secure sharing of watermarked images
/// without saving to the public gallery.
abstract final class ShareHelper {
  /// Shares [imageBytes] as a temporary file via the system share sheet.
  ///
  /// The temp file is created in the app cache, shared, and can be
  /// cleaned up by the OS automatically.
  static Future<void> shareImage(
    Uint8List imageBytes, {
    String fileName = 'aman_geh_watermarked.png',
    String subject = 'Watermarked ID Document',
  }) async {
    final file = await FileHelper.saveToTemp(imageBytes, fileName);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
        subject: subject,
      ),
    );
  }
}
