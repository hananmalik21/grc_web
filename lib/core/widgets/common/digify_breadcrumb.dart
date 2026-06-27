import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DigifyBreadcrumbItem {
  final String label;
  final VoidCallback? onTap;
  final String? iconPath;

  const DigifyBreadcrumbItem({required this.label, this.onTap, this.iconPath});
}

class DigifyBreadcrumbTrailingAction {
  final String iconPath;
  final String? label;
  final VoidCallback? onTap;
  final Color? color;

  const DigifyBreadcrumbTrailingAction._({required this.iconPath, this.label, this.onTap, this.color});

  const DigifyBreadcrumbTrailingAction.icon({required String iconPath, VoidCallback? onTap, Color? color})
    : this._(iconPath: iconPath, onTap: onTap, color: color);

  const DigifyBreadcrumbTrailingAction.iconLabel({
    required String iconPath,
    required String label,
    VoidCallback? onTap,
    Color? color,
  }) : this._(iconPath: iconPath, label: label, onTap: onTap, color: color);

  bool get hasLabel => label != null && label!.trim().isNotEmpty;
}

class DigifyBreadcrumb extends StatelessWidget {
  final List<DigifyBreadcrumbItem> items;
  final List<DigifyBreadcrumbTrailingAction> trailingActions;
  final String? separatorIconPath;
  final bool enableTaps;

  const DigifyBreadcrumb({
    super.key,
    required this.items,
    this.trailingActions = const [],
    this.separatorIconPath,
    this.enableTaps = true,
  });

  static const _outerRadius = 10.0;
  static const _actionRadius = 10.0;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final isDark = context.isDark;
    final effectiveSeparatorIconPath = separatorIconPath ?? Assets.icons.workforce.chevronRight.path;

    return Container(
      padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 8.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        borderRadius: BorderRadius.circular(_outerRadius.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: _buildBreadcrumbItems(context, effectiveSeparatorIconPath),
              ),
            ),
          ),
          if (trailingActions.isNotEmpty) ...[
            Gap(8.w),
            Row(mainAxisSize: MainAxisSize.min, children: _buildTrailingActions(context)),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildBreadcrumbItems(BuildContext context, String separatorPath) {
    final isDark = context.isDark;
    final separatorColor = isDark ? AppColors.textSecondaryDark : AppColors.borderGrey;
    final widgets = <Widget>[];

    for (var index = 0; index < items.length; index++) {
      final item = items[index];
      final isActive = index == items.length - 1;

      if (index > 0) {
        widgets
          ..add(Gap(8.w))
          ..add(DigifyAsset(assetPath: separatorPath, width: 12.w, height: 12.h, color: separatorColor))
          ..add(Gap(8.w));
      }

      widgets.add(_BreadcrumbButton(item: item, isActive: isActive, enableTap: enableTaps));
    }

    return widgets;
  }

  List<Widget> _buildTrailingActions(BuildContext context) {
    final widgets = <Widget>[];

    for (var index = 0; index < trailingActions.length; index++) {
      final action = trailingActions[index];
      if (index > 0) widgets.add(Gap(8.w));
      widgets.add(_BreadcrumbTrailingAction(action: action));
    }

    return widgets;
  }
}

class _BreadcrumbButton extends StatelessWidget {
  const _BreadcrumbButton({required this.item, required this.isActive, required this.enableTap});

  final DigifyBreadcrumbItem item;
  final bool isActive;
  final bool enableTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final activeBg = isDark ? AppColors.primary.withValues(alpha: 0.2) : AppColors.infoBg.withValues(alpha: 0.8);
    final activeBorder = isDark
        ? AppColors.primary.withValues(alpha: 0.1)
        : AppColors.infoBorder.withValues(alpha: 0.5);
    final activeText = isDark ? AppColors.onPrimary : AppColors.sidebarActiveText;
    final inactiveText = isDark ? AppColors.textSecondaryDark : AppColors.sidebarCategoryText;

    final iconColor = isActive ? activeText : inactiveText;

    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.iconPath != null) ...[
          DigifyAsset(assetPath: item.iconPath!, width: 12.w, height: 12.h, color: iconColor),
          Gap(8.w),
        ],
        Text(
          item.label,
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 10.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
            height: 1.5,
            color: iconColor,
          ),
        ),
      ],
    );

    if (!isActive) {
      if (!enableTap || item.onTap == null) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          child: child,
        );
      }

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: item.onTap,
          borderRadius: BorderRadius.circular(DigifyBreadcrumb._actionRadius.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            child: child,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: activeBg,
        border: Border.all(color: activeBorder),
        borderRadius: BorderRadius.circular(DigifyBreadcrumb._actionRadius.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: child,
    );
  }
}

class _BreadcrumbTrailingAction extends StatelessWidget {
  const _BreadcrumbTrailingAction({required this.action});

  final DigifyBreadcrumbTrailingAction action;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final defaultMuted = isDark ? AppColors.textSecondaryDark : AppColors.borderGrey;
    final iconColor = action.color ?? defaultMuted;

    if (!action.hasLabel) {
      final bg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
      final border = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: action.onTap,
          borderRadius: BorderRadius.circular(DigifyBreadcrumb._actionRadius.r),
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(DigifyBreadcrumb._actionRadius.r),
            ),
            padding: EdgeInsets.all(8.w),
            child: DigifyAsset(assetPath: action.iconPath, width: 14.w, height: 14.h, color: iconColor),
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(DigifyBreadcrumb._actionRadius.r),
        child: Padding(
          padding: EdgeInsets.all(6.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(assetPath: action.iconPath, width: 12.w, height: 12.h, color: iconColor),
              Gap(8.w),
              Text(
                action.label!.toUpperCase(),
                style: context.textTheme.labelSmall?.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  height: 1.5,
                  color: iconColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
