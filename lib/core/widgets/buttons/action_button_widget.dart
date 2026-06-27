import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

enum ActionButtonType { view, edit, delete }

class ActionButtonWidget extends StatelessWidget {
  final ActionButtonType? type;
  final String? icon;
  final Color? color;
  final Color? iconColor;
  final Color? textColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final String? label;
  final bool isLoading;
  final String? tooltip;
  final double? width;
  final double? height;
  final double? padding;
  final BorderRadius? borderRadius;
  final ShapeBorder? customBorder;

  const ActionButtonWidget({
    super.key,
    this.type,
    this.icon,
    this.color,
    this.iconColor,
    this.textColor,
    this.backgroundColor,
    this.onTap,
    this.label,
    this.isLoading = false,
    this.tooltip,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.customBorder,
  }) : assert(type != null || icon != null, 'Pass either type or icon.');

  (String, Color?, String?) _resolveConfig() {
    if (type == null) {
      return (icon!, color, tooltip);
    }

    return switch (type!) {
      ActionButtonType.view => (Assets.icons.viewIconBlue.path, AppColors.viewIconBlue, tooltip ?? 'View'),
      ActionButtonType.edit => (Assets.icons.editIconGreen.path, AppColors.editIconGreen, tooltip ?? 'Edit'),
      ActionButtonType.delete => (Assets.icons.deleteIconRed.path, AppColors.deleteIconRed, tooltip ?? 'Delete'),
    };
  }

  @override
  Widget build(BuildContext context) {
    final (resolvedIcon, resolvedColor, resolvedTooltip) = _resolveConfig();
    final effectiveIconColor = iconColor ?? resolvedColor;
    final hasLabel = label != null && label!.isNotEmpty;
    final button = DigifyAssetButton(
      assetPath: resolvedIcon,
      onTap: isLoading ? null : onTap,
      isLoading: isLoading,
      width: width ?? 16.w,
      height: height ?? 16.w,
      color: effectiveIconColor,
      padding: padding,
      borderRadius: borderRadius,
      customBorder: customBorder ?? const CircleBorder(),
    );
    final decoratedButton = backgroundColor == null
        ? button
        : Container(
            decoration: BoxDecoration(color: backgroundColor, borderRadius: borderRadius ?? BorderRadius.circular(8.r)),
            child: button,
          );

    final wrappedButton = resolvedTooltip == null
        ? decoratedButton
        : Tooltip(message: resolvedTooltip, child: decoratedButton);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        wrappedButton,
        if (hasLabel) ...[
          Gap(8.w),
          Flexible(
            child: Text(
              label!,
              style: context.textTheme.bodyLarge?.copyWith(color: textColor ?? effectiveIconColor),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}
