import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/distribution_list_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SecurityDistributionSection extends StatelessWidget {
  final bool isDark;

  const SecurityDistributionSection({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMobile = ResponsiveHelper.isMobile(context);

    return isMobile
        ? Column(children: [_buildUserDistribution(l10n), Gap(24.h), _buildRoleDistribution(l10n)])
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildUserDistribution(l10n)),
              Gap(24.w),
              Expanded(child: _buildRoleDistribution(l10n)),
            ],
          );
  }

  Widget _buildUserDistribution(AppLocalizations l10n) {
    return DistributionListCard(
      title: l10n.userDistributionByDepartment,
      isDark: isDark,
      items: [
        DistributionItem(
          title: l10n.executive,
          subtitle: '17% of users',
          value: '1',
          unit: l10n.usersUnit,
          iconPath: Assets.icons.employeesBlueIcon.path,
        ),
        DistributionItem(
          title: 'HR',
          subtitle: '0% of users',
          value: '0',
          unit: l10n.usersUnit,
          iconPath: Assets.icons.employeesBlueIcon.path,
        ),
        DistributionItem(
          title: l10n.finance,
          subtitle: '17% of users',
          value: '1',
          unit: l10n.usersUnit,
          iconPath: Assets.icons.employeesBlueIcon.path,
        ),
        DistributionItem(
          title: l10n.it,
          subtitle: '17% of users',
          value: '1',
          unit: l10n.usersUnit,
          iconPath: Assets.icons.employeesBlueIcon.path,
        ),
        DistributionItem(
          title: l10n.operations,
          subtitle: '0% of users',
          value: '0',
          unit: l10n.usersUnit,
          iconPath: Assets.icons.employeesBlueIcon.path,
        ),
      ],
    );
  }

  Widget _buildRoleDistribution(AppLocalizations l10n) {
    return DistributionListCard(
      title: l10n.roleTypeDistribution,
      isDark: isDark,
      items: [
        DistributionItem(
          title: 'Roles Management',
          subtitle: 'All role types',
          value: '45',
          unit: l10n.rolesUnit,
          iconPath: Assets.icons.securityIcon.path,
        ),
      ],
    );
  }
}
