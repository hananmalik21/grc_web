import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/action_button.dart';
import 'package:grc/core/widgets/buttons/icon_action_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/components/holiday_card.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/components/holiday_type_badge.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/public_holidays_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HolidayMobileCard extends StatelessWidget {
  const HolidayMobileCard({
    super.key,
    required this.holiday,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.isDeleting = false,
  });

  final HolidayCardData holiday;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isDeleting;

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
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _CardHeader(holiday: holiday, isDark: isDark),
            Gap(10.h),
            _CardMeta(holiday: holiday, isDark: isDark),
            DigifyDivider(margin: EdgeInsets.symmetric(vertical: 12.h)),
            _CardActions(onView: onView, onEdit: onEdit, onDelete: onDelete, isDeleting: isDeleting),
          ],
        ),
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.holiday, required this.isDark});

  final HolidayCardData holiday;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DateBadge(day: holiday.day, month: holiday.month, isDark: isDark),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                holiday.nameEn,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gap(4.h),
              Text(
                holiday.nameAr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textDirection: TextDirection.rtl,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              Gap(6.h),
              HolidayTypeBadge(type: holiday.type, paymentStatus: holiday.paymentStatus),
            ],
          ),
        ),
      ],
    );
  }
}

class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.day, required this.month, required this.isDark});

  final int day;
  final String month;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.infoBg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$day',
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
            ),
          ),
          Text(
            month,
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: 10.sp,
              color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CardMeta extends StatelessWidget {
  const _CardMeta({required this.holiday, required this.isDark});

  final HolidayCardData holiday;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final labelStyle = context.textTheme.labelSmall?.copyWith(
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
    );
    final valueStyle = context.textTheme.labelMedium?.copyWith(
      color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
      fontWeight: FontWeight.w500,
    );

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Applies To', style: labelStyle),
              Gap(2.h),
              Text(holiday.appliesTo, style: valueStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        Container(
          height: 24.h,
          width: 1,
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
          margin: EdgeInsets.symmetric(horizontal: 12.w),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date', style: labelStyle),
              Gap(2.h),
              Text(holiday.date, style: valueStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}

class _CardActions extends StatelessWidget with PublicHolidaysPermissionMixin {
  const _CardActions({required this.onView, required this.onEdit, required this.onDelete, required this.isDeleting});

  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isDeleting;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (canViewPublicHoliday && onView != null)
          Expanded(
            child: ActionButton(
              label: 'View',
              onTap: onView!,
              iconPath: Assets.icons.viewIconBlue.path,
              backgroundColor: AppColors.infoBg,
              foregroundColor: AppColors.primary,
            ),
          ),
        if (canUpdatePublicHoliday && onEdit != null) ...[
          Gap(8.w),
          Expanded(
            child: ActionButton(
              label: 'Edit',
              onTap: onEdit!,
              iconPath: Assets.icons.editIconGreen.path,
              backgroundColor: AppColors.greenBg,
              foregroundColor: AppColors.greenButton,
            ),
          ),
        ],
        if (canDeletePublicHoliday && onDelete != null) ...[
          Gap(8.w),
          IconActionButton(
            iconPath: Assets.icons.deleteIconRed.path,
            bgColor: AppColors.errorBg,
            iconColor: AppColors.error,
            onPressed: isDeleting ? null : onDelete,
            isLoading: isDeleting,
          ),
        ],
      ],
    );
  }
}
