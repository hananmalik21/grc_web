import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/overtime_configuration/component_approval_workflow.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/overtime_configuration/component_compliance_score.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/overtime_configuration/component_configuration_information.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/overtime_configuration/component_labor_law_limits.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/overtime_configuration/component_rate_multipliers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class OvertimeConfigurationContent extends ConsumerWidget {
  const OvertimeConfigurationContent({
    required this.padding,
    required this.header,
    required this.enterpriseSelector,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final Widget header;
  final Widget enterpriseSelector;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final isMobile = context.isMobileLayout;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24.h,
          children: [
            header,
            enterpriseSelector,
            const ComponentConfigurationInformation(),
            StaggeredGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 24.h,
              crossAxisSpacing: 24.w,
              children: [
                StaggeredGridTile.fit(crossAxisCellCount: isMobile ? 3 : 2, child: const ComponentRateMultipliers()),
                StaggeredGridTile.fit(crossAxisCellCount: isMobile ? 3 : 1, child: const ComponentLaborLawLimit()),
                StaggeredGridTile.fit(crossAxisCellCount: isMobile ? 3 : 2, child: const ComponentApprovalWorkflow()),
                StaggeredGridTile.fit(crossAxisCellCount: isMobile ? 3 : 1, child: const ComponentComplianceScore()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
