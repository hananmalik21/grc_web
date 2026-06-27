import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_structure/salary_structure_filter_bar.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_structure/salary_structure_filter_bar_mobile.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_structure/salary_structure_listing_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ManageSalaryStructureContent extends ConsumerWidget {
  const ManageSalaryStructureContent({
    required this.padding,
    required this.sectionSpacing,
    required this.header,
    required this.enterpriseSelector,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final double sectionSpacing;
  final Widget header;
  final Widget enterpriseSelector;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = context.screenLayout.isMobile;

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
            if (isMobile)
              SalaryStructureFilterBarMobile(onExport: onExport, isExporting: isExporting)
            else
              SalaryStructureFilterBar(onExport: onExport, isExporting: isExporting),
            Gap(sectionSpacing),
            const SalaryStructureListingView(),
          ],
        ),
      ),
    );
  }
}
