import 'dart:ui';

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

enum DigifyBottomSheetType { picker, form, confirmation, custom }

class DigifyBottomSheet {
  DigifyBottomSheet._();

  static Future<T?> show<T>(
    BuildContext context, {
    required DigifyBottomSheetType type,
    String? title,
    required Widget child,
    double? maxHeight,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (ctx, _, _) =>
          _DigifyBottomSheetShell(type: type, title: title, maxHeight: maxHeight, child: child),
      transitionBuilder: (ctx, animation, _, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return Stack(
          children: [
            FadeTransition(
              opacity: curved,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: animation.value * 8, sigmaY: animation.value * 8),
                child: ColoredBox(color: Colors.black.withValues(alpha: 0.3 * animation.value)),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(curved),
                child: child,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DigifyBottomSheetShell extends StatelessWidget {
  final DigifyBottomSheetType type;
  final String? title;
  final Widget child;
  final double? maxHeight;

  const _DigifyBottomSheetShell({required this.type, required this.title, required this.child, this.maxHeight});

  double _maxHeight(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenH = mq.size.height;
    final availableH = screenH - mq.padding.top - mq.padding.bottom;

    final computed = switch (type) {
      DigifyBottomSheetType.picker => availableH * 0.72,
      DigifyBottomSheetType.form => availableH * 0.85,
      DigifyBottomSheetType.confirmation => availableH * 0.60,
      DigifyBottomSheetType.custom => availableH * 0.90,
    };

    return maxHeight ?? computed;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final bgColor = isDark ? AppColors.cardBackgroundDark : Colors.white;
    final mq = MediaQuery.of(context);
    final safeBottom = mq.padding.bottom;
    final cornerRadius = 24.r;

    final floatMargin = 12.w;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(floatMargin, 0, floatMargin, safeBottom + floatMargin),
      child: Container(
        constraints: BoxConstraints(maxHeight: _maxHeight(context)),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(cornerRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.18),
              blurRadius: 48,
              spreadRadius: -4,
              offset: const Offset(0, 16),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
              blurRadius: 16,
              spreadRadius: -2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(cornerRadius),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(cornerRadius),
            child: Column(
              children: [
                if (title != null) ...[_SheetHeader(title: title!, isDark: isDark)] else Gap(8.h),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SheetHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 16.h, 20.w, 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: context.textTheme.titleSmall?.copyWith(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                letterSpacing: -0.2,
              ),
            ),
          ),
          _SheetCloseButton(isDark: isDark),
        ],
      ),
    );
  }
}

class _SheetCloseButton extends StatelessWidget {
  final bool isDark;

  const _SheetCloseButton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        width: 30.r,
        height: 30.r,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.5) : AppColors.cardBackgroundGrey,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.close_rounded,
          size: 15.sp,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
    );
  }
}

///
class DigifyPickerSheetContent<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? emptyState;

  const DigifyPickerSheetContent({super.key, required this.items, required this.itemBuilder, this.emptyState});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    if (items.isEmpty) {
      return emptyState ??
          Center(
            child: Padding(
              padding: EdgeInsetsDirectional.all(32.w),
              child: Text(
                'No items available',
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ),
          );
    }

    return ListView.separated(
      padding: EdgeInsetsDirectional.only(bottom: 8.h),
      itemCount: items.length,
      separatorBuilder: (_, _) => const DigifyDivider.thin(),
      itemBuilder: (ctx, i) => itemBuilder(ctx, items[i], i),
    );
  }
}

///
class DigifyPickerItem extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const DigifyPickerItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.primary.withValues(alpha: 0.06),
        highlightColor: AppColors.primary.withValues(alpha: 0.04),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        color: isSelected ? AppColors.primary : labelColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      Gap(2.h),
                      Text(subtitle!, style: context.textTheme.labelSmall?.copyWith(color: subtitleColor)),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Container(
                  width: 20.r,
                  height: 20.r,
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Icon(Icons.check_rounded, size: 12, color: AppColors.primary),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

///
class DigifyConfirmationSheetContent extends StatelessWidget {
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;
  final VoidCallback onConfirm;

  const DigifyConfirmationSheetContent({
    super.key,
    required this.message,
    required this.confirmLabel,
    required this.onConfirm,
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final messageColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final confirmColor = isDestructive ? AppColors.brandRed : AppColors.primary;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 8.h, 20.w, 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(message, style: context.textTheme.bodyMedium?.copyWith(color: messageColor, height: 1.6)),
          Gap(20.h),
          _SheetActionButton(
            label: confirmLabel,
            color: confirmColor,
            onTap: () {
              Navigator.pop(context);
              onConfirm();
            },
          ),
          Gap(8.h),
          _SheetCancelButton(label: cancelLabel, isDark: isDark, onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

class _SheetActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SheetActionButton({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        splashColor: Colors.white.withValues(alpha: 0.15),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(vertical: 14.h),
          child: Center(
            child: Text(
              label,
              style: context.textTheme.labelLarge?.copyWith(
                color: AppColors.onPrimary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SheetCancelButton extends StatelessWidget {
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _SheetCancelButton({required this.label, required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.cardBackgroundGrey,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(vertical: 14.h),
          child: Center(
            child: Text(
              label,
              style: context.textTheme.labelLarge?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DigifyStepperSheetContent extends StatelessWidget {
  const DigifyStepperSheetContent({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabel,
    required this.body,
    required this.isDark,
    required this.canGoPrevious,
    required this.isLastStep,
    required this.isLoading,
    required this.previousLabel,
    required this.nextLabel,
    required this.saveLabel,
    required this.onPrevious,
    required this.onNext,
    required this.onSave,
    this.saveDraftLabel,
    this.onSaveDraft,
    this.isSavingDraft = false,
  });

  final int currentStep;
  final int totalSteps;
  final String stepLabel;
  final Widget body;
  final bool isDark;
  final bool canGoPrevious;
  final bool isLastStep;
  final bool isLoading;
  final String previousLabel;
  final String nextLabel;
  final String saveLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSave;
  final String? saveDraftLabel;
  final VoidCallback? onSaveDraft;
  final bool isSavingDraft;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StepProgressBar(currentStep: currentStep, totalSteps: totalSteps, stepLabel: stepLabel, isDark: isDark),
        Expanded(
          child: SingleChildScrollView(padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 8.h), child: body),
        ),
        _StepperFooter(
          canGoPrevious: canGoPrevious,
          isLastStep: isLastStep,
          isLoading: isLoading,
          previousLabel: previousLabel,
          nextLabel: nextLabel,
          saveLabel: saveLabel,
          onPrevious: onPrevious,
          onNext: onNext,
          onSave: onSave,
          saveDraftLabel: saveDraftLabel,
          onSaveDraft: onSaveDraft,
          isSavingDraft: isSavingDraft,
        ),
      ],
    );
  }
}

class _StepProgressBar extends StatelessWidget {
  const _StepProgressBar({
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabel,
    required this.isDark,
  });

  final int currentStep;
  final int totalSteps;
  final String stepLabel;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / totalSteps;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final trackColor = isDark ? AppColors.cardBorderDark.withValues(alpha: 0.6) : AppColors.cardBorder;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 12.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                stepLabel,
                style: context.textTheme.labelMedium?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Text(
                '${currentStep + 1} / $totalSteps',
                style: context.textTheme.labelSmall?.copyWith(
                  fontSize: 11.sp,
                  color: labelColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Gap(6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4.h,
              backgroundColor: trackColor,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          Gap(4.h),
          _StepDots(currentStep: currentStep, totalSteps: totalSteps, isDark: isDark),
        ],
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.currentStep, required this.totalSteps, required this.isDark});

  final int currentStep;
  final int totalSteps;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (i) {
        final isActive = i == currentStep;
        final isCompleted = i < currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: isActive ? 16.w : 6.w,
          height: 6.h,
          margin: EdgeInsetsDirectional.only(end: 4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.r),
            color: isActive
                ? AppColors.primary
                : isCompleted
                ? AppColors.primary.withValues(alpha: 0.35)
                : isDark
                ? AppColors.cardBorderDark
                : AppColors.cardBorder,
          ),
        );
      }),
    );
  }
}

class _StepperFooter extends StatelessWidget {
  const _StepperFooter({
    required this.canGoPrevious,
    required this.isLastStep,
    required this.isLoading,
    required this.previousLabel,
    required this.nextLabel,
    required this.saveLabel,
    required this.onPrevious,
    required this.onNext,
    required this.onSave,
    this.saveDraftLabel,
    this.onSaveDraft,
    this.isSavingDraft = false,
  });

  final bool canGoPrevious;
  final bool isLastStep;
  final bool isLoading;
  final String previousLabel;
  final String nextLabel;
  final String saveLabel;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSave;
  final String? saveDraftLabel;
  final VoidCallback? onSaveDraft;
  final bool isSavingDraft;

  static const double _buttonHeight = 46;

  @override
  Widget build(BuildContext context) {
    final busy = isLoading || isSavingDraft;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (saveDraftLabel != null) ...[
                AppButton.outline(
                  label: saveDraftLabel!,
                  isLoading: isSavingDraft,
                  onPressed: busy ? null : onSaveDraft,
                  height: _buttonHeight,
                ),
                Gap(10.h),
              ],
              Row(
                children: [
                  if (canGoPrevious) ...[
                    AppButton.outline(label: previousLabel, onPressed: onPrevious, height: _buttonHeight),
                    Gap(10.w),
                  ],
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: isLastStep
                          ? AppButton.primary(
                              label: saveLabel,
                              isLoading: isLoading,
                              onPressed: busy ? null : onSave,
                              height: _buttonHeight,
                            )
                          : AppButton.primary(label: nextLabel, onPressed: busy ? null : onNext, height: _buttonHeight),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
