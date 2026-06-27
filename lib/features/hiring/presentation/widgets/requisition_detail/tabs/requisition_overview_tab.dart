import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/presentation/widgets/requisition_detail/requisition_detail_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RequisitionOverviewTab extends StatelessWidget {
  const RequisitionOverviewTab({super.key, required this.row, required this.isDark});

  final RequisitionTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktopLayout;

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                RequisitionInfoCard(row: row, isDark: isDark),
                Gap(24.h),
                CompensationCard(row: row, isDark: isDark),
                Gap(24.h),
                JobDescriptionCard(row: row, isDark: isDark),
                Gap(24.h),
                RequirementsCard(row: row, isDark: isDark),
              ],
            ),
          ),
          Gap(24.w),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                HiringTeamCard(row: row, isDark: isDark),
                Gap(24.h),
                PriorityCard(row: row, isDark: isDark),
                Gap(24.h),
                QuickStatsCard(row: row, isDark: isDark),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      children: [
        RequisitionInfoCard(row: row, isDark: isDark),
        Gap(24.h),
        CompensationCard(row: row, isDark: isDark),
        Gap(24.h),
        JobDescriptionCard(row: row, isDark: isDark),
        Gap(24.h),
        RequirementsCard(row: row, isDark: isDark),
        Gap(24.h),
        HiringTeamCard(row: row, isDark: isDark),
        Gap(24.h),
        PriorityCard(row: row, isDark: isDark),
        Gap(24.h),
        QuickStatsCard(row: row, isDark: isDark),
      ],
    );
  }
}
