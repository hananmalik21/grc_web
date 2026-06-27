import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/components/holiday_card.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/components/holiday_mobile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PublicHolidaysMobileSkeleton extends StatelessWidget {
  const PublicHolidaysMobileSkeleton({super.key, this.groupCount = 3, this.holidaysPerGroup = 2});

  final int groupCount;
  final int holidaysPerGroup;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(groupCount, (groupIndex) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SkeletonMonthLabel(isDark: isDark),
              Gap(10.h),
              ...List.generate(holidaysPerGroup, (index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HolidayMobileCard(holiday: _skeletonHolidays[index % _skeletonHolidays.length]),
                    if (index < holidaysPerGroup - 1) Gap(12.h),
                  ],
                );
              }),
              if (groupIndex < groupCount - 1) Gap(16.h),
            ],
          );
        }),
      ),
    );
  }

  static final List<HolidayCardData> _skeletonHolidays = [
    const HolidayCardData(
      id: '1',
      day: 1,
      month: 'Jan',
      nameEn: 'National Day Holiday',
      nameAr: 'اليوم الوطني',
      descriptionEn: 'Annual national public holiday',
      descriptionAr: 'عطلة وطنية سنوية',
      type: HolidayType.fixed,
      paymentStatus: HolidayPaymentStatus.paid,
      date: '01 Jan 2026',
      appliesTo: 'All Employees',
    ),
    const HolidayCardData(
      id: '2',
      day: 15,
      month: 'Mar',
      nameEn: 'Islamic New Year',
      nameAr: 'رأس السنة الهجرية',
      descriptionEn: 'Islamic calendar new year',
      descriptionAr: 'بداية السنة الهجرية الجديدة',
      type: HolidayType.islamic,
      paymentStatus: HolidayPaymentStatus.paid,
      date: '15 Mar 2026',
      appliesTo: 'All Departments',
    ),
  ];
}

class _SkeletonMonthLabel extends StatelessWidget {
  const _SkeletonMonthLabel({required this.isDark});

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
          'January 2026',
          style: context.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
