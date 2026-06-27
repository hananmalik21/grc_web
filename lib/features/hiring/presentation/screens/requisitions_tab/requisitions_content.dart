import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/mobile/requisitions_filter_bar_mobile.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/mobile/requisitions_list_mobile.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_data_table.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_filter_bar.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_stat_grid.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RequisitionsContent extends StatelessWidget {
  const RequisitionsContent({required this.padding, required this.header, required this.enterpriseSelector, super.key});

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
            const RequisitionsStatGrid(),
            Gap(sectionSpacing),
            if (isMobile) const RequisitionsFilterBarMobile() else const RequisitionsFilterBar(),
            Gap(sectionSpacing),
            if (isMobile) const RequisitionsListMobile() else const RequisitionsDataTable(),
          ],
        ),
      ),
    );
  }
}
