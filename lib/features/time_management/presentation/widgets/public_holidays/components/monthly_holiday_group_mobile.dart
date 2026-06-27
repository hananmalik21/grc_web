import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_management/presentation/providers/public_holidays_provider.dart';
import 'package:grc/features/time_management/presentation/providers/public_holidays_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/components/holiday_mobile_card.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/components/monthly_holiday_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MonthlyHolidayGroupMobile extends ConsumerWidget {
  const MonthlyHolidayGroupMobile({
    super.key,
    required this.data,
    this.onViewHoliday,
    this.onEditHoliday,
    this.onDeleteHoliday,
  });

  final MonthlyHolidayGroupData data;
  final void Function(String holidayId)? onViewHoliday;
  final void Function(String holidayId)? onEditHoliday;
  final void Function(String holidayId)? onDeleteHoliday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enterpriseId = ref.watch(publicHolidaysTabEnterpriseIdProvider);
    if (enterpriseId == null) return const SizedBox.shrink();

    final isDark = context.isDark;
    final state = ref.watch(publicHolidaysNotifierProvider(enterpriseId));
    final deletingHolidayId = state.deletingHolidayId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MonthLabel(monthYear: data.monthYear, isDark: isDark),
        Gap(10.h),
        ...data.holidays.asMap().entries.map((entry) {
          final index = entry.key;
          final holiday = entry.value;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HolidayMobileCard(
                holiday: holiday,
                onView: onViewHoliday != null ? () => onViewHoliday!(holiday.id) : null,
                onEdit: onEditHoliday != null ? () => onEditHoliday!(holiday.id) : null,
                onDelete: onDeleteHoliday != null ? () => onDeleteHoliday!(holiday.id) : null,
                isDeleting: deletingHolidayId != null && deletingHolidayId == int.tryParse(holiday.id),
              ),
              if (index < data.holidays.length - 1) Gap(12.h),
            ],
          );
        }),
      ],
    );
  }
}

class _MonthLabel extends StatelessWidget {
  const _MonthLabel({required this.monthYear, required this.isDark});

  final String monthYear;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 16.h,
          decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2.r)),
        ),
        Gap(8.w),
        Text(
          monthYear,
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
