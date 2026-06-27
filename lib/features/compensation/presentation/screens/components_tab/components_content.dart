import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/compensation/presentation/widgets/components/components_alerts_section.dart';
import 'package:grc/features/compensation/presentation/widgets/components/components_analytics_section.dart';
import 'package:grc/features/compensation/presentation/widgets/components/components_data_table.dart';
import 'package:grc/features/compensation/presentation/widgets/components/components_filter_bar.dart';
import 'package:grc/features/compensation/presentation/widgets/components/components_stat_grid.dart';
import 'package:grc/features/compensation/presentation/widgets/mobile/components_filter_bar_mobile.dart';
import 'package:grc/features/compensation/presentation/widgets/mobile/components_list_mobile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ComponentsContent extends StatelessWidget {
  const ComponentsContent({
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
    final layout = context.screenLayout;
    final isMobile = layout.isMobile;
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
            const ComponentsStatGrid(),
            Gap(sectionSpacing),
            if (isMobile)
              ComponentsFilterBarMobile(onExport: onExport, isExporting: isExporting)
            else
              ComponentsFilterBar(onExport: onExport, isExporting: isExporting),
            Gap(sectionSpacing),
            if (isMobile) const ComponentsListMobile() else const ComponentsDataTable(),
            Gap(sectionSpacing),
            const ComponentsAnalyticsSection(),
            Gap(sectionSpacing),
            const ComponentsAlertsSection(),
          ],
        ),
      ),
    );
  }
}
