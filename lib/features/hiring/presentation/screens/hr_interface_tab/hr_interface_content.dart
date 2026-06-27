import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/presentation/widgets/hr_interface/hr_interface_offers_list_desktop.dart';
import 'package:grc/features/hiring/presentation/widgets/hr_interface/hr_interface_offers_list_mobile.dart';
import 'package:grc/features/hiring/presentation/widgets/hr_interface/hr_interface_stats_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HrInterfaceContent extends StatelessWidget {
  const HrInterfaceContent({required this.padding, required this.header, required this.enterpriseSelector, super.key});

  final EdgeInsetsGeometry padding;
  final Widget header;
  final Widget enterpriseSelector;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
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
            const HrInterfaceStatsSection(),
            Gap(sectionSpacing),
            if (isMobile) const HrInterfaceOffersListMobile() else const HrInterfaceOffersListDesktop(),
          ],
        ),
      ),
    );
  }
}
