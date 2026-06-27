import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/compensation/presentation/models/employee_compensation_table_row_data.dart';
import 'package:grc/features/compensation/presentation/providers/employees/employee_compensation_list_provider.dart';
import 'package:grc/features/compensation/presentation/screens/employee_compensation/employee_compensation_detail_page.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/employee_compensation_permission_mixin.dart';
import 'package:grc/features/compensation/presentation/widgets/employee_compensation/employee_compensation_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmployeeCompensationListMobile extends ConsumerWidget {
  const EmployeeCompensationListMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final isLoading = ref.watch(employeeCompensationIsLoadingProvider);
    final errorMessage = ref.watch(employeeCompensationErrorProvider);
    final items = ref.watch(employeeCompensationListItemsProvider);
    final liveRows = items.map((item) => item.toTableRowData()).toList();
    final rows = isLoading && liveRows.isEmpty ? EmployeeCompensationSkeleton.rows : liveRows;
    final currentPage = ref.watch(employeeCompensationListCurrentPageProvider);
    final totalPages = ref.watch(employeeCompensationTotalPagesProvider);
    final hasNext = ref.watch(employeeCompensationHasNextProvider);
    final hasPrevious = ref.watch(employeeCompensationHasPreviousProvider);
    final actions = ref.read(employeeCompensationListActionsProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (errorMessage != null && liveRows.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: MobileStateCard(
                isDark: isDark,
                borderColor: isDark ? AppColors.cardBorderDark : AppColors.errorBorder,
                iconBackground: AppColors.errorBg,
                icon: Icon(Icons.wifi_off_rounded, size: 32.sp, color: AppColors.brandRed),
                title: 'Failed to load employees',
                subtitle: errorMessage,
                action: GestureDetector(
                  onTap: actions.refresh,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
                    decoration: BoxDecoration(color: AppColors.brandRed, borderRadius: BorderRadius.circular(10.r)),
                    child: Text(
                      'Retry',
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.buttonTextLight),
                    ),
                  ),
                ),
              ),
            )
          else
            Skeletonizer(
              enabled: isLoading,
              child: rows.isEmpty && !isLoading
                  ? Padding(
                      padding: EdgeInsets.all(16.w),
                      child: MobileStateCard(
                        isDark: isDark,
                        borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
                        iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
                        icon: Icon(
                          Icons.people_alt_rounded,
                          size: 32.sp,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                        title: 'No Employees Found',
                        subtitle: 'No employees match your search or filters.',
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                      itemCount: rows.length,
                      separatorBuilder: (_, _) => Gap(10.h),
                      itemBuilder: (context, index) => _EmployeeCard(row: rows[index], isDark: isDark),
                    ),
            ),
          const DigifyDivider.horizontal(),
          MobilePaginationControls(
            isDark: isDark,
            currentPage: currentPage,
            totalPages: totalPages,
            hasPrevious: hasPrevious,
            hasNext: hasNext,
            onPrevious: hasPrevious && !isLoading ? actions.previousPage : null,
            onNext: hasNext && !isLoading ? actions.nextPage : null,
          ),
        ],
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget with EmployeeCompensationPermissionMixin {
  const _EmployeeCard({required this.row, required this.isDark});

  final EmployeeCompensationTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final tileBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final primaryColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: tileBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.employeeName,
                      style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Gap(2.h),
                    Text(
                      row.employeeId,
                      style: context.textTheme.labelSmall?.copyWith(color: subtitleColor, fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              DigifyStatusCapsule(status: row.status),
            ],
          ),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: _InfoRow(
                  label: 'Department',
                  value: row.department,
                  valueColor: primaryColor,
                  labelColor: subtitleColor,
                ),
              ),
              Gap(8.w),
              Expanded(
                child: _InfoRow(
                  label: 'Position',
                  value: row.position,
                  valueColor: primaryColor,
                  labelColor: subtitleColor,
                ),
              ),
            ],
          ),
          Gap(8.h),
          Row(
            children: [
              _LabelChip(label: 'Region', value: row.region, isDark: isDark),
              Gap(6.w),
              _LabelChip(label: 'Grade', value: row.grade, isDark: isDark),
            ],
          ),
          Gap(8.h),
          _InfoRow(
            label: 'Compensation Plan',
            value: row.compensationPlan,
            valueColor: primaryColor,
            labelColor: subtitleColor,
          ),
          Gap(4.h),
          _InfoRow(
            label: 'Salary Structure',
            value: row.salaryStructure,
            valueColor: subtitleColor,
            labelColor: subtitleColor,
          ),
          Gap(12.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Row(
            children: [
              Expanded(
                child: _AmountColumn(
                  label: 'Base Salary',
                  value: row.baseSalaryLabel,
                  isDark: isDark,
                  isEmphasized: true,
                ),
              ),
              Expanded(
                child: _AmountColumn(label: 'Allowances', value: row.allowancesLabel, isDark: isDark),
              ),
              Expanded(
                child: _AmountColumn(label: 'Benefits', value: row.benefitsLabel, isDark: isDark),
              ),
              Expanded(
                child: _AmountColumn(
                  label: 'Total',
                  value: row.totalCompensationLabel,
                  isDark: isDark,
                  isEmphasized: true,
                ),
              ),
            ],
          ),
          Gap(12.h),
          if (canViewEmployeeCompensation) ...[
            const DigifyDivider.thin(),
            Gap(10.h),
            Align(
              alignment: Alignment.centerRight,
              child: _ViewButton(employeeGuid: row.employeeGuid, planGuid: row.planGuid),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, required this.valueColor, required this.labelColor});

  final String label;
  final String value;
  final Color valueColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(fontSize: 11.sp, color: labelColor),
        ),
        Gap(2.h),
        Text(
          value,
          style: context.textTheme.bodySmall?.copyWith(fontSize: 13.sp, fontWeight: FontWeight.w500, color: valueColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _LabelChip extends StatelessWidget {
  const _LabelChip({required this.label, required this.value, required this.isDark});

  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 11.sp,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        DigifyCapsule(
          label: value,
          backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
          textColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ],
    );
  }
}

class _AmountColumn extends StatelessWidget {
  const _AmountColumn({required this.label, required this.value, required this.isDark, this.isEmphasized = false});

  final String label;
  final String value;
  final bool isDark;
  final bool isEmphasized;

  @override
  Widget build(BuildContext context) {
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(fontSize: 10.sp, color: labelColor),
        ),
        Gap(2.h),
        Text(
          value,
          style: context.textTheme.bodySmall?.copyWith(
            fontSize: 12.sp,
            fontWeight: isEmphasized ? FontWeight.w600 : FontWeight.w400,
            color: valueColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ViewButton extends StatelessWidget {
  const _ViewButton({required this.employeeGuid, required this.planGuid});

  final String employeeGuid;
  final String planGuid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(
        EmployeeCompensationDetailPage.routeName,
        extra: {'employeeGuid': employeeGuid, 'planGuid': planGuid},
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          'View Details',
          style: context.textTheme.labelSmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
