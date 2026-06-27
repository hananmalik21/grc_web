import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/enterprise_structure_enums.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_unit_tree.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MobileOrgUnitTreeNodeWidget extends StatelessWidget {
  final OrgUnitTreeNode node;
  final Set<String> expandedNodes;
  final ValueChanged<String> onToggle;
  final bool isDark;
  final int level;

  const MobileOrgUnitTreeNodeWidget({
    super.key,
    required this.node,
    required this.expandedNodes,
    required this.onToggle,
    required this.isDark,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final textTheme = context.textTheme;
    final isExpanded = expandedNodes.contains(node.orgUnitId);
    final hasChildren = node.children.isNotEmpty;
    final orgLevel = node.level;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: hasChildren ? () => onToggle(node.orgUnitId) : null,
          borderRadius: BorderRadius.circular(6.r),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 6.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: hasChildren
                          ? AnimatedRotation(
                              turns: isExpanded ? 0.25 : 0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                size: 16.sp,
                                color: isDark
                                    ? AppColors.textSecondaryDark
                                    : AppColors.textSecondary,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const Gap(6),
                    _OrgIconContainer(isDark: isDark, size: 28.w, level: orgLevel),
                    const Gap(8),
                    Expanded(
                      child: Text(
                        node.displayName,
                        style: textTheme.titleSmall?.copyWith(
                          fontSize: 13.sp,
                          color: isDark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 20.w + 6.w + 28.w + 8.w),
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (node.orgUnitNameAr.isNotEmpty)
                        Text(
                          '(${node.orgUnitNameAr})',
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 11.sp,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.sidebarSecondaryText,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      DigifySquareCapsule(label: node.orgUnitCode),
                      DigifySquareCapsule(
                        label: node.isActive
                            ? localizations.active
                            : localizations.inactive,
                        backgroundColor: node.isActive
                            ? (isDark
                                ? AppColors.successBgDark
                                : AppColors.shiftActiveStatusBg)
                            : (isDark
                                ? AppColors.grayBgDark
                                : AppColors.grayBg),
                        textColor: node.isActive
                            ? (isDark
                                ? AppColors.successTextDark
                                : AppColors.activeStatusTextLight)
                            : (isDark
                                ? AppColors.grayTextDark
                                : AppColors.grayText),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: isExpanded && hasChildren
              ? Padding(
                  padding: EdgeInsetsDirectional.only(start: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: node.children.map((child) {
                      return MobileOrgUnitTreeNodeWidget(
                        node: child,
                        expandedNodes: expandedNodes,
                        onToggle: onToggle,
                        isDark: isDark,
                        level: level + 1,
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox(width: double.infinity, height: 0),
        ),
      ],
    );
  }
}

class _OrgIconContainer extends StatelessWidget {
  final bool isDark;
  final double size;
  final OrganizationLevel level;

  const _OrgIconContainer({
    required this.isDark,
    required this.size,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.authBadgeBorder,
        borderRadius: BorderRadius.circular(4.r),
      ),
      alignment: Alignment.center,
      child: DigifyAsset(assetPath: level.iconPath, color: AppColors.primary),
    );
  }
}
