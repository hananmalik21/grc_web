import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/navigation/sidebar/config/sidebar_config.dart';
import 'package:grc/core/navigation/sidebar/models/sidebar_item.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SidebarMenuItem extends StatelessWidget {
  const SidebarMenuItem({
    super.key,
    required this.item,
    required this.isSidebarExpanded,
    required this.isSectionExpanded,
    required this.isActive,
    required this.onRowTap,
    required this.onToggleSection,
    required this.onChildTap,
    required this.isChildActive,
    required this.localizations,
  });

  final SidebarItem item;
  final bool isSidebarExpanded;
  final bool isSectionExpanded;
  final bool isActive;
  final VoidCallback onRowTap;
  final VoidCallback onToggleSection;
  final void Function(SidebarItem) onChildTap;
  final bool Function(SidebarItem) isChildActive;
  final AppLocalizations localizations;

  @override
  Widget build(BuildContext context) {
    final hasChildren = item.children != null && item.children!.isNotEmpty;

    if (!isSidebarExpanded) {
      return _buildCondensedTile(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (hasChildren) {
              onToggleSection();
            } else {
              onRowTap();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 8.75.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.r),
              color: (isActive && !hasChildren) ? AppColors.sidebarActiveBg : Colors.transparent,
            ),
            child: Stack(
              children: [
                if (isActive && !hasChildren)
                  Positioned(
                    left: -10.w,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 3.5.w,
                      decoration: BoxDecoration(
                        color: AppColors.sidebarActiveText,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(3.5.r),
                          bottomRight: Radius.circular(3.5.r),
                        ),
                      ),
                    ),
                  ),
                Row(
                  children: [
                    if (hasChildren) ...[
                      AnimatedRotation(
                        turns: isSectionExpanded ? 0.25 : 0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        child: Icon(Icons.keyboard_arrow_right, size: 14.sp, color: AppColors.sidebarCategoryText),
                      ),
                      Gap(7.w),
                    ],
                    Expanded(
                      child: Text(
                        SidebarConfig.getLocalizedLabel(item.labelKey, localizations),
                        style: context.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isActive ? AppColors.sidebarActiveText : AppColors.inputLabel,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (hasChildren && isSectionExpanded) _buildChildren(context),
      ],
    );
  }

  Widget _buildCondensedTile(BuildContext context) {
    Widget content;

    if (item.svgPath != null) {
      content = DigifyAsset(
        assetPath: item.svgPath!,
        width: 20.w,
        height: 20.h,
        color: isActive ? AppColors.sidebarActiveText : AppColors.lightDark,
      );
    } else if (item.icon != null) {
      content = Icon(item.icon, size: 20.sp, color: isActive ? AppColors.sidebarActiveText : AppColors.lightDark);
    } else {
      content = const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      child: GestureDetector(
        onTap: onRowTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: double.infinity,
          height: 44.h,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: isActive ? AppColors.sidebarActiveBg : Colors.transparent,
          ),
          child: content,
        ),
      ),
    );
  }

  Widget _buildChildren(BuildContext context) {
    final children = item.children!;

    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsetsDirectional.only(start: 12.5.w),
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: AppColors.cardBackgroundGrey, width: 2)),
        ),
        child: Column(
          children: children.map((child) {
            final isChildActive = this.isChildActive(child);
            return Padding(
              padding: EdgeInsetsDirectional.only(start: 12.5.w),
              child: GestureDetector(
                onTap: () => onChildTap(child),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.r),
                    color: isChildActive ? AppColors.sidebarActiveBg : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          SidebarConfig.getLocalizedLabel(child.labelKey, localizations),
                          style: context.textTheme.labelSmall?.copyWith(
                            fontSize: 12.sp,
                            color: isChildActive ? AppColors.sidebarActiveText : AppColors.sidebarChildItemText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
