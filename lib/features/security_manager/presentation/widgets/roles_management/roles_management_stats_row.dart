import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'roles_management_common_widgets.dart';

class RolesManagementStatsRow extends StatelessWidget {
  const RolesManagementStatsRow({super.key, required this.state});

  final RolesManagementState state;

  @override
  Widget build(BuildContext context) {
    final cards = [
      RolesManagementStatsCardData(
        title: 'Total Roles',
        value: state.filteredRolesCount.toString(),
        iconPath: Assets.icons.securityIcon.path,
      ),
      RolesManagementStatsCardData(
        title: 'System Roles',
        value: state.filteredSystemRolesCount.toString(),
        iconPath: Assets.icons.tasksIcon.path,
      ),
      RolesManagementStatsCardData(
        title: 'Custom Roles',
        value: state.filteredCustomRolesCount.toString(),
        iconPath: Assets.icons.employeeListIcon.path,
      ),
      RolesManagementStatsCardData(
        title: 'Users Assigned',
        value: state.filteredUsersAssignedCount.toString(),
        iconPath: Assets.icons.leaveManagement.martialStatus.path,
      ),
    ];

    if (context.isMobile) {
      return Column(
        spacing: 12.h,
        children: cards.map((item) => RolesManagementStatsCard(data: item)).toList(),
      );
    }

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
