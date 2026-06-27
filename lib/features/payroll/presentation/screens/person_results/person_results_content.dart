import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/payroll/presentation/widgets/person_results/person_results_data_table.dart';
import 'package:grc/features/payroll/presentation/widgets/person_results/person_results_header.dart';
import 'package:grc/features/payroll/presentation/widgets/person_results/person_results_list_mobile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PersonResultsContent extends StatelessWidget {
  const PersonResultsContent({required this.padding, super.key});

  final EdgeInsetsGeometry padding;

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
            const PersonResultsHeader(),
            Gap(sectionSpacing),
            if (isMobile) const PersonResultsListMobile() else const PersonResultsDataTable(),
          ],
        ),
      ),
    );
  }
}
