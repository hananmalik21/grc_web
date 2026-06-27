import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plans_dashboard.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plans_stat_grid.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CompensationPlansContent extends StatelessWidget {
  const CompensationPlansContent({
    required this.padding,
    required this.header,
    required this.enterpriseSelector,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final Widget header;
  final Widget enterpriseSelector;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);

    return Container(
      color: context.isDark ? AppColors.backgroundDark : AppColors.background,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            Gap(sectionSpacing),
            enterpriseSelector,
            Gap(sectionSpacing),
            const CompensationPlansStatGrid(),
            Gap(sectionSpacing),
            CompensationPlansDashboard(onExport: onExport, isExporting: isExporting),
          ],
        ),
      ),
    );
  }
}
