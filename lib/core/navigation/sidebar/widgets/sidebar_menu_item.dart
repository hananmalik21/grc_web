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

  IconData _fallbackIcon(String id) {
    final lower = id.toLowerCase();
    if (lower.contains('home') || lower.contains('dash')) return Icons.home_rounded;
    if (lower.contains('enterprise') || lower.contains('structure')) return Icons.apartment_rounded;
    if (lower.contains('security') && lower.contains('manager')) return Icons.admin_panel_settings_rounded;
    if (lower.contains('grc') || lower.contains('compliance')) return Icons.verified_user_rounded;
    if (lower.contains('cyber')) return Icons.shield_rounded;
    return Icons.grid_view_rounded;
  }

  Widget _buildItemIcon(bool isCurrentActive) {
    final iconColor = isCurrentActive ? Colors.white : const Color(0xFF64748B);
    if (item.svgPath != null) {
      return DigifyAsset(
        assetPath: item.svgPath!,
        width: 18.w,
        height: 18.h,
        color: iconColor,
      );
    }
    return Icon(
      item.icon ?? _fallbackIcon(item.id),
      size: 18.sp,
      color: iconColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasChildren = item.children != null && item.children!.isNotEmpty;

    if (!isSidebarExpanded) {
      return _buildCondensedTile(context);
    }

    final isPillActive = isActive && !hasChildren;

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
            margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: isPillActive
                  ? const Color(0xFF0284C7)
                  : Colors.transparent,
              boxShadow: isPillActive
                  ? [
                      BoxShadow(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.28),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                _buildItemIcon(isPillActive),
                Gap(10.w),
                Expanded(
                  child: Text(
                    SidebarConfig.getLocalizedLabel(item.labelKey, localizations),
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: isPillActive ? FontWeight.w700 : FontWeight.w500,
                      color: isPillActive
                          ? Colors.white
                          : const Color(0xFF334155),
                      height: 1.2,
                    ),
                  ),
                ),
                if (hasChildren)
                  AnimatedRotation(
                    turns: isSectionExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      size: 16.sp,
                      color: isPillActive
                          ? Colors.white
                          : const Color(0xFF94A3B8),
                    ),
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
    final label = SidebarConfig.getLocalizedLabel(item.labelKey, localizations);
    final isPillActive = isActive;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      child: Tooltip(
        message: label,
        child: GestureDetector(
          onTap: onRowTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: double.infinity,
            height: 42.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: isPillActive ? const Color(0xFF0284C7) : Colors.transparent,
            ),
            child: _buildItemIcon(isPillActive),
          ),
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
