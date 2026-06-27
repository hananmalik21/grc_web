import 'dart:ui';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ConfirmationType { info, warning, danger, success }

class AppConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? itemName;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final ConfirmationType type;
  final bool isLoading;
  final IconData? icon;
  final String? svgPath;
  final bool hasTextField;
  final String? textFieldLabel;
  final TextEditingController? textController;

  const AppConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.itemName,
    required this.confirmLabel,
    this.cancelLabel = 'Cancel',
    required this.onConfirm,
    this.onCancel,
    this.type = ConfirmationType.danger,
    this.isLoading = false,
    this.icon,
    this.svgPath,
    this.hasTextField = false,
    this.textFieldLabel,
    this.textController,
  });

  factory AppConfirmationDialog.delete({
    Key? key,
    required String title,
    required String message,
    String? itemName,
    String confirmLabel = 'Delete',
    String cancelLabel = 'Cancel',
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
    bool isLoading = false,
  }) {
    return AppConfirmationDialog(
      key: key,
      title: title,
      message: message,
      itemName: itemName,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      onConfirm: onConfirm,
      onCancel: onCancel,
      type: ConfirmationType.danger,
      isLoading: isLoading,
      svgPath: Assets.icons.deleteIconRed.path,
    );
  }

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String? itemName,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    ConfirmationType type = ConfirmationType.danger,
    IconData? icon,
    String? svgPath,
  }) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) => AppConfirmationDialog(
        title: title,
        message: message,
        itemName: itemName,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
        type: type,
        icon: icon,
        svgPath: svgPath,
      ),
    );
  }

  static Future<String?> showWithInput(
    BuildContext context, {
    required String title,
    required String message,
    String? itemName,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    ConfirmationType type = ConfirmationType.danger,
    IconData? icon,
    String? svgPath,
    required String textFieldLabel,
    String? initialValue,
    String? Function(String?)? validator,
  }) {
    final controller = TextEditingController(text: initialValue);

    return showDialog<String>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => AppConfirmationDialog(
        title: title,
        message: message,
        itemName: itemName,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: () {
          final text = controller.text;
          final error = validator?.call(text);
          if (error != null && error.isNotEmpty) {
            ToastService.error(dialogContext, error);
            return;
          }
          Navigator.of(dialogContext).pop(text);
        },
        onCancel: () => Navigator.of(dialogContext).pop(null),
        type: type,
        isLoading: false,
        icon: icon,
        svgPath: svgPath,
        hasTextField: true,
        textFieldLabel: textFieldLabel,
        textController: controller,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final color = _getTypeColor();
    final bgColor = _getTypeBgColor(isDark);

    final isMobile = context.isMobileLayout;
    final maxWidth = context.responsive<double>(mobile: 360, tablet: 440, desktop: 480);
    final horizontalPadding = context.responsive<double>(mobile: 20, tablet: 28, desktop: 32);
    final iconSize = context.responsive<double>(mobile: 56, tablet: 64, desktop: 64);
    final iconInnerSize = context.responsive<double>(mobile: 28, tablet: 32, desktop: 32);
    final titleFontSize = context.responsive<double>(mobile: 18, tablet: 20, desktop: 20);
    final bodyFontSize = context.responsive<double>(mobile: 13.5, tablet: 14.5, desktop: 14.5);
    final buttonHeight = context.responsive<double>(mobile: 42, tablet: 46, desktop: 46);
    final topPadding = context.responsive<double>(mobile: 28, tablet: 32, desktop: 36);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: isMobile ? 0.9 * MediaQuery.sizeOf(context).width : maxWidth,
            constraints: BoxConstraints(maxWidth: maxWidth),
            margin: EdgeInsets.symmetric(horizontal: context.responsive<double>(mobile: 20, tablet: 40, desktop: 0)),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : Colors.white,
              borderRadius: BorderRadius.circular(isMobile ? 20.r : 16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: topPadding),
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: svgPath != null
                      ? DigifyAsset(assetPath: svgPath!, width: iconInnerSize.r, height: iconInnerSize.r, color: color)
                      : Icon(icon ?? _getDefaultIcon(), color: color, size: iconInnerSize),
                ),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: bodyFontSize,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      if (itemName != null) ...[
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white.withValues(alpha: 0.05) : AppColors.grayBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : AppColors.grayBorder.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Text(
                            itemName!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: bodyFontSize,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                      if (hasTextField && textController != null) ...[
                        SizedBox(height: 16.h),
                        DigifyTextField(
                          controller: textController!,
                          labelText: textFieldLabel ?? '',
                          maxLines: 3,
                          minLines: 2,
                        ),
                      ],
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    context.responsive<double>(mobile: 24, tablet: 28, desktop: 28),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: cancelLabel,
                          type: AppButtonType.outline,
                          height: buttonHeight,
                          onPressed: isLoading ? null : (onCancel ?? () => Navigator.of(context).pop()),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          label: confirmLabel,
                          type: type == ConfirmationType.danger ? AppButtonType.danger : AppButtonType.primary,
                          height: buttonHeight,
                          isLoading: isLoading,
                          onPressed: onConfirm,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor() {
    switch (type) {
      case ConfirmationType.danger:
        return AppColors.error;
      case ConfirmationType.warning:
        return AppColors.warning;
      case ConfirmationType.success:
        return AppColors.success;
      case ConfirmationType.info:
        return AppColors.info;
    }
  }

  Color _getTypeBgColor(bool isDark) {
    if (isDark) {
      switch (type) {
        case ConfirmationType.danger:
          return AppColors.error.withValues(alpha: 0.15);
        case ConfirmationType.warning:
          return AppColors.warning.withValues(alpha: 0.15);
        case ConfirmationType.success:
          return AppColors.success.withValues(alpha: 0.15);
        case ConfirmationType.info:
          return AppColors.info.withValues(alpha: 0.15);
      }
    } else {
      switch (type) {
        case ConfirmationType.danger:
          return AppColors.errorBg;
        case ConfirmationType.warning:
          return AppColors.warningBg;
        case ConfirmationType.success:
          return AppColors.successBg;
        case ConfirmationType.info:
          return AppColors.infoBg;
      }
    }
  }

  IconData _getDefaultIcon() {
    switch (type) {
      case ConfirmationType.danger:
        return Icons.delete_outline_rounded;
      case ConfirmationType.warning:
        return Icons.warning_amber_rounded;
      case ConfirmationType.success:
        return Icons.check_circle_outline_rounded;
      case ConfirmationType.info:
        return Icons.info_outline_rounded;
    }
  }
}
