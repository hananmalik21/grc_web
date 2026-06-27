import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_common_widgets.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DataRolesStatsRow extends StatelessWidget {
  const DataRolesStatsRow({super.key, required this.totalRoles, required this.activeRoles});

  final int totalRoles;
  final int activeRoles;

  @override
  Widget build(BuildContext context) {
    final cards = [
      RolesManagementStatsCardData(
        title: 'Total Roles',
        value: totalRoles.toString(),
        subtitle: 'Data roles defined',
        iconPath: Assets.icons.securityManager.dataRoles.path,
      ),
      RolesManagementStatsCardData(
        title: 'Active Roles',
        value: activeRoles.toString(),
        subtitle: 'Currently active',
        iconPath: Assets.icons.checkIconGreen.path,
      ),
    ];

    return Row(
      children: [
        for (int index = 0; index < cards.length; index++) ...[
          Expanded(child: RolesManagementStatsCard(data: cards[index])),
          if (index != cards.length - 1) Gap(12.w),
        ],
      ],
    );
  }
}
