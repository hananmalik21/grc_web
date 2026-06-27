import 'dart:async';

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DigifyPopupMenuAction {
  const DigifyPopupMenuAction({
    required this.value,
    required this.label,
    required this.icon,
    this.onSelected,
    this.isDestructive = false,
  });

  final String value;
  final String label;
  final Widget icon;
  final FutureOr<void> Function()? onSelected;
  final bool isDestructive;
}

class DigifyPopupMenuButton extends StatelessWidget {
  const DigifyPopupMenuButton({
    super.key,
    required this.child,
    required this.actions,
    this.offset = const Offset(0, 44),
    this.elevation = 20,
    this.constraints,
    this.borderRadius,
    this.menuPadding = EdgeInsets.zero,
    this.itemHeight = 48,
    this.itemHorizontalPadding = 12,
    this.iconBoxSize = 30,
    this.menuColor,
    this.menuBorderColor,
    this.menuTextColor,
    this.destructiveTextColor,
    this.iconBackgroundColor,
    this.iconBackgroundColorDark,
    this.shadowColor,
  });

  final Widget child;
  final List<DigifyPopupMenuAction> actions;
  final Offset offset;
  final double elevation;
  final BoxConstraints? constraints;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry menuPadding;
  final double itemHeight;
  final double itemHorizontalPadding;
  final double iconBoxSize;
  final Color? menuColor;
  final Color? menuBorderColor;
  final Color? menuTextColor;
  final Color? destructiveTextColor;
  final Color? iconBackgroundColor;
  final Color? iconBackgroundColorDark;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveMenuColor = menuColor ?? (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);
    final effectiveBorderColor = menuBorderColor ?? (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);
    final effectiveTextColor = menuTextColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textDarkSlate);
    final effectiveDestructiveTextColor = destructiveTextColor ?? AppColors.error;
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(14.r);
    final effectiveIconBackgroundColor = iconBackgroundColor ?? AppColors.cardBackgroundGrey;
    final effectiveIconBackgroundColorDark = iconBackgroundColorDark ?? AppColors.cardBackgroundGreyDark;

    return Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          color: effectiveMenuColor,
          surfaceTintColor: effectiveMenuColor,
          menuPadding: menuPadding,
          textStyle: context.textTheme.bodyMedium?.copyWith(color: effectiveTextColor),
          shape: RoundedRectangleBorder(
            borderRadius: effectiveBorderRadius,
            side: BorderSide(color: effectiveBorderColor, width: 1),
          ),
        ),
      ),
      child: PopupMenuButton<String>(
        tooltip: '',
        offset: offset,
        elevation: elevation,
        clipBehavior: Clip.antiAlias,
        shadowColor: shadowColor ?? Colors.black.withValues(alpha: 0.12),
        constraints: constraints,
        shape: RoundedRectangleBorder(borderRadius: effectiveBorderRadius),
        onSelected: (value) async {
          for (final action in actions) {
            if (action.value == value && action.onSelected != null) {
              await action.onSelected!.call();
              break;
            }
          }
        },
        itemBuilder: (context) => [
          for (final action in actions)
            PopupMenuItem<String>(
              value: action.value,
              height: itemHeight.h,
              padding: EdgeInsets.symmetric(horizontal: itemHorizontalPadding.w),
              child: Row(
                children: [
                  Container(
                    width: iconBoxSize.r,
                    height: iconBoxSize.r,
                    decoration: BoxDecoration(
                      color: isDark ? effectiveIconBackgroundColorDark : effectiveIconBackgroundColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: Alignment.center,
                    child: action.icon,
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Text(
                      action.label,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: action.isDestructive ? effectiveDestructiveTextColor : effectiveTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
        child: child,
      ),
    );
  }
}
