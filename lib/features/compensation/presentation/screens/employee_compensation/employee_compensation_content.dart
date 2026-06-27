import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/presentation/widgets/employee_compensation/employee_compensation_data_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EmployeeCompensationContent extends StatelessWidget {
  const EmployeeCompensationContent({
    required this.padding,
    required this.sectionSpacing,
    required this.header,
    required this.enterpriseSelector,
    required this.searchController,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final double sectionSpacing;
  final Widget header;
  final Widget enterpriseSelector;
  final TextEditingController searchController;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
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
            EmployeeCompensationDataSection(
              searchController: searchController,
              sectionSpacing: sectionSpacing,
              onExport: onExport,
              isExporting: isExporting,
            ),
          ],
        ),
      ),
    );
  }
}
