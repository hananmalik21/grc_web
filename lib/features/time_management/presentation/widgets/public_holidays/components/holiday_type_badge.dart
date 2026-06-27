import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HolidayTypeBadge extends StatelessWidget {
  final HolidayType type;
  final HolidayPaymentStatus paymentStatus;

  const HolidayTypeBadge({super.key, required this.type, required this.paymentStatus});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [_buildTypeBadge(context), Gap(8.w), _buildPaymentBadge(context)],
    );
  }

  Widget _buildTypeBadge(BuildContext context) {
    final isDark = context.isDark;
    final isIslamicPaid = type == HolidayType.islamic && paymentStatus == HolidayPaymentStatus.paid;

    final (label, bgColor, textColor) = switch (type) {
      HolidayType.fixed => (
        'FIXED',
        isDark ? AppColors.holidayFixedBgDark : AppColors.holidayFixedBg,
        isDark ? AppColors.holidayFixedTextDark : AppColors.holidayFixedText,
      ),
      HolidayType.islamic => (
        'ISLAMIC',
        isIslamicPaid
            ? (isDark ? AppColors.holidayIslamicPaidBgDark : AppColors.holidayIslamicPaidBg)
            : (isDark ? AppColors.holidayIslamicBgDark : AppColors.holidayIslamicBg),
        isIslamicPaid
            ? (isDark ? AppColors.holidayIslamicPaidTextDark : AppColors.holidayIslamicPaidText)
            : (isDark ? AppColors.holidayIslamicTextDark : AppColors.holidayIslamicText),
      ),
      HolidayType.variable => (
        'VARIABLE',
        isDark ? AppColors.primaryDark : AppColors.primary.withValues(alpha: 0.1),
        isDark ? AppColors.primaryLight : AppColors.primary,
      ),
    };

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4.r)),
      child: Text(
        label,
        style: TextStyle(fontSize: 12.6.sp, fontWeight: FontWeight.w500, color: textColor, fontFamily: 'Inter'),
      ),
    );
  }

  Widget _buildPaymentBadge(BuildContext context) {
    final isDark = context.isDark;
    final isIslamicPaid = type == HolidayType.islamic && paymentStatus == HolidayPaymentStatus.paid;

    final (label, bgColor, textColor) = switch (paymentStatus) {
      HolidayPaymentStatus.paid => (
        'PAID',
        isIslamicPaid
            ? (isDark ? AppColors.holidayIslamicPaidBgDark : AppColors.holidayIslamicPaidBg)
            : (isDark ? AppColors.holidayPaidBgDark : AppColors.holidayPaidBg),
        isIslamicPaid
            ? (isDark ? AppColors.holidayIslamicPaidTextDark : AppColors.holidayIslamicPaidText)
            : (isDark ? AppColors.holidayPaidTextDark : AppColors.holidayPaidText),
      ),
      HolidayPaymentStatus.unpaid => (
        'UNPAID',
        isDark ? AppColors.holidayUnpaidBgDark : AppColors.holidayUnpaidBg,
        isDark ? AppColors.holidayUnpaidTextDark : AppColors.holidayUnpaidText,
      ),
    };

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(4.r)),
      child: Text(
        label,
        style: TextStyle(fontSize: 12.6.sp, fontWeight: FontWeight.w500, color: textColor, fontFamily: 'Inter'),
      ),
    );
  }
}
