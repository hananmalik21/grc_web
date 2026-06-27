import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_table_selection_provider.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/compensation/presentation/models/adjustments/adjustment_row_data.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_table_width_provider.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_permission_mixin.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustment_details_dialog.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_table_layout_config.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_table_types.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AdjustmentsTableRow extends ConsumerWidget with AdjustmentsPermissionMixin {
  final AdjustmentRowData row;
  final bool isDark;
  final double widthMultiplier;
  final bool enableRowSelection;

  const AdjustmentsTableRow({
    super.key,
    required this.row,
    required this.isDark,
    this.widthMultiplier = 1,
    this.enableRowSelection = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(adjustmentsTableWidthsProvider);
    final isSelected =
        enableRowSelection && ref.watch(bulkAdjustmentsTableSelectionProvider).contains(row.adjustmentId);

    final dividerWidths = <double>[
      ...state.columnOrder.map((column) => state.widthFor(column) * widthMultiplier),
      if (AdjustmentsTableLayoutConfig.showActions) AdjustmentsTableLayoutConfig.actionsWidth * widthMultiplier,
    ];

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                for (var i = 0; i < dividerWidths.length; i++)
                  _buildDivider(dividerWidths[i], isLast: i == dividerWidths.length - 1),
              ],
            ),
          ),
          Row(
            children: [
              ...state.columnOrder.map((column) {
                final cell = _buildCellByColumn(context, ref, column, isSelected);
                return _buildDataCell(cell, state.widthFor(column) * widthMultiplier);
              }),
              if (AdjustmentsTableLayoutConfig.showActions)
                _buildDataCell(_buildActionsCell(context), AdjustmentsTableLayoutConfig.actionsWidth * widthMultiplier),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCellByColumn(BuildContext context, WidgetRef ref, AdjustmentsTableColumn column, bool isSelected) {
    switch (column) {
      case AdjustmentsTableColumn.employee:
        final employeeDetails = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              row.employeeName,
              style: context.textTheme.labelMedium?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            Gap(4.h),
            Text(
              row.employeeId,
              style: context.textTheme.labelSmall?.copyWith(
                fontSize: 12.sp,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          ],
        );

        if (!enableRowSelection) return employeeDetails;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyCheckbox(
              value: isSelected,
              onChanged: (_) => ref.read(bulkAdjustmentsTableSelectionProvider.notifier).toggle(row),
            ),
            Gap(10.w),
            Expanded(child: employeeDetails),
          ],
        );
      case AdjustmentsTableColumn.department:
        return _BodyText(label: row.department);
      case AdjustmentsTableColumn.adjustmentType:
        return _BodyText(label: row.adjustmentType);
      case AdjustmentsTableColumn.currentSalary:
        return _BodyText(label: row.currentSalary);
      case AdjustmentsTableColumn.adjustmentMethod:
        return _BodyText(label: row.adjustmentMethod);
      case AdjustmentsTableColumn.adjustmentValue:
        return _BodyText(label: row.adjustmentValue, isEmphasized: true);
      case AdjustmentsTableColumn.newSalary:
        return _BodyText(label: row.newSalary, color: AppColors.success, isEmphasized: true);
      case AdjustmentsTableColumn.increase:
        final increaseColor = row.isNegativeIncrease ? AppColors.error : AppColors.success;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              row.increaseAmount,
              style: context.textTheme.bodySmall?.copyWith(fontSize: 14.sp, color: increaseColor),
            ),
            Gap(2.h),
            Text(
              row.increasePercent,
              style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: increaseColor),
            ),
          ],
        );
      case AdjustmentsTableColumn.effectiveDate:
        return _DateCell(dateText: row.effectiveDate);
      case AdjustmentsTableColumn.reason:
        return _ReasonCapsule(reasonCode: row.reasonCode);
      case AdjustmentsTableColumn.status:
        return _StatusCapsule(status: row.status);
    }
  }

  Widget _buildDivider(double width, {required bool isLast}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                right: BorderSide(color: AppColors.cardBorder, width: 1.w),
              ),
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 22.w, vertical: 18.h),
        child: child,
      ),
    );
  }

  Widget _buildActionsCell(BuildContext context) {
    final isPendingApproval = row.isPendingApproval;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (canViewAdjustment)
          ActionButtonWidget(
            type: ActionButtonType.view,
            onTap: () => AdjustmentDetailsDialog.show(context, row: row),
            width: 18.w,
            height: 18.w,
            padding: 6.w,
            borderRadius: BorderRadius.circular(6.r),
            customBorder: null,
          ),
        if (isPendingApproval) ...[
          Gap(8.w),
          DigifyAssetButton(
            assetPath: Assets.icons.checkIconGreen.path,
            onTap: () async {
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
            width: 19.w,
            height: 19.h,
            color: AppColors.success,
          ),
          Gap(8.w),
          DigifyAssetButton(
            assetPath: Assets.icons.closeIcon.path,
            onTap: () async {
              final confirmed = await AppConfirmationDialog.show(
                context,
                title: 'Reject Adjustment',
                message: 'Are you sure you want to reject this adjustment?',
                itemName: row.adjustmentId,
                confirmLabel: 'Reject',
                type: ConfirmationType.danger,
                svgPath: Assets.icons.closeIcon.path,
              );

              if (confirmed == true && context.mounted) {}
            },
            width: 19.w,
            height: 19.h,
            color: AppColors.error,
          ),
        ],
      ],
    );
  }
}

class _BodyText extends StatelessWidget {
  final String label;
  final Color? color;
  final bool isEmphasized;

  const _BodyText({required this.label, this.color, this.isEmphasized = false});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Text(
      label,
      style: context.textTheme.bodySmall?.copyWith(
        fontSize: 14.sp,
        fontWeight: isEmphasized ? FontWeight.w600 : FontWeight.w400,
        color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
      ),
    );
  }
}

class _DateCell extends StatelessWidget {
  final String dateText;

  const _DateCell({required this.dateText});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Text(
      dateText,
      style: context.textTheme.bodySmall?.copyWith(
        fontSize: 14.sp,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
    );
  }
}

class _ReasonCapsule extends StatelessWidget {
  final String reasonCode;

  const _ReasonCapsule({required this.reasonCode});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: DigifyCapsule(
        label: reasonCode,
        backgroundColor: context.isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
        textColor: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      ),
    );
  }
}

class _StatusCapsule extends StatelessWidget {
  final AdjustmentStatus status;

  const _StatusCapsule({required this.status});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: DigifyStatusCapsule(status: status.label),
    );
  }
}
