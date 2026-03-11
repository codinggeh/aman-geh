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
    final sourceBytes = ref.read(sourceImageProvider);
    if (sourceBytes == null) return;

    final settings = ref.read(watermarkSettingsProvider);
    final repo = ref.read(imageRepositoryProvider);
    ref.read(isProcessingProvider.notifier).set(true);

    try {
      final rendered = await repo.applyWatermark(sourceBytes, settings);
      if (!mounted) return;
      await repo.shareImage(rendered);
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

    if (sourceBytes == null) {
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
            child: InteractivePreview(
              imageBytes: MemoryImage(sourceBytes),
              settings: ref.watch(watermarkSettingsProvider),
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
