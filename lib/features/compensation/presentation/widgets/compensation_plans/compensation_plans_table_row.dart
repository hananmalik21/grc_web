import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/compensation_plans_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../models/compensation_plan_table_row_data.dart';
import '../../providers/compensation_plans/compensation_plans_table_width_provider.dart';
import '../../providers/compensation_plans/compensation_plans_table_rows_provider.dart';
import '../../screens/compensation_plans_tab/compensation_plan_detail_screen.dart';
import '../../screens/compensation_plans_tab/edit_compensation_plan_screen.dart';
import 'compensation_plans_table_config.dart';
import 'compensation_plans_table_types.dart';

class CompensationPlansTableRow extends ConsumerStatefulWidget {
  final CompensationPlanTableRowData row;
  final bool isDark;
  final double widthMultiplier;

  const CompensationPlansTableRow({super.key, required this.row, required this.isDark, this.widthMultiplier = 1});

  @override
  ConsumerState<CompensationPlansTableRow> createState() => _CompensationPlansTableRowState();
}

class _CompensationPlansTableRowState extends ConsumerState<CompensationPlansTableRow>
    with CompensationPlansPermissionMixin {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(compensationPlansTableWidthsProvider);
    final deletingPlanGuid = ref.watch(compensationPlansDeletionControllerProvider);
    final isDeleting = deletingPlanGuid == widget.row.planGuid;

    final dividerWidths = <double>[
      ...state.columnOrder.map((column) => state.widthFor(column) * widget.widthMultiplier),
      if (CompensationPlansTableConfig.showActions) CompensationPlansTableConfig.actionsWidth * widget.widthMultiplier,
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
                final cell = switch (column) {
                  CompensationPlansTableColumn.planName => Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.row.name,
                          style: context.textTheme.labelMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  CompensationPlansTableColumn.planCode => Align(
                    alignment: Alignment.centerLeft,
                    child: DigifySquareCapsule(
                      label: widget.row.code,
                      backgroundColor: widget.isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
                      textColor: widget.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      borderColor: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                    ),
                  ),
                  CompensationPlansTableColumn.planType => Align(
                    alignment: Alignment.centerLeft,
                    child: DigifyCapsule(
                      label: widget.row.type,
                      textColor: AppColors.primary,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                    ),
                  ),
                  CompensationPlansTableColumn.status => Align(
                    alignment: Alignment.centerLeft,
                    child: DigifyStatusCapsule(status: widget.row.status),
                  ),
                  CompensationPlansTableColumn.currency => Text(
                    widget.row.currency,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
                    ),
                  ),
                };

                return _buildDataCell(cell, state.widthFor(column) * widget.widthMultiplier);
              }),
              if (CompensationPlansTableConfig.showActions)
                _buildDataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8.w,
                    children: [
                      if (canViewCompensationPlan)
                        ActionButtonWidget(
                          type: ActionButtonType.view,
                          onTap: isDeleting
                              ? null
                              : () => context.pushNamed(CompensationPlanDetailScreen.routeName, extra: widget.row),
                          width: 18.w,
                          height: 18.w,
                          padding: 6.w,
                          borderRadius: BorderRadius.circular(6.r),
                          customBorder: null,
                        ),
                      if (canUpdateCompensationPlan)
                        ActionButtonWidget(
                          type: ActionButtonType.edit,
                          onTap: isDeleting
                              ? null
                              : () => context.pushNamed(
                                  EditCompensationPlanScreen.routeName,
                                  pathParameters: {'planGuid': widget.row.planGuid},
                                ),
                          width: 18.w,
                          height: 18.w,
                          padding: 6.w,
                          borderRadius: BorderRadius.circular(6.r),
                          customBorder: null,
                        ),
                      if (canDeleteCompensationPlan)
                        ActionButtonWidget(
                          type: ActionButtonType.delete,
                          onTap: () => _showDeleteConfirmation(context, ref, widget.row.name),
                          isLoading: isDeleting,
                          width: 18.w,
                          height: 18.w,
                          padding: 6.w,
                          borderRadius: BorderRadius.circular(6.r),
                          customBorder: null,
                        ),
                    ],
                  ),
                  CompensationPlansTableConfig.actionsWidth * widget.widthMultiplier,
                ),
            ],
          ),
        ],
      ),
    );
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
        padding: EdgeInsetsDirectional.symmetric(horizontal: 22.w, vertical: 18.w),
        child: child,
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, WidgetRef ref, String planName) async {
    final result = await AppConfirmationDialog.show(
      context,
      title: 'Delete Compensation Plan',
      message: 'Are you sure you want to delete this compensation plan?',
      itemName: planName,
      confirmLabel: 'Delete',
      type: ConfirmationType.danger,
    );

    if (result == true && context.mounted) {
      try {
        await ref
            .read(compensationPlansDeletionControllerProvider.notifier)
            .deleteCompensationPlan(planGuid: widget.row.planGuid);

        if (context.mounted) {
          ToastService.show(
            context: context,
            message: 'Compensation plan deleted successfully',
            type: ToastType.success,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ToastService.show(
            context: context,
            message: 'Failed to delete compensation plan: ${e.toString()}',
            type: ToastType.error,
          );
        }
      }
    }
  }
}
