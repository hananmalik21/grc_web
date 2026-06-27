import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';

enum SetupStepStatus { completed, inProgress, locked }

class SetupStepCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String description;
  final String timeEstimation;
  final String iconPath;
  final SetupStepStatus status;
  final List<String> dependencies;
  final VoidCallback? onActionPressed;

  const SetupStepCard({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.timeEstimation,
    required this.iconPath,
    required this.status,
    this.dependencies = const [],
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _getBorderColor(isDark),
          width: status == SetupStepStatus.inProgress ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.r),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepIndicator(isDark),
                Gap(16.w),
                Container(
                  width: 42.w,
                  height: 42.w,
                  decoration: BoxDecoration(
                    color: status != SetupStepStatus.locked
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : isDark
                        ? AppColors.grayBgDark
                        : AppColors.grayBg,
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  alignment: Alignment.center,
                  child: DigifyAsset(
                    assetPath: iconPath,
                    color: status != SetupStepStatus.locked
                        ? AppColors.primary
                        : isDark
                        ? AppColors.textMutedDark
                        : AppColors.textMuted,
                    width: 21,
                    height: 21,
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: context.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.textPrimaryDark
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          _buildStatusBadge(),
                        ],
                      ),
                      Gap(4.h),
                      Text(
                        description,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: isDark
                              ? AppColors.textTertiaryDark
                              : AppColors.textTertiary,
                        ),
                      ),
                      if (dependencies.isNotEmpty) ...[
                        Gap(12.h),
                        Text(
                          'Dependencies:',
                          style: context.textTheme.labelSmall?.copyWith(
                            color: isDark
                                ? AppColors.textMutedDark
                                : AppColors.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gap(4.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: dependencies
                              .map((dep) => _buildDependencyChip(dep, isDark))
                              .toList(),
                        ),
                      ],
                      Gap(16.h),
                      _buildActionButton(context, isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (status != SetupStepStatus.locked)
            Container(
              height: 20.h,
              width: 1.w,
              color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            ),
        ],
      ),
    );
  }

  Color _getBorderColor(bool isDark) {
    switch (status) {
      case SetupStepStatus.completed:
        return AppColors.successBorder;
      case SetupStepStatus.inProgress:
        return AppColors.primary;
      case SetupStepStatus.locked:
        return isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    }
  }

  Widget _buildStepIndicator(bool isDark) {
    return Column(
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: isDark ? AppColors.grayBgDark : AppColors.grayBg,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$stepNumber',
            style: TextStyle(
              color: status != SetupStepStatus.locked
                  ? isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary
                  : isDark
                  ? AppColors.textMutedDark
                  : AppColors.textMuted,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (status == SetupStepStatus.inProgress) ...[
          Container(
            width: 16.r,
            height: 16.r,
            margin: EdgeInsets.only(top: 4.h),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ] else if (status == SetupStepStatus.completed) ...[
          Container(
            margin: EdgeInsets.only(top: 4.h),
            child: Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.success,
              size: 16.r,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusBadge() {
    String text;
    Color bgColor;
    Color textColor;

    switch (status) {
      case SetupStepStatus.completed:
        text = 'Completed';
        bgColor = AppColors.success;
        textColor = Colors.white;
        break;
      case SetupStepStatus.inProgress:
        text = 'In Progress';
        bgColor = AppColors.primary;
        textColor = Colors.white;
        break;
      case SetupStepStatus.locked:
        text = 'Locked';
        bgColor = AppColors.pendingStatusBackground;
        textColor = AppColors.pendingStatucColor;
        break;
    }

    return Row(
      children: [
        Text(
          timeEstimation,
          style: TextStyle(fontSize: 10.sp, color: AppColors.textTertiary),
        ),
        Gap(8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDependencyChip(String text, bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: status != SetupStepStatus.locked
            ? AppColors.successBg
            : isDark
            ? AppColors.grayBgDark
            : AppColors.grayBg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: status != SetupStepStatus.locked
              ? AppColors.successText
              : isDark
              ? AppColors.textMutedDark
              : AppColors.textMuted,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, bool isDark) {
    String text;
    bool isFilled = false;
    bool isOutlined = false;
    bool isDisabled = false;

    switch (status) {
      case SetupStepStatus.completed:
        text = 'Review Configuration';
        isOutlined = true;
        break;
      case SetupStepStatus.inProgress:
        text = 'Continue Setup';
        isFilled = true;
        break;
      case SetupStepStatus.locked:
        text = 'Complete dependencies first';
        isDisabled = true;
        break;
    }

    if (isDisabled) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.cardBackgroundGreyDark
              : AppColors.cardBackgroundGrey,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isDark ? AppColors.textMutedDark : AppColors.textMuted,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return InkWell(
      onTap: onActionPressed,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isFilled ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r),
          border: isOutlined
              ? Border.all(
                  color: isDark
                      ? AppColors.borderGreyDark
                      : AppColors.borderGrey,
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isFilled
                    ? Colors.white
                    : (isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimary),
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(8.w),
            Icon(
              Icons.arrow_forward,
              size: 14.r,
              color: isFilled
                  ? Colors.white
                  : (isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
