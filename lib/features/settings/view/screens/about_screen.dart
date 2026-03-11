import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_version_footer.dart';
import '../../../../core/widgets/aurora_surface.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('about_title'.tr())),
      body: AuroraBackground(
        topSafeArea: false,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: ListView(
          children: [
            GlassPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: cs.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.shield_outlined, color: cs.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'app_name'.tr(),
                              style: theme.textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'about_description'.tr(),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GlassPanel(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  _InfoTile(
                    icon: Icons.wifi_off_rounded,
                    title: 'offline_title'.tr(),
                    subtitle: 'offline_desc'.tr(),
                  ),
                  const Divider(height: 1),
                  _InfoTile(
                    icon: Icons.security_rounded,
                    title: 'sandbox_title'.tr(),
                    subtitle: 'sandbox_desc'.tr(),
                  ),
                  const Divider(height: 1),
                  _InfoTile(
                    icon: Icons.privacy_tip_rounded,
                    title: 'privacy_first_title'.tr(),
                    subtitle: 'privacy_first_desc'.tr(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text('copyright'.tr(), style: theme.textTheme.bodySmall),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppVersionFooter(),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: cs.surfaceContainerLow,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: cs.primary, size: 18),
      ),
      title: Text(title, style: theme.textTheme.titleSmall),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
    );
  }
}
