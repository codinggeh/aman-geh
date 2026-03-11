import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_version_footer.dart';
import '../../../../core/widgets/aurora_surface.dart';
import '../../viewmodel/settings_viewmodel.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeMode = ref.watch(themeModeProvider);
    final currentLocale = context.locale;

    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr())),
      body: AuroraBackground(
        topSafeArea: false,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: ListView(
          children: [
            _SettingsSection(
              title: 'theme'.tr(),
              description: 'theme_desc'.tr(),
              child: SegmentedButton<ThemeMode>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('system'.tr()),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text('light'.tr()),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text('dark'.tr()),
                  ),
                ],
                selected: {themeMode},
                onSelectionChanged: (selection) {
                  ref
                      .read(themeModeProvider.notifier)
                      .setThemeMode(selection.first);
                },
              ),
            ),
            const SizedBox(height: 12),
            _SettingsSection(
              title: 'language'.tr(),
              description: 'language_desc'.tr(),
              child: SegmentedButton<String>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(value: 'en', label: Text('English')),
                  ButtonSegment(value: 'id', label: Text('Indonesia')),
                ],
                selected: {currentLocale.languageCode},
                onSelectionChanged: (selection) {
                  context.setLocale(Locale(selection.first));
                },
              ),
            ),
            const SizedBox(height: 12),
            GlassPanel(
              padding: EdgeInsets.zero,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                title: Text('about'.tr(), style: theme.textTheme.titleMedium),
                subtitle: Text(
                  'about_desc'.tr(),
                  style: theme.textTheme.bodySmall,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/about'),
              ),
            ),
            const SizedBox(height: 12),
            GlassPanel(
              padding: EdgeInsets.zero,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                title: Text(
                  'disclaimer'.tr(),
                  style: theme.textTheme.titleMedium,
                ),
                subtitle: Text(
                  'disclaimer_desc'.tr(),
                  style: theme.textTheme.bodySmall,
                ),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push('/disclaimer'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppVersionFooter(),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(description, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
