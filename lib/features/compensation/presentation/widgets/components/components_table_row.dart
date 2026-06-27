import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/components_permission_mixin.dart';
import 'package:go_router/go_router.dart';
import 'package:grc/features/compensation/presentation/screens/components_tab/component_update.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../models/component_table_row_data.dart';
import '../../providers/components_table_rows_provider.dart';
import '../../providers/components_table_width_provider.dart';
import 'components_table_config.dart';
import 'components_table_types.dart';

class ComponentsTableRow extends ConsumerStatefulWidget with ComponentsPermissionMixin {
  final ComponentTableRowData row;
  final bool isDark;

  const ComponentsTableRow({super.key, required this.row, required this.isDark});

  @override
  ConsumerState<ComponentsTableRow> createState() => _ComponentsTableRowState();
}

class _ComponentsTableRowState extends ConsumerState<ComponentsTableRow> with ComponentsPermissionMixin {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(componentsTableWidthsProvider);
    final deletingGuid = ref.watch(componentsDeletionControllerProvider);
    final isDeleting = deletingGuid == widget.row.component?.componentGuid;

    final textStyle = context.textTheme.labelMedium?.copyWith(
      fontSize: 14.sp,
      color: widget.isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
    );

    final dividerWidths = <double>[
      ...state.columnOrder.map(state.widthFor),
      if (ComponentsTableConfig.showActions) ComponentsTableConfig.actionsWidth.w,
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
                  ComponentsTableColumn.component => Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.row.name, style: textStyle, overflow: TextOverflow.ellipsis),
                            Text(
                              widget.row.code,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.labelSmall?.copyWith(
                                color: widget.isDark ? AppColors.textTertiaryDark : AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  ComponentsTableColumn.category => Align(
                    alignment: Alignment.centerLeft,
                    child: DigifyCapsule(
                      label: widget.row.category,
                      textColor: AppColors.primary,
                      backgroundColor: AppColors.infoBg,
                    ),
                  ),
                  ComponentsTableColumn.calculation => Text(
                    widget.row.calculation,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: widget.isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
                    ),
                  ),
                  ComponentsTableColumn.status => Align(
                    alignment: Alignment.centerLeft,
                    child: DigifyStatusCapsule(status: widget.row.status),
                  ),
                  ComponentsTableColumn.payroll => Row(
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: widget.row.payroll != 'Not Mapped' ? AppColors.success : AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Gap(6.w),
                      Text(
                        widget.row.payroll,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: widget.row.payroll != 'Not Mapped' ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  ComponentsTableColumn.usedIn => Row(
                    children: [
                      DigifyAsset(
                        assetPath: Assets.icons.employeeSelfService.learning.path,
                        color: widget.isDark ? AppColors.textTertiaryDark : AppColors.grayBorderDark,
                        width: 14.w,
                        height: 14.w,
                      ),
                      Gap(6.w),
                      Text(
                        '${widget.row.usedInPlans} plans',
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: widget.isDark ? AppColors.textSecondaryDark : AppColors.grayBorderDark,
                        ),
                      ),
                    ],
                  ),
                };

                return _buildDataCell(cell, state.widthFor(column));
              }),
              if (ComponentsTableConfig.showActions)
                _buildDataCell(
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8.w,
                    children: [
                      if (canViewComponent)
                        DigifyAssetButton(
                          width: 17.w,
                          height: 17.w,
                          assetPath: Assets.icons.viewIconBlue.path,
                          onTap: isDeleting ? null : () {},
                          color: AppColors.viewIconBlue,
                        ),
                      if (canUpdateComponent)
                        DigifyAssetButton(
                          assetPath: Assets.icons.editIcon.path,
                          onTap: isDeleting || widget.row.component == null
                              ? null
                              : () async {
                                  final updated = await context.pushNamed<bool>(
                                    ComponentUpdateScreen.routeName,
                                    extra: widget.row.component,
                                  );
                                  if (updated == true && context.mounted) {
                                    ref.read(componentsTabRefreshTickProvider.notifier).state++;
                                  }
                                },
                          width: 17.w,
                          height: 17.w,
                          color: AppColors.success,
                        ),
                      // DigifyAssetButton(
                      //   assetPath: Assets.icons.duplicateIcon.path,
                      //   onTap: isDeleting ? null : () {},
                      //   width: 17.w,
                      //   height: 17.h,
                      //   color: AppColors.warning,
                      // ),
                      if (canDeleteComponent)
                        DigifyAssetButton(
                          assetPath: Assets.icons.deleteIconRed.path,
                          isLoading: isDeleting,
                          onTap: () => _showDeleteConfirmation(context),
                          width: 17.w,
                          height: 17.w,
                          color: AppColors.error,
                        ),
                    ],
                  ),
                  ComponentsTableConfig.actionsWidth.w,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final componentGuid = widget.row.component?.componentGuid;
    if (componentGuid == null) return;

    final result = await AppConfirmationDialog.show(
      context,
      title: 'Delete Component',
      message: 'Are you sure you want to delete this component?',
      itemName: widget.row.name,
      confirmLabel: 'Delete',
      type: ConfirmationType.danger,
    );

    if (result == true && context.mounted) {
      try {
        await ref.read(componentsDeletionControllerProvider.notifier).deleteComponent(componentGuid: componentGuid);
        if (context.mounted) {
          ToastService.show(context: context, message: 'Component deleted successfully', type: ToastType.success);
        }
      } catch (e) {
        if (context.mounted) {
          ToastService.show(
            context: context,
            message: 'Failed to delete component: ${e.toString()}',
            type: ToastType.error,
          );
        }
      }
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
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.w),
        child: child,
      ),
    );
  }
}
