import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/applications_filter_bar.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/applications_stat_grid.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/mobile/applications_filter_bar_mobile.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/applications_data_table.dart';
import 'package:grc/features/hiring/presentation/widgets/applications/mobile/applications_list_mobile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/services/responsive_service.dart';

class ApplicationsContent extends StatelessWidget {
  const ApplicationsContent({required this.padding, required this.header, required this.enterpriseSelector, super.key});

  final EdgeInsetsGeometry padding;
  final Widget header;
  final Widget enterpriseSelector;

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
            const ApplicationsStatGrid(),
            Gap(sectionSpacing),
            if (isMobile) const ApplicationsFilterBarMobile() else const ApplicationsFilterBar(),
            Gap(sectionSpacing),
            if (isMobile) const ApplicationsListMobile() else const ApplicationsDataTable(),
            Gap(sectionSpacing),
          ],
        ),
      ),
    );
  }
}
