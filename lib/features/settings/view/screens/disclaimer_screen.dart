import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';


import '../../../../core/widgets/app_version_footer.dart';
import '../../../../core/widgets/aurora_surface.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Scaffold(
      appBar: AppBar(title: Text('disclaimer_title'.tr())),
      body: AuroraBackground(
        topSafeArea: false,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: ListView(
          children: [
            GlassPanel(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    'disclaimer_intro'.tr(),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'disclaimer_rights'.tr(),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'assets_title'.tr(),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'assets_body'.tr(),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'purpose_title'.tr(),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'purpose_body'.tr(),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'developer_title'.tr(),
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'developer_body'.tr(),
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'developer_tagline'.tr(),
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'disclaimer_footer'.tr(),
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppVersionFooter(),
    );
  }
}
