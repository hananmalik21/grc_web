import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_table_selection_provider.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/compensation/presentation/models/adjustments/adjustment_row_data.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_list_providers.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_permission_mixin.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustment_details_mobile_sheet.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustment_details_dialog.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_tab_config.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdjustmentsListMobile extends ConsumerWidget {
  AdjustmentsListMobile({
    AdjustmentsListProviders? providers,
    this.enableRowSelection = false,
    this.pageSize = AdjustmentsTabConfig.pageSize,
    super.key,
  }) : providers = providers ?? adjustmentsListProviders;

  final AdjustmentsListProviders providers;
  final bool enableRowSelection;
  final int pageSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final isLoading = ref.watch(providers.isLoadingProvider);
    final error = ref.watch(providers.errorProvider);
    final liveRows = ref.watch(providers.rowsProvider);
    final rows = isLoading && liveRows.isEmpty
        ? List.generate(pageSize, (index) => AdjustmentsTabConfig.rows.first)
        : liveRows;
    final tabState = ref.watch(providers.tabProvider);
    final totalPages = ref.watch(providers.totalPagesProvider);
    final notifier = ref.read(providers.tabProvider.notifier);
    if (enableRowSelection) {
      ref.watch(bulkAdjustmentsTableSelectionProvider);
    }
    final selectionNotifier = ref.read(bulkAdjustmentsTableSelectionProvider.notifier);
    final allSelected = enableRowSelection && selectionNotifier.areAllSelected(liveRows);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (enableRowSelection && liveRows.isNotEmpty) ...[
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.w, 12.w, 12.w, 0),
              child: DigifyCheckbox(
                value: allSelected,
                onChanged: liveRows.isEmpty ? null : (_) => selectionNotifier.toggleAll(liveRows),
                label: 'Select all',
              ),
            ),
            Gap(8.h),
          ],
          if (error != null && liveRows.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: MobileStateCard(
                isDark: isDark,
                borderColor: isDark ? AppColors.cardBorderDark : AppColors.errorBorder,
                iconBackground: AppColors.errorBg,
                icon: Icon(Icons.wifi_off_rounded, size: 32.sp, color: AppColors.brandRed),
                title: 'Failed to load adjustments',
                subtitle: error,
                action: GestureDetector(
                  onTap: () => ref.invalidate(providers.dataPageProvider),
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
                        icon: DigifyAsset(
                          assetPath: Assets.icons.compensation.adjustment.path,
                          width: 32,
                          height: 32,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                        title: 'No Adjustments Found',
                        subtitle: 'There are no salary adjustments recorded for the selected criteria.',
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                      itemCount: rows.length,
                      separatorBuilder: (_, _) => Gap(10.h),
                      itemBuilder: (context, index) =>
                          _AdjustmentCard(row: rows[index], isDark: isDark, enableRowSelection: enableRowSelection),
                    ),
            ),
          const DigifyDivider.horizontal(),
          MobilePaginationControls(
            isDark: isDark,
            currentPage: tabState.currentPage,
            totalPages: totalPages,
            hasPrevious: tabState.currentPage > 1,
            hasNext: tabState.currentPage < totalPages,
            onPrevious: tabState.currentPage > 1 && !isLoading ? notifier.previousPage : null,
            onNext: tabState.currentPage < totalPages && !isLoading
                ? () => notifier.nextPage(totalPages: totalPages)
                : null,
          ),
        ],
      ),
    );
  }
}

class _AdjustmentCard extends ConsumerWidget with AdjustmentsPermissionMixin {
  const _AdjustmentCard({required this.row, required this.isDark, this.enableRowSelection = false});

  final AdjustmentRowData row;
  final bool isDark;
  final bool enableRowSelection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected =
        enableRowSelection && ref.watch(bulkAdjustmentsTableSelectionProvider).contains(row.adjustmentId);
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final tileBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

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
              if (enableRowSelection) ...[
                DigifyCheckbox(
                  value: isSelected,
                  onChanged: (_) => ref.read(bulkAdjustmentsTableSelectionProvider.notifier).toggle(row),
                ),
                Gap(8.w),
              ],
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
              DigifyStatusCapsule(status: row.status.label),
            ],
          ),
          Gap(10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _LabelChip(label: 'Dept', value: row.department, isDark: isDark),
              _LabelChip(label: 'Type', value: row.adjustmentType, isDark: isDark),
            ],
          ),
          Gap(12.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            alignment: WrapAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 0.28.sw,
                child: _AmountColumn(label: 'Current Salary', value: row.currentSalary, isDark: isDark),
              ),
              SizedBox(
                width: 0.28.sw,
                child: _AmountColumn(
                  label: 'Increase',
                  value: '${row.increaseAmount} ${row.increasePercent}',
                  isDark: isDark,
                  isEmphasized: true,
                  valueColor: row.isNegativeIncrease ? AppColors.error : AppColors.success,
                ),
              ),
              SizedBox(
                width: 0.28.sw,
                child: _AmountColumn(
                  label: 'New Salary',
                  value: row.newSalary,
                  isDark: isDark,
                  isEmphasized: true,
                  valueColor: AppColors.success,
                ),
              ),
            ],
          ),
          Gap(12.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (canViewAdjustment)
                AppMobileButton.primary(
                  svgPath: Assets.icons.viewIconBlue.path,
                  onPressed: () {
                    if (context.isMobileLayout) {
                      AdjustmentDetailsMobileSheet.show(context, row: row);
                    } else {
                      AdjustmentDetailsDialog.show(context, row: row);
                    }
                  },
                ),
              if (row.isPendingApproval) ...[
                Gap(8.w),
                AppMobileButton.primary(
                  svgPath: Assets.icons.checkIconGreen.path,
                  onPressed: () async {
                    final confirmed = await AppConfirmationDialog.show(
                      context,
                      title: 'Approve Adjustment',
                      message: 'Are you sure you want to approve this adjustment?',
                      itemName: row.adjustmentId,
                      confirmLabel: 'Approve',
                      type: ConfirmationType.success,
                      svgPath: Assets.icons.checkIconGreen.path,
                    );
                    if (confirmed == true && context.mounted) {}
                  },
                ),
              ],
            ],
          ),
        ],
      ),
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
    return Wrap(
      spacing: 4.w,
      runSpacing: 4.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '$label: ',
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 11.sp,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 0.5.sw),
          child: DigifyCapsule(
            label: value,
            backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
            textColor: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _AmountColumn extends StatelessWidget {
  const _AmountColumn({
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
    final defaultColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
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
            color: valueColor ?? defaultColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
