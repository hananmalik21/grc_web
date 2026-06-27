import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_data_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SalaryChangeHistoryContent extends StatelessWidget {
  const SalaryChangeHistoryContent({
    required this.padding,
    required this.sectionSpacing,
    required this.header,
    required this.enterpriseSelector,
    required this.onSearchChanged,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final double sectionSpacing;
  final Widget header;
  final Widget enterpriseSelector;
  final ValueChanged<String> onSearchChanged;
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
            SalaryChangeHistoryDataSection(
              onSearchChanged: onSearchChanged,
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
