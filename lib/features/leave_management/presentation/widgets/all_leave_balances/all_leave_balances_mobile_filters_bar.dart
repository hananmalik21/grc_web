import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AllLeaveBalancesMobileFiltersBar extends StatelessWidget {
  const AllLeaveBalancesMobileFiltersBar({
    super.key,
    required this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onExport,
    this.onRefresh,
    this.isExporting = false,
  });

  final TextEditingController searchController;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onExport;
  final VoidCallback? onRefresh;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: DigifyTextField.search(
              controller: searchController,
              hintText: 'Search...',
              filled: false,
              borderColor: isDark ? AppColors.inputBorderDark : AppColors.inputBorder,
              onChanged: onSearchChanged,
              onSubmitted: onSearchSubmitted,
            ),
          ),
          Gap(12.w),
          AppMobileButton.outline(
            svgPath: Assets.icons.downloadIcon.path,
            onPressed: isExporting ? null : onExport,
            isLoading: isExporting,
          ),
          Gap(8.w),
          AppMobileButton.primary(svgPath: Assets.icons.refreshGray.path, onPressed: onRefresh),
        ],
      ),
    );
  }
}
