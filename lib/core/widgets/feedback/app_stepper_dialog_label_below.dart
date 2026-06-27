import 'dart:ui';

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/feedback/app_stepper_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AppStepperDialogLabelBelow extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget content;
  final List<StepperStepConfig>? stepperSteps;
  final int? currentStepIndex;
  final List<Widget>? footerActions;
  final List<Widget>? footerLeftActions;
  final VoidCallback? onClose;
  final double? maxWidth;
  final double? maxHeight;
  final EdgeInsets? contentPadding;
  final EdgeInsets? stepperPadding;
  final bool barrierDismissible;
  final bool isLoading;

  const AppStepperDialogLabelBelow({
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
    this.stepperPadding,
    this.barrierDismissible = false,
    this.isLoading = false,
  });

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
          constraints: BoxConstraints(maxWidth: maxWidth ?? 700.w, maxHeight: effectiveMaxHeight),
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
                  if (stepperSteps != null && stepperSteps!.isNotEmpty) _buildStepperSection(context, isDark),
                  Expanded(
                    child: Container(
                      color: isDark ? AppColors.cardBackgroundDark : AppColors.securityProfilesBackground,
                      child: SingleChildScrollView(
                        padding: contentPadding ?? EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
                        child: content,
                      ),
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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          colors: [AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleLarge?.copyWith(color: AppColors.buttonTextLight, fontSize: 20.sp),
                ),
                if (subtitle != null) ...[
                  Gap(2.h),
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
                padding: EdgeInsets.all(6.w),
                child: DigifyAsset(
                  assetPath: Assets.icons.closeIcon.path,
                  width: 22,
                  height: 22,
                  color: AppColors.buttonTextLight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Stepper in its own section below the blue header (white/card background).
  Widget _buildStepperSection(BuildContext context, bool isDark) {
    final effectiveStepIndex = currentStepIndex ?? 0;
    final bgColor = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final effectiveStepperPadding = stepperPadding ?? EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h);
    return Container(
      width: double.infinity,
      padding: effectiveStepperPadding,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: _buildStepper(context, effectiveStepIndex, isDark),
    );
  }

  Widget _buildStepper(BuildContext context, int currentStepIndex, bool isDark) {
    if (stepperSteps == null || stepperSteps!.isEmpty) {
      return const SizedBox.shrink();
    }

    final connectorInactiveColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final connectorActiveColor = AppColors.primary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < stepperSteps!.length; i++) ...[
          Expanded(
            flex: 2,
            child: _buildStepItem(
              context: context,
              assetPath: stepperSteps![i].assetPath,
              label: stepperSteps![i].label,
              stepNumber: i + 1,
              isActive: currentStepIndex == i,
              isCompleted: currentStepIndex > i,
              isDark: isDark,
            ),
          ),
          if (i < stepperSteps!.length - 1)
            Expanded(
              flex: 1,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Gap(4.h),
                  Container(
                    height: 32.h,
                    alignment: Alignment.bottomCenter,
                    child: DigifyDivider.horizontal(
                      thickness: 3.h,
                      margin: EdgeInsets.symmetric(horizontal: 2.w),
                      color: currentStepIndex > i ? connectorActiveColor : connectorInactiveColor,
                      borderRadius: 2.r,
                    ),
                  ),
                ],
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
    required bool isDark,
  }) {
    final isHighlighted = isActive || isCompleted;
    final textColor = isHighlighted
        ? AppColors.primary
        : (isDark ? AppColors.textSecondaryDark : AppColors.dialogCloseIcon);
    final iconColor = isHighlighted
        ? AppColors.buttonTextLight
        : (isDark ? AppColors.textSecondaryDark : AppColors.dialogCloseIcon);
    final circleFill = isHighlighted ? AppColors.primary : AppColors.dashboardCardBorder;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Gap(4.h),
        Container(
          width: 32.w,
          height: 32.h,
          decoration: BoxDecoration(color: circleFill, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: DigifyAsset(assetPath: assetPath, width: 16.w, height: 16.h, color: iconColor),
        ),
        Gap(4.h),
        Align(
          alignment: Alignment.topCenter,
          child: Text(
            label,
            style: context.textTheme.titleSmall?.copyWith(color: textColor, fontSize: 12.sp),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16.r), bottomRight: Radius.circular(16.r)),
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Row(
        children: [
          if (footerLeftActions != null) Row(children: footerLeftActions!),
          const Spacer(),
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
