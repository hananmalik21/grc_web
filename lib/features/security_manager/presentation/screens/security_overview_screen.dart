import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../core/widgets/common/digify_tab_header.dart';
import '../../../../core/widgets/common/enterprise_selector_widget.dart';
import '../providers/security_console_overview/security_manager_enterprise_provider.dart';
import '../widgets/security_console_overview/security_activity_and_roles_section.dart';
import '../widgets/security_console_overview/security_stats_cards.dart';
import '../widgets/security_console_overview/security_distribution_section.dart';
import '../widgets/security_console_overview/user_access_status_cards.dart';

class SecurityOverviewScreen extends ConsumerWidget {
  const SecurityOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveEnterpriseId = ref.watch(securityManagerEnterpriseIdProvider);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyTabHeader(
              title: localizations.securityConsoleOverview,
              description: 'Comprehensive view of users, roles, and system access across the organization',
            ),
            Gap(24.h),
            EnterpriseSelectorWidget(
              selectedEnterpriseId: effectiveEnterpriseId,
              onEnterpriseChanged: (enterpriseId) {
                ref.read(securityManagerSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
              },
            ),
            Gap(24.h),
            SecurityStatsCards(localizations: localizations, isDark: isDark),
            Gap(24.h),
            SecurityDistributionSection(isDark: isDark),
            Gap(24.h),
            UserAccessStatusCards(localizations: localizations, isDark: isDark),
            Gap(24.h),
            SecurityActivityAndRolesSection(isDark: isDark),
          ],
        ),
      ),
    );
  }
}
