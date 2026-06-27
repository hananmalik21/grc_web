import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'compensation_plan_detail_overview_data.dart';
import 'compensation_plan_detail_overview_shell_card.dart';

class CompensationPlanDetailOverviewInfoCard extends StatelessWidget {
  final CompensationPlanDetailOverviewData data;

  const CompensationPlanDetailOverviewInfoCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CompensationPlanDetailOverviewShellCard(
      title: 'General Information',
      subtitle: 'Basic plan configuration and metadata',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var index = 0; index < data.generalInformation.length; index += 2) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _InfoField(data: data.generalInformation[index])),
                Gap(16.w),
                Expanded(child: _InfoField(data: data.generalInformation[index + 1])),
              ],
            ),
            Gap(16.h),
          ],
          _OwnerField(owner: data.owner),
        ],
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  final OverviewField data;

  const _InfoField({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.label.toUpperCase(),
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: 12.sp,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textTertiaryDark : const Color(0xFF6A7282),
            ),
          ),
          Gap(7.h),
          Text(
            data.value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
            ),
          ),
        ],
      ),
    );
  }
}

class _OwnerField extends StatelessWidget {
  final OwnerInfo owner;

  const _OwnerField({required this.owner});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PLAN OWNER',
            style: context.textTheme.labelSmall?.copyWith(
              fontSize: 12.sp,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textTertiaryDark : const Color(0xFF6A7282),
            ),
          ),
          Gap(7.h),
          Row(
            children: [
              Container(
                width: 32.w,
                height: 32.w,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: Color(0xFFDBEAFE), shape: BoxShape.circle),
                child: Text(
                  owner.initials,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Gap(8.w),
              Text(
                owner.name,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : const Color(0xFF101828),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
