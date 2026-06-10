import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_version_footer.dart';
import '../../../../core/widgets/aurora_surface.dart';
import '../../viewmodel/image_viewmodel.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _pickImage(
    BuildContext context,
    WidgetRef ref, {
    required bool fromCamera,
  }) async {
    if (ref.read(isPickingSourceProvider)) return;

    HapticFeedback.lightImpact();
    ref.read(isPickingSourceProvider.notifier).set(true);
    final repo = ref.read(imageRepositoryProvider);
    try {
      final bytes = fromCamera
          ? await repo.captureImage()
          : await repo.pickImage();

      if (bytes.isNotEmpty && context.mounted) {
        ref.read(sourceImageProvider.notifier).set(bytes);
        context.push('/editor');
      }
    } finally {
      ref.read(isPickingSourceProvider.notifier).set(false);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isPickingSource = ref.watch(isPickingSourceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('app_name'.tr()),
        actions: [
          IconButton(
            onPressed: () => context.push('/settings'),
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'settings'.tr(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: AuroraBackground(
        topSafeArea: false,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: ListView(
          children: [
            Text('home_title'.tr(), style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('home_subtitle'.tr(), style: theme.textTheme.bodySmall),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _HomeMenuCard(
                    icon: Icons.camera_alt_rounded,
                    title: 'camera'.tr(),
                    subtitle: 'camera_desc'.tr(),
                    filled: true,
                    enabled: !isPickingSource,
                    onTap: () => _pickImage(context, ref, fromCamera: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _HomeMenuCard(
                    icon: Icons.photo_library_rounded,
                    title: 'gallery'.tr(),
                    subtitle: 'gallery_desc'.tr(),
                    enabled: !isPickingSource,
                    onTap: () => _pickImage(context, ref, fromCamera: false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppVersionFooter(),
    );
  }
}

class _HomeMenuCard extends StatelessWidget {
  const _HomeMenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.filled = false,
    this.enabled = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool filled;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return AspectRatio(
      aspectRatio: 1,
      child: Opacity(
        opacity: enabled ? 1 : 0.6,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(16),
            child: GlassPanel(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              gradient: filled
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [cs.primary, cs.primary.withValues(alpha: 0.92)],
                    )
                  : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: filled
                          ? Colors.white.withValues(alpha: 0.16)
                          : cs.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: filled
                          ? null
                          : Border.all(color: cs.outlineVariant),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: filled ? cs.onPrimary : cs.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: filled ? cs.onPrimary : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: filled
                          ? cs.onPrimary.withValues(alpha: 0.84)
                          : cs.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
