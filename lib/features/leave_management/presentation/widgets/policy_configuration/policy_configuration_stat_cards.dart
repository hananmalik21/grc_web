import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/features/leave_management/presentation/widgets/common/leave_management_stat_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PolicyConfigurationStatCards extends StatefulWidget {
  const PolicyConfigurationStatCards({super.key, required this.isDark});

  final bool isDark;

  @override
  State<PolicyConfigurationStatCards> createState() => _PolicyConfigurationStatCardsState();
}

class _PolicyConfigurationStatCardsState extends State<PolicyConfigurationStatCards> {
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
    final cards = [
      LeaveManagementStatCard(
        label: 'Total Policies',
        value: '8',
        iconPath: Assets.icons.leaveManagement.forfeitReports.path,
        isDark: widget.isDark,
      ),
      LeaveManagementStatCard(
        label: 'Compliant Policies',
        value: '7',
        iconPath: Assets.icons.checkIconGreen.path,
        isDark: widget.isDark,
      ),
      LeaveManagementStatCard(
        label: 'Encashment Enabled',
        value: '1',
        iconPath: Assets.icons.clockIcon.path,
        isDark: widget.isDark,
      ),
      LeaveManagementStatCard(
        label: 'Active Policies',
        value: '1',
        iconPath: Assets.icons.leaveManagement.dollar.path,
        isDark: widget.isDark,
      ),
      LeaveManagementStatCard(
        label: 'Affected Employees',
        value: '1',
        iconPath: Assets.icons.employeeListIcon.path,
        isDark: widget.isDark,
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
              SizedBox(width: cardWidth, child: cards[index]),
              if (index < cards.length - 1) Gap(spacing),
            ],
          ],
        ),
      ),
    );
  }
}
