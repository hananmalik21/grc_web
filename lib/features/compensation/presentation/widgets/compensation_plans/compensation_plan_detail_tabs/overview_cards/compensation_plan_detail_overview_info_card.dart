import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/features/compensation/config/compensation_plan_overview_config.dart';
import 'package:grc/features/compensation/presentation/models/compensation_plan_table_row_data.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/overview_cards/overview_shell_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OverviewField {
  final String label;
  final String value;

  const OverviewField({required this.label, required this.value});
}

class OwnerInfo {
  final String name;

  const OwnerInfo({required this.name});
}

class CompensationPlanOverviewData {
  final List<OverviewField> generalInformation;
  final OwnerInfo owner;

  const CompensationPlanOverviewData({required this.generalInformation, required this.owner});

  factory CompensationPlanOverviewData.fromRow(CompensationPlanTableRowData row) {
    return CompensationPlanOverviewData(
      generalInformation: [
        OverviewField(label: 'Plan Type', value: row.type),
        OverviewField(label: 'Currency', value: row.currency),
        const OverviewField(label: 'Business Unit', value: CompensationPlanOverviewConfig.defaultBusinessUnit),
        const OverviewField(label: 'Department', value: CompensationPlanOverviewConfig.defaultDepartment),
        const OverviewField(label: 'Created Date', value: CompensationPlanOverviewConfig.defaultCreatedDate),
        const OverviewField(label: 'Last Modified', value: CompensationPlanOverviewConfig.defaultLastModifiedDate),
      ],
      owner: const OwnerInfo(name: CompensationPlanOverviewConfig.defaultOwnerName),
    );
  }
}

class CompensationPlanDetailOverviewInfoCard extends StatelessWidget {
  final CompensationPlanOverviewData data;

  const CompensationPlanDetailOverviewInfoCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return OverviewShellCard(
      title: 'General Information',
      subtitle: 'Basic plan configuration and metadata',
      minBodyHeight: 220.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
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
            ],
          ),
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
            style: context.textTheme.labelMedium?.copyWith(
              color: isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText,
            ),
          ),
          Gap(7.h),
          Text(
            data.value,
            style: context.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
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
            style: context.textTheme.labelMedium?.copyWith(
              color: isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText,
            ),
          ),
          Gap(7.h),
          Row(
            children: [
              AppAvatar(fallbackInitial: owner.name, size: 32.w),
              Gap(8.w),
              Text(
                owner.name,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
