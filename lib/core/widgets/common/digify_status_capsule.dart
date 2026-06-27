import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/date_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

enum DigifyStatusCapsuleVariant { pill, rounded, boxy }

class DigifyStatusCapsule extends StatelessWidget {
  final String status;
  final DigifyStatusCapsuleVariant variant;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final bool showDotWhenActive;

  const DigifyStatusCapsule({
    super.key,
    required this.status,
    this.variant = DigifyStatusCapsuleVariant.pill,
    this.padding,
    this.borderRadius,
    this.showDotWhenActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final safeStatus = status.trim().isEmpty ? '—' : status.trim();
    final style = _DigifyStatusCapsuleStyle.fromStatus(safeStatus, isDark: isDark);

    final effectiveRadius =
        borderRadius ??
        switch (variant) {
          DigifyStatusCapsuleVariant.pill => 999.r,
          DigifyStatusCapsuleVariant.rounded => 10.r,
          DigifyStatusCapsuleVariant.boxy => 6.r,
        };

    final effectivePadding =
        padding ??
        switch (variant) {
          DigifyStatusCapsuleVariant.pill => EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          DigifyStatusCapsuleVariant.rounded => EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          DigifyStatusCapsuleVariant.boxy => EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        };

    final showDot = showDotWhenActive && style.shouldShowDot;

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: BorderRadius.circular(effectiveRadius),
        border: Border.all(color: style.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showDot) ...[
            Container(
              width: 7.w,
              height: 7.w,
              decoration: BoxDecoration(color: style.dotColor, shape: BoxShape.circle),
            ),
            Gap(8.w),
          ],
          Text(
            safeStatus.toTitleCase(),
            textAlign: TextAlign.center,
            style: context.textTheme.labelSmall?.copyWith(
              color: style.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _DigifyStatusCapsuleStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final bool shouldShowDot;
  final Color dotColor;

  const _DigifyStatusCapsuleStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.shouldShowDot,
    required this.dotColor,
  });

  static _DigifyStatusCapsuleStyle fromStatus(String status, {required bool isDark}) {
    final normalized = status.trim().toUpperCase();

    if (normalized == 'PRESENT' || normalized == 'OFFICIAL WORK' || normalized == 'BUSINESS TRIP') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.infoBgDark : AppColors.infoBg,
        borderColor: isDark ? AppColors.infoBorderDark : AppColors.infoBorder,
        textColor: isDark ? AppColors.infoTextDark : AppColors.infoText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.infoTextDark : AppColors.infoText,
      );
    }

    if (normalized == 'LATE' || normalized == 'LATE IN') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.warningBgDark : AppColors.pendingStatusBackground,
        borderColor: isDark ? AppColors.warningBorderDark : AppColors.warningBorder,
        textColor: isDark ? AppColors.warningTextDark : AppColors.pendingStatucColor,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.warningTextDark : AppColors.pendingStatucColor,
      );
    }

    if (normalized == 'ABSENT') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.errorBgDark : AppColors.errorBg,
        borderColor: isDark ? AppColors.errorBorderDark : AppColors.errorBorder,
        textColor: isDark ? AppColors.errorTextDark : AppColors.errorText,
        shouldShowDot: false,
        dotColor: AppColors.error,
      );
    }

    if (normalized == 'EARLY' || normalized == 'EARLY OUT') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.successBgDark : AppColors.greenBg,
        borderColor: isDark ? AppColors.successBorderDark : AppColors.successBorder,
        textColor: isDark ? AppColors.successTextDark : AppColors.greenText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.successTextDark : AppColors.greenText,
      );
    }

    if (normalized == 'ON LEAVE' || normalized == 'LEAVE') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.grayBgDark : AppColors.grayBg,
        borderColor: isDark ? AppColors.grayBorderDark : AppColors.grayBorder,
        textColor: isDark ? AppColors.grayTextDark : AppColors.grayText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.grayTextDark : AppColors.grayText,
      );
    }

    if (normalized == 'HALF DAY') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.warningBgDark : AppColors.warningBg,
        borderColor: isDark ? AppColors.warningBorderDark : AppColors.warningBorder,
        textColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
      );
    }

    if (normalized == 'ON HOLD' || normalized == 'ON_HOLD') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.warningBgDark : AppColors.warningBg,
        borderColor: isDark ? AppColors.warningBorderDark : AppColors.warningBorder,
        textColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
      );
    }

    if (normalized == 'CLOSED' || normalized == 'NOT OPEN' || normalized == 'NOT_OPEN') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.grayBgDark : AppColors.grayBg,
        borderColor: isDark ? AppColors.grayBorderDark : AppColors.grayBorder,
        textColor: isDark ? AppColors.grayTextDark : AppColors.grayText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.grayTextDark : AppColors.grayText,
      );
    }

    if (normalized == 'ACTIVE' || normalized == 'APPROVED' || normalized == 'OPEN' || normalized == 'CURRENT') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.successBgDark : AppColors.successBg,
        borderColor: isDark ? AppColors.successBorderDark : AppColors.successBorder,
        textColor: isDark ? AppColors.successTextDark : AppColors.successText,
        shouldShowDot: true,
        dotColor: AppColors.success,
      );
    }

    if (normalized == 'IDLE' || normalized == 'INACTIVE') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.grayBgDark : AppColors.grayBg,
        borderColor: isDark ? AppColors.grayBorderDark : AppColors.grayBorder,
        textColor: isDark ? AppColors.grayTextDark : AppColors.grayText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.grayTextDark : AppColors.grayText,
      );
    }

    if (normalized == 'LOCKED' ||
        normalized == 'REJECTED' ||
        normalized == 'REJECT' ||
        normalized == 'REJEECTED' ||
        normalized == 'DECLINE' ||
        normalized == 'DECLINED' ||
        normalized == 'FAILED' ||
        normalized == 'ERROR') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.errorBgDark : AppColors.errorBg,
        borderColor: isDark ? AppColors.errorBorderDark : AppColors.errorBorder,
        textColor: isDark ? AppColors.errorTextDark : AppColors.errorText,
        shouldShowDot: false,
        dotColor: AppColors.error,
      );
    }

    if (normalized == 'PENDING' ||
        normalized == 'PENDING APPROVAL' ||
        normalized == 'SUBMITTED' ||
        normalized == 'APPROVAL REQUIRED' ||
        normalized == 'TEST DUE') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.warningBgDark : AppColors.warningBg,
        borderColor: isDark ? AppColors.warningBorderDark : AppColors.warningBorder,
        textColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
      );
    }

    if (normalized == 'EXTEND' || normalized == 'EXTENDED') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.warningBgDark : AppColors.warningBg,
        borderColor: isDark ? AppColors.warningBorderDark : AppColors.warningBorder,
        textColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
      );
    }

    if (normalized == 'WITHDRAW' || normalized == 'WITHDRAWN') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.grayBgDark : AppColors.grayBg,
        borderColor: isDark ? AppColors.grayBorderDark : AppColors.grayBorder,
        textColor: isDark ? AppColors.grayTextDark : AppColors.grayText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.grayTextDark : AppColors.grayText,
      );
    }

    if (normalized == 'DRAFT' || normalized == 'INTERVIEW' || normalized == 'SHORTLISTED') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.infoBgDark : AppColors.infoBg,
        borderColor: isDark ? AppColors.infoBorderDark : AppColors.infoBorder,
        textColor: isDark ? AppColors.infoTextDark : AppColors.infoText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.infoTextDark : AppColors.infoText,
      );
    }

    if (normalized == 'SELECTED' ||
        normalized == 'ACCEPTED' ||
        normalized == 'COMPLETED' ||
        normalized == 'COMPLETE' ||
        normalized == 'TESTED') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.successBgDark : AppColors.shiftActiveStatusBg,
        borderColor: isDark ? AppColors.successBorderDark : AppColors.successBorder,
        textColor: isDark ? AppColors.successTextDark : AppColors.roleBadgeSystemText,
        shouldShowDot: normalized == 'SELECTED',
        dotColor: AppColors.success,
      );
    }

    if (normalized == 'IN PROGRESS' || normalized == 'IN_PROGRESS') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.infoBgDark : AppColors.infoBg,
        borderColor: isDark ? AppColors.infoBorderDark : AppColors.infoBorder,
        textColor: isDark ? AppColors.infoTextDark : AppColors.infoText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.infoTextDark : AppColors.infoText,
      );
    }

    if (normalized == 'SENT') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.infoBgDark : AppColors.delegationDetailsBg,
        borderColor: isDark ? AppColors.infoBorderDark : AppColors.infoBorder,
        textColor: isDark ? AppColors.infoTextDark : AppColors.roleActionBlue,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.infoTextDark : AppColors.roleActionBlue,
      );
    }

    if (normalized == 'RECEIVED') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.infoBgDark : AppColors.delegationDetailsBg,
        borderColor: isDark ? AppColors.infoBorderDark : AppColors.infoBorder,
        textColor: isDark ? AppColors.infoTextDark : AppColors.primary,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.infoTextDark : AppColors.primary,
      );
    }

    if (normalized == 'PROBATION') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.warningBgDark : AppColors.warningBg,
        borderColor: isDark ? AppColors.warningBorderDark : AppColors.warningBorder,
        textColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.warningTextDark : AppColors.warningText,
      );
    }

    if (normalized == 'CRITICAL' || status.trim() == 'حرج') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.errorBgDark : AppColors.errorBg,
        borderColor: isDark ? AppColors.errorBorderDark : AppColors.errorBorder,
        textColor: isDark ? AppColors.errorTextDark : AppColors.errorText,
        shouldShowDot: false,
        dotColor: AppColors.error,
      );
    }

    if (normalized == 'HIGH' || status.trim() == 'عالية') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.warningBgDark : AppColors.orangeBg,
        borderColor: isDark ? AppColors.warningBorderDark : AppColors.orangeBorder,
        textColor: isDark ? AppColors.warningTextDark : AppColors.orangeText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.warningTextDark : AppColors.orange,
      );
    }

    if (normalized == 'MEDIUM' || status.trim() == 'متوسطة') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.purpleBgDark : AppColors.warningBg,
        borderColor: isDark ? AppColors.purpleBorderDark : AppColors.warningBorder,
        textColor: isDark ? AppColors.purpleTextDark : AppColors.warningText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.purpleTextDark : AppColors.warning,
      );
    }

    if (normalized == 'LOW' || status.trim() == 'منخفضة') {
      return _DigifyStatusCapsuleStyle(
        backgroundColor: isDark ? AppColors.successBgDark : AppColors.successBg,
        borderColor: isDark ? AppColors.successBorderDark : AppColors.successBorder,
        textColor: isDark ? AppColors.successTextDark : AppColors.successText,
        shouldShowDot: false,
        dotColor: isDark ? AppColors.successTextDark : AppColors.success,
      );
    }

    return _DigifyStatusCapsuleStyle(
      backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
      borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
      textColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      shouldShowDot: false,
      dotColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
    );
  }
}
