import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/aurora_surface.dart';
import '../../viewmodel/image_viewmodel.dart';
import '../../viewmodel/watermark_viewmodel.dart';
import '../widgets/interactive_preview.dart';
import '../widgets/watermark_controls.dart';

class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen({super.key});

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
  Future<void> _exportAndShare() async {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Export as Image'),
                onTap: () {
                  Navigator.pop(context);
                  _processAndShare(asPdf: false);
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('Export as PDF...'),
                onTap: () {
                  Navigator.pop(context);
                  _showPdfOptions();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPdfOptions() {
    int rotation = 0;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('PDF Options'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Page Rotation:'),
                  RadioListTile<int>(
                    title: const Text('0°'),
                    value: 0,
                    groupValue: rotation,
                    onChanged: (v) => setState(() => rotation = v!),
                  ),
                  RadioListTile<int>(
                    title: const Text('90°'),
                    value: 90,
                    groupValue: rotation,
                    onChanged: (v) => setState(() => rotation = v!),
                  ),
                  RadioListTile<int>(
                    title: const Text('180°'),
                    value: 180,
                    groupValue: rotation,
                    onChanged: (v) => setState(() => rotation = v!),
                  ),
                  RadioListTile<int>(
                    title: const Text('270°'),
                    value: 270,
                    groupValue: rotation,
                    onChanged: (v) => setState(() => rotation = v!),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _processAndShare(asPdf: true, rotation: rotation);
                  },
                  child: const Text('Export'),
                ),
              ],
            );
          }
        );
      },
    );
  }

  Future<void> _processAndShare({required bool asPdf, int rotation = 0}) async {
    final sourceBytes = ref.read(sourceImageProvider);
    if (sourceBytes.isEmpty) return;

    final settings = ref.read(watermarkSettingsProvider);
    final repo = ref.read(imageRepositoryProvider);
    ref.read(isProcessingProvider.notifier).set(true);

    try {
      final renderedList = <Uint8List>[];
      for (final bytes in sourceBytes) {
        renderedList.add(await repo.applyWatermark(bytes, settings));
      }
      
      if (!mounted) return;
      
      if (asPdf) {
        final pdfBytes = await repo.generatePdf(renderedList, rotationDegrees: rotation);
        if (!mounted) return;
        await repo.sharePdf(pdfBytes);
      } else {
        await repo.shareImages(renderedList);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${'export_failed'.tr()}: $e')));
    } finally {
      ref.read(isProcessingProvider.notifier).set(false);
    }
  }

  String _summary(BuildContext context) {
    final settings = ref.read(watermarkSettingsProvider);
    final mode = settings.isPatternMode ? 'mode_grid'.tr() : 'mode_single'.tr();
    final opacity = '${(settings.opacity * 100).round()}%';
    return '$mode • $opacity';
  }

  @override
  Widget build(BuildContext context) {
    final sourceBytes = ref.watch(sourceImageProvider);
    final isProcessing = ref.watch(isProcessingProvider);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    if (sourceBytes.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('editor'.tr())),
        body: AuroraBackground(
          topSafeArea: false,
          padding: const EdgeInsets.all(16),
          child: Center(
            child: GlassPanel(
              child: Text(
                'no_image'.tr(),
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    final preview = GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('editor'.tr(), style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(_summary(context), style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          SizedBox(
            height: 320,
            child: PageView.builder(
              itemCount: sourceBytes.length,
              itemBuilder: (context, index) {
                return InteractivePreview(
                  imageBytes: MemoryImage(sourceBytes[index]),
                  settings: ref.watch(watermarkSettingsProvider),
                );
              },
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('editor'.tr()),
        actions: [
          TextButton.icon(
            onPressed: () {
              HapticFeedback.lightImpact();
              ref.read(watermarkSettingsProvider.notifier).reset();
            },
            icon: const Icon(Icons.refresh_rounded),
            label: Text('reset'.tr()),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: AuroraBackground(
        topSafeArea: false,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 900) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: preview),
                  const SizedBox(width: 16),
                  const SizedBox(
                    width: 360,
                    child: SingleChildScrollView(child: WatermarkControls()),
                  ),
                ],
              );
            }

            return ListView(
              children: [
                preview,
                const SizedBox(height: 12),
                const WatermarkControls(),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            onPressed: isProcessing ? null : _exportAndShare,
            icon: isProcessing
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: cs.onPrimary,
                    ),
                  )
                : const Icon(Icons.ios_share_rounded),
            label: Text(isProcessing ? 'processing'.tr() : 'export'.tr()),
          ),
        ),
      ),
    );
  }
}
