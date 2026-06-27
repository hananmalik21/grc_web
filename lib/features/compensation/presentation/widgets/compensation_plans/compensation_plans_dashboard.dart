import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/compensation/presentation/widgets/mobile/compensation_plans_filter_bar_mobile.dart';
import 'package:grc/features/compensation/presentation/widgets/mobile/compensation_plans_mobile_insights.dart';
import 'package:grc/features/compensation/presentation/widgets/mobile/compensation_plans_list_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'compensation_plans_charts_section.dart';
import 'compensation_plans_data_table.dart';
import 'compensation_plans_filter_bar.dart';

class CompensationPlansDashboard extends StatelessWidget {
  const CompensationPlansDashboard({this.onExport, this.isExporting = false, super.key});

  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompensationPlansFilterBarMobile(onExport: onExport, isExporting: isExporting),
          Gap(16.h),
          const CompensationPlansListMobile(),
          Gap(16.h),
          const CompensationPlansMobileInsights(),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompensationPlansFilterBar(onExport: onExport, isExporting: isExporting),
        Gap(16.h),
        const CompensationPlansDataTable(),
        Gap(16.h),
        const CompensationPlansChartsSection(),
      ],
    );
  }
}
