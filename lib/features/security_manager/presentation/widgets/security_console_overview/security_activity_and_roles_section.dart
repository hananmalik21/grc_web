import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/distribution_list_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/localization/l10n/app_localizations.dart';

class SecurityActivityAndRolesSection extends StatelessWidget {
  final bool isDark;

  const SecurityActivityAndRolesSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = ResponsiveHelper.isMobile(context);

    return isMobile
        ? Column(
            children: [
              _buildRecentActivity(l10n),
              Gap(24.h),
              _buildTopRoles(l10n),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildRecentActivity(l10n)),
              Gap(24.w),
              Expanded(child: _buildTopRoles(l10n)),
            ],
          );
  }

  Widget _buildRecentActivity(AppLocalizations l10n) {
    return DistributionListCard(
      title: "Recent User Activity",
      isDark: isDark,
      items: [
        DistributionItem(
          title: 'John Smith',
          subtitle: "Logged in",
          value: '',
          unit: l10n.hoursAgo(2),
          iconPath: Assets.icons.employeesBlueIcon.path,
        ),
        DistributionItem(
          title: 'Sarah Johnson',
          subtitle: "Password changed",
          value: '',
          unit: l10n.hoursAgo(5),
          iconPath: Assets.icons.securityIcon.path,
        ),
        DistributionItem(
          title: 'Ahmed Al-Mutairi',
          subtitle: "MFA enabled",
          value: '',
          unit: l10n.daysAgo(1),
          iconPath: Assets.icons.employeesBlueIcon.path,
        ),
        DistributionItem(
          title: 'Emily Davis',
          subtitle: "Role updated",
          value: '',
          unit: l10n.daysAgo(2),
          iconPath: Assets.icons.securityIcon.path,
        ),
        DistributionItem(
          title: 'Michael Chen',
          subtitle: "Access granted",
          value: '',
          unit: l10n.daysAgo(3),
          iconPath: Assets.icons.checkIconGreen.path,
        ),
      ],
    );
  }

  Widget _buildTopRoles(AppLocalizations l10n) {
    return DistributionListCard(
      title: 'Top Assigned Roles',
      isDark: isDark,
      items: [
        DistributionItem(
          title: 'Employee Self Service',
          subtitle: "Application role",
          value: '10',
          unit: l10n.usersUnit,
          iconPath: Assets.icons.securityIcon.path,
        ),
        DistributionItem(
          title: "HR Manager",
          subtitle: l10n.jobRole,
          value: '8',
          unit: l10n.usersUnit,
          iconPath: Assets.icons.securityIcon.path,
        ),
        DistributionItem(
          title: 'Payroll Processor',
          subtitle: l10n.dutyRole,
          value: '6',
          unit: l10n.usersUnit,
          iconPath: Assets.icons.securityIcon.path,
        ),
        DistributionItem(
          title: "Department Manager",
          subtitle: 'Data role',
          value: '5',
          unit: l10n.usersUnit,
          iconPath: Assets.icons.securityIcon.path,
        ),
        DistributionItem(
          title: l10n.leaveManagement,
          subtitle: "Function role",
          value: '4',
          unit: l10n.usersUnit,
          iconPath: Assets.icons.securityIcon.path,
        ),
      ],
    );
  }
}
