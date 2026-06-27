import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/compensation/domain/models/adjustments/salary_change_history.dart';
import 'package:grc/features/compensation/presentation/providers/salary_change_history_tab_provider.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_detail_bottom_sheet.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SalaryChangeHistoryMobileTable extends ConsumerWidget {
  const SalaryChangeHistoryMobileTable({super.key});

  SalaryChangeHistoryTableRowData _mapToRowData(SalaryChangeHistoryEntry entry) {
    return SalaryChangeHistoryTableRowData(
      employeeName: entry.employeeNameEn,
      employeeId: entry.employeeNumber,
      changeId: entry.displayChangeId,
      changeDate: entry.submissionDate != null ? entry.displayEffectiveDate : '-',
      department: entry.orgStructureList.isNotEmpty ? entry.orgStructureList.first.orgUnitNameEn : '-',
      jobTitle: entry.positionName,
      gradeName: entry.gradeName,
      changeType: entry.changeType,
      effectiveDate: entry.displayEffectiveDate,
      previousSalaryLabel: entry.formattedPreviousSalary,
      newSalaryLabel: entry.formattedCurrentSalary,
      changeAmountLabel: entry.formattedImpactAmount,
      changePercentLabel: entry.formattedImpactPercent,
      isIncrease: entry.isIncrease,
      isDecrease: entry.isDecrease,
      status: entry.status,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final dataAsync = ref.watch(salaryChangeHistoryDataPageProvider);
    final tabNotifier = ref.read(salaryChangeHistoryTabProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          dataAsync.when(
            skipLoadingOnRefresh: false,
            data: (page) {
              if (dataAsync.isRefreshing || dataAsync.isReloading) {
                return _buildSkeleton(isDark);
              }
              if (page.data.isEmpty) {
                return Padding(
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
                    title: 'No Salary Change History',
                    subtitle: 'No records match your search or filters.',
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                itemCount: page.data.length,
                separatorBuilder: (_, _) => Gap(10.h),
                itemBuilder: (context, index) {
                  return _SalaryChangeHistoryMobileCard(row: _mapToRowData(page.data[index]), isDark: isDark);
                },
              );
            },
            loading: () => _buildSkeleton(isDark),
            error: (err, stack) => Padding(
              padding: EdgeInsets.all(16.w),
              child: MobileStateCard(
                isDark: isDark,
                borderColor: isDark ? AppColors.cardBorderDark : AppColors.errorBorder,
                iconBackground: AppColors.errorBg,
                icon: Icon(Icons.wifi_off_rounded, size: 32.sp, color: AppColors.brandRed),
                title: 'Failed to load history',
                subtitle: err.toString(),
              ),
            ),
          ),
          const DigifyDivider.horizontal(),
          () {
            final page = dataAsync.value;
            final isLoading = dataAsync.isLoading && page == null;

            return Skeletonizer(
              enabled: isLoading,
              child: MobilePaginationControls(
                isDark: isDark,
                currentPage: page?.pagination.page ?? 1,
                totalPages: page?.pagination.totalPages ?? 1,
                hasPrevious: page?.pagination.hasPrevious ?? false,
                hasNext: page?.pagination.hasNext ?? false,
                onPrevious: (page?.pagination.hasPrevious ?? false) ? tabNotifier.previousPage : null,
                onNext: (page?.pagination.hasNext ?? false)
                    ? () => tabNotifier.nextPage(totalPages: page?.pagination.totalPages ?? 1)
                    : null,
              ),
            );
          }(),
        ],
      ),
    );
  }

  Widget _buildSkeleton(bool isDark) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
        itemCount: 3,
        separatorBuilder: (_, _) => Gap(10.h),
        itemBuilder: (context, index) {
          return _SalaryChangeHistoryMobileCard(row: SalaryChangeHistoryConfig.mockTableRows.first, isDark: isDark);
        },
      ),
    );
  }
}

class _SalaryChangeHistoryMobileCard extends StatelessWidget {
  const _SalaryChangeHistoryMobileCard({required this.row, required this.isDark});

  final SalaryChangeHistoryTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final primaryColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final tileBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
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
                      style: context.textTheme.titleSmall?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(2.h),
                    Text(
                      row.employeeId,
                      style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: subtitleColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              DigifyStatusCapsule(status: row.status),
            ],
          ),
          Gap(12.h),
          _InfoRow(label: 'CHANGE ID', value: row.changeId, isDark: isDark),
          Gap(8.h),
          _InfoRow(label: 'CHANGE TYPE', value: row.changeType, isDark: isDark),
          Gap(8.h),
          _InfoRow(label: 'EFFECTIVE DATE', value: row.effectiveDate, isDark: isDark),
          Gap(8.h),
          _InfoRow(label: 'PREVIOUS SALARY', value: row.previousSalaryLabel, isDark: isDark),
          Gap(8.h),
          _InfoRow(label: 'NEW SALARY', value: row.newSalaryLabel, isDark: isDark, isEmphasized: true),
          Gap(8.h),
          _InfoRow(
            label: 'CHANGE',
            value: '${row.changeAmountLabel} (${row.changePercentLabel})',
            isDark: isDark,
            valueColor: row.isIncrease ? AppColors.success : (row.isDecrease ? AppColors.warning : null),
          ),
          Gap(12.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Align(
            alignment: Alignment.centerRight,
            child: _ViewDetailsButton(row: row),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.isEmphasized = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isDark;
  final bool isEmphasized;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final effectiveValueColor = valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 132.w,
          child: Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(fontSize: 11.sp, color: labelColor, height: 1.3),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.bodySmall?.copyWith(
              fontSize: 13.sp,
              height: 1.35,
              fontWeight: isEmphasized ? FontWeight.w600 : FontWeight.w400,
              color: effectiveValueColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _ViewDetailsButton extends StatelessWidget {
  const _ViewDetailsButton({required this.row});

  final SalaryChangeHistoryTableRowData row;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => SalaryChangeHistoryDetailBottomSheet.show(context, row: row),
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
