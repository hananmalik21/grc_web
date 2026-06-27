import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_dot.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/compensation_section_card.dart';
import 'package:grc/features/compensation/presentation/providers/employee_compensation_detail_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_compensation_plan_details.dart';

class CompensationCalculationSummary extends ConsumerWidget {
  const CompensationCalculationSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeCompensationDetailProvider);
    final isDark = context.isDark;
    final details = state.details;

    final gross = details?.totalGrossMonthlyCompensation ?? 0;
    final componentGroups = details?.displayComponentGroups ?? const <EmployeeCompensationComponentGroup>[];
    final grossDisplay = details?.displayGrossMonthlyCompensationWithCurrency ?? '—';
    final typesNonEmpty = componentGroups.where((g) => g.totalAmount > 0).toList();

    return CompensationSectionCard(
      title: 'Compensation Calculation',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GROSS MONTHLY COMPENSATION',
                  style: context.textTheme.labelMedium?.copyWith(fontSize: 11.sp, color: AppColors.roleBadgeText),
                ),
                Gap(8.h),
                Text(
                  grossDisplay,
                  style: context.textTheme.titleLarge?.copyWith(fontSize: 24.sp, color: AppColors.authButton),
                ),
              ],
            ),
          ),
          if (typesNonEmpty.isNotEmpty)
            ...List.generate(typesNonEmpty.length, (idx) {
              final palette = <Color>[
                AppColors.primary,
                AppColors.success,
                AppColors.purple,
                AppColors.warning,
                AppColors.infoText,
                AppColors.error,
              ];
              final group = typesNonEmpty[idx];
              final color = palette[idx % palette.length];

              return CalcLineItem(
                label: group.displayTypeLabel,
                value: group.displayTotalAmountWithCurrency,
                dotColor: color,
              );
            }),
          DigifyDivider.horizontal(),
          Text('Breakdown', style: context.textTheme.labelSmall?.copyWith(color: AppColors.grayBorderDark)),
          _buildBreakdownBar(componentGroups, gross),
        ],
      ),
    );
  }

  Widget _buildBreakdownBar(List<EmployeeCompensationComponentGroup> groups, double total) {
    if (total <= 0) return const SizedBox();

    final palette = <Color>[
      AppColors.primary,
      AppColors.success,
      AppColors.purple,
      AppColors.warning,
      AppColors.infoText,
      AppColors.error,
    ];

    final types = groups;
    final totalAmount = total;

    final flexes = <int>[];
    var used = 0;
    for (var i = 0; i < types.length; i++) {
      final pct = types[i].totalAmount / totalAmount;
      final isLast = i == types.length - 1;
      final flex = isLast ? (1000 - used).clamp(0, 1000).toInt() : (pct * 1000).toInt();
      flexes.add(flex);
      used += flex;
    }

    return Column(
      children: [
        Container(
          height: 8.h,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r)),
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: [
              for (var i = 0; i < types.length; i++)
                Expanded(
                  flex: flexes[i],
                  child: Container(color: palette[i % palette.length]),
                ),
            ],
          ),
        ),
        Gap(8.h),
        Row(
          children: [
            for (var i = 0; i < types.length; i++)
              Expanded(
                flex: flexes[i],
                child: Text(
                  '${((types[i].totalAmount / totalAmount) * 100).toStringAsFixed(0)}%',
                  textAlign: types.length == 2 ? (i == 0 ? TextAlign.left : TextAlign.right) : TextAlign.center,
                  style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class CalcLineItem extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;

  const CalcLineItem({super.key, required this.label, required this.value, required this.dotColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
      decoration: BoxDecoration(color: AppColors.tableHeaderBackground, borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        children: [
          DigifyStatusDot(color: dotColor, size: 8.w),
          Gap(10.w),
          Expanded(
            child: Text(label, style: context.textTheme.bodyMedium?.copyWith(color: AppColors.grayBorderDark)),
          ),
          Text(
            value,
            style: context.textTheme.labelLarge?.copyWith(fontSize: 14.sp, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }
}
