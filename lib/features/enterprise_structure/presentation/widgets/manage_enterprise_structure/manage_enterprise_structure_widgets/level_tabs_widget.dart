import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Tab item for level tabs
class LevelTabItem {
  final String code;
  final String label;
  final String iconPath;

  const LevelTabItem({required this.code, required this.label, required this.iconPath});
}

/// Widget for displaying level tabs (Tree View, Company, Division, etc.)
class LevelTabsWidget extends StatelessWidget {
  final List<LevelTabItem> tabs;
  final String? selectedLevelCode;
  final ValueChanged<String>? onTabSelected;
  final bool isDark;

  const LevelTabsWidget({
    super.key,
    required this.tabs,
    this.selectedLevelCode,
    this.onTabSelected,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    if (tabs.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: tabs.map((tab) {
            final isSelected = selectedLevelCode == tab.code;
            return _buildTabButton(context, tab, isSelected);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, LevelTabItem tab, bool isSelected) {
    return GestureDetector(
      onTap: () => onTabSelected?.call(tab.code),
      child: Container(
        margin: EdgeInsetsDirectional.only(end: 4.w),
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : (isDark ? AppColors.cardBackgroundDark : Colors.white),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: isSelected
              ? null
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 1), blurRadius: 2)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DigifyAsset(
              assetPath: tab.iconPath,
              width: 16,
              height: 16,
              color: isSelected ? Colors.white : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
            ),
            SizedBox(width: 8.w),
            Text(
              tab.label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
