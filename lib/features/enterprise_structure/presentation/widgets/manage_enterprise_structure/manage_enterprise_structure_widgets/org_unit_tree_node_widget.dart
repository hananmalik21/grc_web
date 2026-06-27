import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_unit_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Individual org unit tree node widget matching ComponentTreeNodeWidget design
class OrgUnitTreeNodeWidget extends StatelessWidget {
  final OrgUnitTreeNode node;
  final Map<String, bool> expandedNodes;
  final ValueChanged<String> onToggle;
  final AppLocalizations localizations;
  final bool isDark;
  final int level;

  const OrgUnitTreeNodeWidget({
    super.key,
    required this.node,
    required this.expandedNodes,
    required this.onToggle,
    required this.localizations,
    required this.isDark,
    required this.level,
  });

  String _getLevelCodeIcon(String levelCode) {
    switch (levelCode.toUpperCase()) {
      case 'COMPANY':
        return Assets.icons.companyTreeIcon.path;
      case 'DIVISION':
        return Assets.icons.divisionTreeIcon.path;
      case 'BUSINESS_UNIT':
        return Assets.icons.businessUnitTreeIcon.path;
      case 'DEPARTMENT':
        return Assets.icons.departmentTreeIcon.path;
      case 'SECTION':
        return Assets.icons.sectionTreeIcon.path;
      default:
        return Assets.icons.companyTreeIcon.path;
    }
  }

  Color _getLevelCodeIconBg(String levelCode, bool isDark) {
    switch (levelCode.toUpperCase()) {
      case 'COMPANY':
        return isDark ? AppColors.purpleBgDark : const Color(0xFFF3E8FF);
      case 'DIVISION':
        return isDark ? AppColors.infoBgDark : const Color(0xFFDBEAFE);
      case 'BUSINESS_UNIT':
        return isDark ? AppColors.successBgDark : const Color(0xFFDCFCE7);
      case 'DEPARTMENT':
        return isDark ? AppColors.warningBgDark : const Color(0xFFFFEDD4);
      case 'SECTION':
        return isDark ? AppColors.grayBgDark : const Color(0xFFF3F4F6);
      default:
        return isDark ? AppColors.grayBgDark : const Color(0xFFF3F4F6);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);
    final isExpanded = expandedNodes[node.orgUnitId] ?? false;
    final hasChildren = node.children.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Node row
        Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: isMobile ? 8.w : (isTablet ? 10.w : 12.w),
            vertical: isMobile ? 10.h : 8.h,
          ),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Expand/collapse icon
                        SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: hasChildren
                              ? GestureDetector(
                                  onTap: () => onToggle(node.orgUnitId),
                                  child: Icon(
                                    isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                                    size: 18.sp,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                                  ),
                                )
                              : SizedBox(width: 20.w),
                        ),
                        SizedBox(width: 6.w),
                        // Level type icon
                        Container(
                          width: 28.w,
                          height: 28.h,
                          decoration: BoxDecoration(
                            color: _getLevelCodeIconBg(node.levelCode, isDark),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Center(
                            child: DigifyAsset(
                              assetPath: _getLevelCodeIcon(node.levelCode),
                              width: 14,
                              height: 14,
                              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        // Org unit name
                        Expanded(
                          child: Text(
                            node.displayName,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                              height: 24 / 15.4,
                              letterSpacing: 0,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        SizedBox(width: 26.w), // Align with icon
                        Expanded(
                          child: Wrap(
                            spacing: 6.w,
                            runSpacing: 4.h,
                            children: [
                              // Arabic name in parentheses
                              if (node.orgUnitNameAr.isNotEmpty)
                                Text(
                                  '(${node.orgUnitNameAr})',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6A7282),
                                    height: 20 / 14,
                                    letterSpacing: 0,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              // Code badge
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  node.orgUnitCode,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                                    height: 16 / 12,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                              // Status badge
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: node.isActive
                                      ? (isDark ? AppColors.successBgDark : const Color(0xFFDCFCE7))
                                      : (isDark ? AppColors.grayBgDark : AppColors.grayBg),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  node.isActive ? localizations.active : localizations.inactive,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                    color: node.isActive
                                        ? (isDark ? AppColors.successTextDark : const Color(0xFF008236))
                                        : (isDark ? AppColors.grayTextDark : AppColors.grayText),
                                    height: 16 / 11.8,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    // Expand/collapse icon
                    SizedBox(
                      width: isTablet ? 22.w : 24.w,
                      height: isTablet ? 22.h : 24.h,
                      child: hasChildren
                          ? GestureDetector(
                              onTap: () => onToggle(node.orgUnitId),
                              child: Icon(
                                isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                                size: isTablet ? 18.sp : 16.sp,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                              ),
                            )
                          : SizedBox(width: isTablet ? 22.w : 24.w),
                    ),
                    SizedBox(width: isTablet ? 6.w : 8.w),
                    // Level type icon
                    Container(
                      width: isTablet ? 30.w : 32.w,
                      height: isTablet ? 30.h : 32.h,
                      decoration: BoxDecoration(
                        color: _getLevelCodeIconBg(node.levelCode, isDark),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Center(
                        child: DigifyAsset(
                          assetPath: _getLevelCodeIcon(node.levelCode),
                          width: isTablet ? 15 : 16,
                          height: isTablet ? 15 : 16,
                          color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                        ),
                      ),
                    ),
                    SizedBox(width: isTablet ? 6.w : 8.w),
                    // Org unit info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Name
                              Flexible(
                                child: Text(
                                  node.displayName,
                                  style: TextStyle(
                                    fontSize: isTablet ? 14.5.sp : 15.4.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                                    height: 24 / 15.4,
                                    letterSpacing: 0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (node.orgUnitNameAr.isNotEmpty) ...[
                                SizedBox(width: isTablet ? 6.w : 8.w),
                                // Arabic name in parentheses
                                Flexible(
                                  child: Text(
                                    '(${node.orgUnitNameAr})',
                                    style: TextStyle(
                                      fontSize: isTablet ? 13.sp : 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF6A7282),
                                      height: 20 / 14,
                                      letterSpacing: 0,
                                    ),
                                    textDirection: TextDirection.rtl,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                              SizedBox(width: isTablet ? 6.w : 8.w),
                              // Code badge
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: isTablet ? 6.w : 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.cardBackgroundGreyDark : const Color(0xFFF3F4F6),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  node.orgUnitCode,
                                  style: TextStyle(
                                    fontSize: isTablet ? 11.sp : 12.sp,
                                    fontWeight: FontWeight.w400,
                                    color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                                    height: 16 / 12,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                              SizedBox(width: isTablet ? 6.w : 8.w),
                              // Status badge
                              Container(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: isTablet ? 6.w : 8.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: node.isActive
                                      ? (isDark ? AppColors.successBgDark : const Color(0xFFDCFCE7))
                                      : (isDark ? AppColors.grayBgDark : AppColors.grayBg),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  node.isActive ? localizations.active : localizations.inactive,
                                  style: TextStyle(
                                    fontSize: isTablet ? 11.sp : 11.8.sp,
                                    fontWeight: FontWeight.w400,
                                    color: node.isActive
                                        ? (isDark ? AppColors.successTextDark : const Color(0xFF008236))
                                        : (isDark ? AppColors.grayTextDark : AppColors.grayText),
                                    height: 16 / 11.8,
                                    letterSpacing: 0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
        // Children nodes
        if (hasChildren && isExpanded)
          Padding(
            padding: EdgeInsetsDirectional.only(start: isMobile ? 20.w : (isTablet ? 22.w : 24.w)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: node.children.map((child) {
                return OrgUnitTreeNodeWidget(
                  node: child,
                  expandedNodes: expandedNodes,
                  onToggle: onToggle,
                  localizations: localizations,
                  isDark: isDark,
                  level: level + 1,
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}
