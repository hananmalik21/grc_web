import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/blinking_status_dot.dart';
import 'package:grc/features/employee_self_service/presentation/providers/time_attendance/time_attendance_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class TimeAttendanceOverviewCard extends StatelessWidget {
  const TimeAttendanceOverviewCard({
    super.key,
    required this.currentServerTime,
    required this.verificationInfo,
    required this.checkInTime,
    required this.checkOutTime,
    required this.isClockedIn,
    required this.verificationCaption,
    required this.onClockPressed,
  });

  final DateTime currentServerTime;
  final TimeAttendanceVerificationInfo verificationInfo;
  final String? checkInTime;
  final String? checkOutTime;
  final bool isClockedIn;
  final String verificationCaption;
  final VoidCallback onClockPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 27.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10.r)),
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'CURRENT SERVER TIME',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: AppColors.infoBorder,
                    fontSize: 12.sp,
                    letterSpacing: 2,
                  ),
                ),
                Gap(13.h),
                Text(
                  DateFormat('HH:mm:ss').format(currentServerTime),
                  style: context.textTheme.titleLarge?.copyWith(color: AppColors.cardBackground, fontSize: 20.sp),
                ),
                Gap(8.h),
                Text(
                  DateFormat('EEEE, d MMMM yyyy').format(currentServerTime),
                  style: context.textTheme.labelMedium?.copyWith(color: AppColors.infoBorder),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarSearchBg,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(10.r)),
                        child: Center(
                          child: DigifyAsset(
                            assetPath: verificationInfo.iconPath,
                            width: 18,
                            height: 18,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              verificationInfo.label,
                              style: context.textTheme.labelLarge?.copyWith(
                                fontSize: 12.sp,
                                color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarCategoryText,
                              ),
                            ),
                            Gap(2.h),
                            Text(
                              verificationInfo.value,
                              style: context.textTheme.labelLarge?.copyWith(
                                fontSize: 12.sp,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _SecureBadge(label: verificationInfo.badgeLabel),
                    ],
                  ),
                ),
                Gap(20.h),
                Row(
                  children: [
                    Expanded(
                      child: _PunchTimeColumn(label: 'Check In', value: checkInTime ?? '--:--'),
                    ),
                    const DigifyVerticalDivider.standard(width: 24, thickness: 1),
                    Expanded(
                      child: _PunchTimeColumn(label: 'Check Out', value: checkOutTime ?? '--:--'),
                    ),
                  ],
                ),
                Gap(20.h),
                AppButton.primary(
                  label: isClockedIn ? 'Clock Out' : 'Clock In',
                  svgPath: Assets.icons.clockIcon.path,
                  onPressed: onClockPressed,
                  width: double.infinity,
                ),
                Gap(20.h),
                Text(
                  verificationCaption,
                  textAlign: TextAlign.center,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: isDark ? AppColors.textTertiaryDark : AppColors.sidebarCategoryText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecureBadge extends StatelessWidget {
  const _SecureBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: AppColors.greenBg, borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BlinkingStatusDot(color: AppColors.success, size: 7),
          Gap(5.w),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: AppColors.greenTextSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _PunchTimeColumn extends StatelessWidget {
  const _PunchTimeColumn({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: context.textTheme.headlineMedium?.copyWith(color: AppColors.sidebarCategoryText, fontSize: 12.sp),
        ),
        Gap(8.h),
        Text(value, style: context.textTheme.headlineMedium?.copyWith(fontSize: 16.sp)),
      ],
    );
  }
}
