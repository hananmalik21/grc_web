import 'dart:ui';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ForfeitConfirmationDialog extends StatelessWidget {
  final double totalDays;
  final int employeeCount;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ForfeitConfirmationDialog({
    super.key,
    required this.totalDays,
    required this.employeeCount,
    required this.onConfirm,
    required this.onCancel,
  });

  static Future<bool?> show(BuildContext context, {required double totalDays, required int employeeCount}) {
    return showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      barrierDismissible: false,
      builder: (context) => ForfeitConfirmationDialog(
        totalDays: totalDays,
        employeeCount: employeeCount,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: Container(
          width: 0.85.sw,
          constraints: BoxConstraints(maxWidth: 400.w),
          margin: EdgeInsets.symmetric(horizontal: 24.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Gap(32.h),
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.errorBgDark : AppColors.lightWhiteBackground,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: DigifyAsset(
                  assetPath: Assets.icons.leaveManagement.warning.path,
                  color: AppColors.error,
                  width: 26.w,
                  height: 26.h,
                ),
              ),
              Gap(14.h),
              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  'Confirm Forfeit Processing',
                  textAlign: TextAlign.center,
                  style: context.textTheme.headlineMedium?.copyWith(
                    fontSize: 18.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
              Gap(8.h),
              // Message
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(text: 'You are about to forfeit '),
                      TextSpan(
                        text: '${totalDays.toStringAsFixed(totalDays == totalDays.toInt() ? 0 : 1)} days',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const TextSpan(text: ' of leave for '),
                      TextSpan(
                        text: '$employeeCount ${employeeCount == 1 ? 'employee' : 'employees'}',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const TextSpan(text: '. This action is '),
                      const TextSpan(
                        text: 'permanent and cannot be undone.',
                        style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(21.h),
              // Warning Box
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Container(
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: AppColors.redBg,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: AppColors.redBorder, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          DigifyAsset(
                            assetPath: Assets.icons.leaveManagement.warning.path,
                            color: AppColors.redText,
                            width: 14.w,
                            height: 14.h,
                          ),
                          Gap(3.w),
                          Text('This will:', style: context.textTheme.titleSmall?.copyWith(color: AppColors.redText)),
                        ],
                      ),
                      Gap(12.h),
                      _buildBulletPoint(context, 'Permanently reduce employee leave balances', isDark: isDark),
                      Gap(8.h),
                      _buildBulletPoint(context, 'Send notification emails to affected employees', isDark: isDark),
                      Gap(8.h),
                      _buildBulletPoint(context, 'Create an immutable audit trail', isDark: isDark),
                      Gap(8.h),
                      _buildBulletPoint(context, 'Update all leave records immediately', isDark: isDark),
                    ],
                  ),
                ),
              ),
              Gap(24.h),
              // Buttons
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton.outline(label: 'Cancel', height: 42.h, onPressed: onCancel),
                    ),
                    Gap(12.w),
                    Expanded(
                      child: AppButton(
                        label: 'Confirm & Run',
                        type: AppButtonType.danger,
                        height: 42.h,
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
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text, {required bool isDark}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.redTextSecondary),
        ),
        Gap(8.w),
        Expanded(
          child: Text(
            text,
            style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.redTextSecondary),
          ),
        ),
      ],
    );
  }
}
