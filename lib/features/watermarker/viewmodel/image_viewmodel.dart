import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/image_repository.dart';

/// ViewModel holding the in-memory source image bytes selected by the user.
class SourceImageNotifier extends Notifier<List<Uint8List>> {
  @override
  List<Uint8List> build() => [];

  void set(List<Uint8List> bytes) => state = bytes;
  void add(Uint8List bytes) => state = [...state, bytes];
  void clear() => state = [];
}

/// Holds the in-memory source image bytes selected by the user.
final sourceImageProvider = NotifierProvider<SourceImageNotifier, List<Uint8List>>(
  SourceImageNotifier.new,
);

/// Singleton repository provider.
final imageRepositoryProvider = Provider<ImageRepository>(
  (ref) => ImageRepository(),
);

/// ViewModel for processing state.
class ProcessingNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

/// Indicates whether a render / export is in progress.
final isProcessingProvider = NotifierProvider<ProcessingNotifier, bool>(
  ProcessingNotifier.new,
);

/// ViewModel for source picker state.
class PickingSourceNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

/// Indicates whether the native image picker is currently active.
final isPickingSourceProvider = NotifierProvider<PickingSourceNotifier, bool>(
  PickingSourceNotifier.new,
);
