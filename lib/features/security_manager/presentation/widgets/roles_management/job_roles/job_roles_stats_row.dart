import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_common_widgets.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobRolesStatsRow extends ConsumerStatefulWidget {
  const JobRolesStatsRow({super.key});

  @override
  ConsumerState<JobRolesStatsRow> createState() => _JobRolesStatsRowState();
}

class _JobRolesStatsRowState extends ConsumerState<JobRolesStatsRow> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _parseUsersAssigned(String label) {
    final match = RegExp(r'\d+').firstMatch(label);
    return int.tryParse(match?.group(0) ?? '') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(jobRolesProvider);
    final cards = [
      RolesManagementStatsCardData(
        title: 'Total Roles',
        value: state.totalItems.toString(),
        subtitle: 'Job roles defined',
        iconPath: Assets.icons.securityManager.database.path,
      ),
      RolesManagementStatsCardData(
        title: 'Active Roles',
        value: state.roles.where((r) => r.isActive).length.toString(),
        subtitle: 'Currently active',
        iconPath: Assets.icons.checkIconGreen.path,
      ),
      RolesManagementStatsCardData(
        title: 'Total Users',
        value: state.roles.fold<int>(0, (sum, role) => sum + _parseUsersAssigned(role.usersAssignedLabel)).toString(),
        subtitle: 'Users assigned',
        iconPath: Assets.icons.employeeListIcon.path,
      ),
      RolesManagementStatsCardData(
        title: 'Auto-Assign',
        value: state.roles.where((r) => r.isAutoAssign).length.toString(),
        subtitle: 'Auto-assign enabled',
        iconPath: Assets.icons.securityManager.functionalRoles.path,
      ),
    ];

    final cardWidth = ResponsiveHelper.getResponsiveWidth(context, mobile: 220, tablet: 236, web: 252);
    final spacing = ResponsiveHelper.getResponsiveWidth(context, mobile: 12, tablet: 16, web: 20);

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < cards.length; index++) ...[
              SizedBox(
                width: cardWidth,
                child: RolesManagementStatsCard(data: cards[index]),
              ),
              if (index < cards.length - 1) Gap(spacing),
            ],
          ],
        ),
      ),
    );
  }
}
