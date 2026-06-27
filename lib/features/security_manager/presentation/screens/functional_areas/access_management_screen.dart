import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
// import '../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/common/digify_tab_header.dart';
import '../../../../../core/widgets/common/enterprise_selector_widget.dart';
import '../../providers/access_management/access_management_enterprise_provider.dart';
import '../../providers/access_management/access_management_provider.dart';
import '../../widgets/access_management/access_activity_log_section.dart';
import '../../widgets/access_management/access_role_details_section.dart';
import '../../widgets/access_management/access_role_list.dart';
import '../../widgets/access_management/access_stats_cards.dart';
import '../../widgets/access_management/access_user_assignment_section.dart';

class AccessManagementScreen extends ConsumerWidget {
  const AccessManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // late final localizations = AppLocalizations.of(context)!;
    final effectiveEnterpriseId = ref.watch(accessManagementEnterpriseIdProvider);
    final state = ref.watch(accessManagementProvider);

    return Container(
      color: context.isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyTabHeader(
              title: 'Access Management',
              description: 'Manage roles, permissions and user access all modes',
            ),
            Gap(24.h),
            EnterpriseSelectorWidget(
              selectedEnterpriseId: effectiveEnterpriseId,
              onEnterpriseChanged: (enterpriseId) {
                ref.read(accessManagementSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
              },
            ),
            Gap(24.h),
            const AccessStatsCards(),
            Gap(24.h),
            if (context.isMobile) ...[
              AccessRoleList(),
              if (state.roleDetail != null) ...[Gap(24.h), AccessRoleDetailsSection()],
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: AccessRoleList()),
                  if (state.roleDetail != null) ...[Gap(24.w), Expanded(flex: 3, child: AccessRoleDetailsSection())],
                ],
              ),
            ],
            if (state.roleDetail != null) ...[
              Gap(24.h),
              if (context.isMobile) ...[
                const AccessUserAssignmentSection(),
                Gap(24.h),
                AccessActivityLogSection(),
              ] else ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(child: AccessUserAssignmentSection()),
                    Gap(24.w),
                    Expanded(child: AccessActivityLogSection()),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
