import 'dart:ui';

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Configuration for a single step in the stepper
class StepperStepConfig {
  final String assetPath;
  final String label;

  const StepperStepConfig({required this.assetPath, required this.label});
}

/// A reusable dialog widget with optional stepper support, gradient header, and footer buttons
class AppStepperDialog extends StatelessWidget {
  /// Title displayed in the header
  final String title;

  /// Subtitle displayed below the title
  final String? subtitle;

  /// Main content widget
  final Widget content;

  /// Optional stepper configuration
  final List<StepperStepConfig>? stepperSteps;

  /// Current active step index (0-based). Only used if stepperSteps is provided
  final int? currentStepIndex;

  /// Footer actions/widgets (right side)
  final List<Widget>? footerActions;

  /// Footer actions/widgets (left side)
  final List<Widget>? footerLeftActions;

  /// Callback when close button is tapped
  final VoidCallback? onClose;

  /// Maximum width of the dialog
  final double? maxWidth;

  /// Maximum height of the dialog (as percentage of screen height, 0.0 to 1.0)
  final double? maxHeight;

  /// Content padding
  final EdgeInsets? contentPadding;

  /// Whether the dialog can be dismissed by tapping outside
  final bool barrierDismissible;

  /// Whether to show a loading overlay over the dialog content
  final bool isLoading;

  const AppStepperDialog({
    super.key,
    required this.title,
    this.subtitle,
    required this.content,
    this.stepperSteps,
    this.currentStepIndex,
    this.footerActions,
    this.footerLeftActions,
    this.onClose,
    this.maxWidth,
    this.maxHeight,
    this.contentPadding,
    this.barrierDismissible = false,
    this.isLoading = false,
  });

  /// Static method to show the dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required Widget content,
    List<StepperStepConfig>? stepperSteps,
    int? currentStepIndex,
    List<Widget>? footerActions,
    List<Widget>? footerLeftActions,
    VoidCallback? onClose,
    double? maxWidth,
    double? maxHeight,
    EdgeInsets? contentPadding,
    bool barrierDismissible = false,
    bool isLoading = false,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => AppStepperDialog(
        title: title,
        subtitle: subtitle,
        content: content,
        stepperSteps: stepperSteps,
        currentStepIndex: currentStepIndex,
        footerActions: footerActions,
        footerLeftActions: footerLeftActions,
        onClose: onClose,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        contentPadding: contentPadding,
        barrierDismissible: barrierDismissible,
        isLoading: isLoading,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final effectiveMaxHeight = maxHeight != null
        ? MediaQuery.of(context).size.height * maxHeight!
        : MediaQuery.of(context).size.height * 0.9;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth ?? 900.w, maxHeight: effectiveMaxHeight),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: AppShadows.primaryShadow,
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildHeader(context, isDark),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: contentPadding ?? EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
                      child: content,
                    ),
                  ),
                  if (footerActions != null || footerLeftActions != null) _buildFooter(context, isDark),
                ],
              ),
              if (isLoading) _buildLoadingOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final hasStepper = stepperSteps != null && stepperSteps!.isNotEmpty;
    final effectiveStepIndex = currentStepIndex ?? 0;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
      ),
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.textTheme.titleLarge?.copyWith(
                        color: AppColors.buttonTextLight,
                        fontSize: 22.9.sp,
                      ),
                    ),
                    if (subtitle != null) ...[
                      Gap(4.h),
                      Text(subtitle!, style: context.textTheme.bodyMedium?.copyWith(color: AppColors.jobRoleBg)),
                    ],
                  ],
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onClose ?? () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(100.r),
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: DigifyAsset(
                      assetPath: Assets.icons.closeIcon.path,
                      width: 24,
                      height: 24,
                      color: AppColors.buttonTextLight,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (hasStepper) ...[Gap(24.h), _buildStepper(context, effectiveStepIndex)],
        ],
      ),
    );
  }

  Widget _buildStepper(BuildContext context, int currentStepIndex) {
    if (stepperSteps == null || stepperSteps!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        for (int i = 0; i < stepperSteps!.length; i++) ...[
          Expanded(
            child: _buildStepItem(
              context: context,
              assetPath: stepperSteps![i].assetPath,
              label: stepperSteps![i].label,
              stepNumber: i + 1,
              isActive: currentStepIndex == i,
              isCompleted: currentStepIndex > i,
            ),
          ),
          if (i < stepperSteps!.length - 1)
            Expanded(
              child: Container(
                height: 2.h,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  color: currentStepIndex > i
                      ? AppColors.buttonTextLight
                      : AppColors.buttonTextLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1.r),
                ),
              ),
            ),
        ],
      ],
    );
  }

  Widget _buildStepItem({
    required BuildContext context,
    required String assetPath,
    required String label,
    required int stepNumber,
    required bool isActive,
    required bool isCompleted,
  }) {
    final textColor = isActive || isCompleted
        ? AppColors.buttonTextLight
        : AppColors.buttonTextLight.withValues(alpha: 0.5);
    final iconColor = isActive || isCompleted ? AppColors.primary : AppColors.buttonTextLight.withValues(alpha: 0.5);
    final borderColor = isActive || isCompleted
        ? AppColors.buttonTextLight
        : AppColors.buttonTextLight.withValues(alpha: 0.5);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40.w,
          height: 40.h,
          decoration: BoxDecoration(
            color: isActive || isCompleted ? AppColors.buttonTextLight : Colors.transparent,
            border: Border.all(color: borderColor, width: 1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: DigifyAsset(assetPath: assetPath, width: 20, height: 20, color: iconColor),
          ),
        ),
        Gap(12.w),
        Flexible(
          child: Text(
            label,
            style: context.textTheme.titleSmall?.copyWith(color: textColor),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 25.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.r), bottomRight: Radius.circular(16.r)),
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (footerLeftActions != null) Row(children: footerLeftActions!),
          if (footerActions != null) Row(children: footerActions!),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blackTextColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: const Center(child: AppLoadingIndicator(type: LoadingType.circle)),
      ),
    );
  }
}
