import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

/// Handles reading and writing images from/to the local file system.
///
/// Acts as the sole gateway for image I/O so the viewmodel and view
/// layers stay fully decoupled from platform file access.
class LocalImageDatasource {
  LocalImageDatasource({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;
  bool _isPicking = false;

  /// Opens the device camera and returns the captured photo bytes,
  /// or `null` if the user cancelled.
  Future<Uint8List?> captureFromCamera() => _pickImage(
    source: ImageSource.camera,
    preferredCameraDevice: CameraDevice.rear,
  );

  /// Opens the native gallery picker and returns the selected photo bytes,
  /// or `null` if the user cancelled.
  Future<Uint8List?> pickFromGallery() =>
      _pickImage(source: ImageSource.gallery);

  Future<Uint8List?> _pickImage({
    required ImageSource source,
    CameraDevice? preferredCameraDevice,
  }) async {
    if (_isPicking) return null;

    _isPicking = true;
    try {
      final xFile = preferredCameraDevice == null
          ? await _picker.pickImage(source: source, imageQuality: 95)
          : await _picker.pickImage(
              source: source,
              imageQuality: 95,
              preferredCameraDevice: preferredCameraDevice,
            );
      return xFile?.readAsBytes();
    } on PlatformException catch (error) {
      if (error.code == 'already_active') {
        return null;
      }
      rethrow;
    } finally {
      _isPicking = false;
    }
  }
}
