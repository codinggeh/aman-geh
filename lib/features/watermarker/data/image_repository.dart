import 'dart:typed_data';

import '../../../core/image_engine/watermark_renderer.dart';
import '../../../core/utils/pdf_helper.dart';
import '../../../core/utils/share_helper.dart';
import '../model/watermark_settings.dart';
import 'local_image_datasource.dart';

/// Repository that orchestrates image fetching, watermarking
/// and exporting through the data and infrastructure layers.
class ImageRepository {
  ImageRepository({
    LocalImageDatasource? datasource,
    WatermarkRenderer? renderer,
  })  : _datasource = datasource ?? LocalImageDatasource(),
        _renderer = renderer ?? const WatermarkRenderer();

  final LocalImageDatasource _datasource;
  final WatermarkRenderer _renderer;

  /// Capture from camera.
  Future<List<Uint8List>> captureImage() => _datasource.captureFromCamera();

  /// Pick from gallery.
  Future<List<Uint8List>> pickImage() => _datasource.pickFromGallery();

  /// Apply watermark to [sourceBytes] using [settings].
  Future<Uint8List> applyWatermark(
    Uint8List sourceBytes,
    WatermarkSettings settings,
  ) =>
      _renderer.render(sourceBytes, settings);

  /// Share directly via OS share sheet.
  Future<void> shareImages(List<Uint8List> bytesList) => ShareHelper.shareImages(bytesList);

  /// Generate a PDF containing the given image bytes.
  Future<Uint8List> generatePdf(List<Uint8List> imagesBytes, {int rotationDegrees = 0}) => 
      PdfHelper.generatePdfFromImages(imagesBytes, rotationDegrees: rotationDegrees);

  /// Share PDF via OS share sheet.
  Future<void> sharePdf(Uint8List bytes) => ShareHelper.sharePdf(bytes);
}
