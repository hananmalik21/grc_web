import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/features/security_manager/presentation/providers/application_roles/application_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/application_roles/application_roles_config.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ApplicationRolesStatsRow extends ConsumerStatefulWidget {
  const ApplicationRolesStatsRow({super.key});

  @override
  ConsumerState<ApplicationRolesStatsRow> createState() => _ApplicationRolesStatsRowState();
}

class _ApplicationRolesStatsRowState extends ConsumerState<ApplicationRolesStatsRow> {
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(applicationRolesProvider);
    final cards = buildApplicationRolesStatsCards(
      totalRoles: state.totalRolesCount,
      activeRoles: state.activeRolesCount,
      usersAssigned: state.totalUsersAssigned,
      systemRoles: state.systemRolesCount,
    );
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
