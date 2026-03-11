import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

/// Helpers for local file I/O within the application sandbox.
abstract final class FileHelper {
  /// Saves [bytes] to a temporary file suitable for sharing.
  static Future<File> saveToTemp(Uint8List bytes, String fileName) async {
    final tmpDir = await getTemporaryDirectory();
    final file = File('${tmpDir.path}/$fileName');
    return file.writeAsBytes(bytes, flush: true);
  }

  /// Reads file at [path] and returns its bytes.
  static Future<Uint8List> readBytes(String path) async {
    return File(path).readAsBytes();
  }

  /// Deletes a file if it exists.
  static Future<void> deleteFile(String path) async {
    final file = File(path);
    if (file.existsSync()) {
      await file.delete();
    }
  }
}
