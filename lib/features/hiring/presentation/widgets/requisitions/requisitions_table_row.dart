import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_table_width_provider.dart';
import 'package:grc/features/hiring/presentation/screens/mixins/requisitions_permission_mixin.dart';
import 'package:grc/features/hiring/presentation/screens/mixins/requisitions_actions_confirmation_mixin.dart';
import 'package:grc/features/hiring/presentation/screens/requisition_detail_page.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_table_config.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_table_types.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_priority_capsule.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/create_requisition_mobile_sheet.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/create_requisition_screen.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/core/enums/hiring_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_api_providers.dart';

class RequisitionsTableRow extends ConsumerStatefulWidget {
  const RequisitionsTableRow({super.key, required this.row, required this.isDark});

  final RequisitionTableRowData row;
  final bool isDark;

  @override
  ConsumerState<RequisitionsTableRow> createState() => _RequisitionsTableRowState();
}

class _RequisitionsTableRowState extends ConsumerState<RequisitionsTableRow>
    with RequisitionsPermissionMixin, RequisitionsActionsConfirmationMixin {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(requisitionsTableWidthsProvider);
    final primaryText = widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryText = widget.isDark ? AppColors.textSecondaryDark : AppColors.textMuted;
    final linkColor = AppColors.primary;
    final targetStart = _formatTargetStart(context);

    final dividerWidths = <double>[
      ...state.columnOrder.map(state.widthFor),
      if (RequisitionsTableConfig.showActions) RequisitionsTableConfig.actionsWidth.w,
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...state.columnOrder.map((column) {
                final cell = _buildCellForColumn(
                  context,
                  loc,
                  column,
                  primaryText: primaryText,
                  secondaryText: secondaryText,
                  linkColor: linkColor,
                  targetStart: targetStart,
                );
                return _buildDataCell(cell, state.widthFor(column));
              }),
              if (RequisitionsTableConfig.showActions) _buildActionsCell(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCellForColumn(
    BuildContext context,
    AppLocalizations loc,
    RequisitionsTableColumn column, {
    required Color primaryText,
    required Color secondaryText,
    required Color linkColor,
    required String targetStart,
  }) {
    return switch (column) {
      RequisitionsTableColumn.details => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => context.goNamed(RequisitionDetailPage.routeName, extra: widget.row),
            child: Text(widget.row.requisitionCode, style: context.textTheme.titleSmall?.copyWith(color: linkColor)),
          ),
          Gap(4.h),
          Text(widget.row.jobTitle, style: context.textTheme.titleSmall?.copyWith(color: primaryText)),
          Gap(4.h),
          if (widget.row.hasGrade || widget.row.hasEmploymentType)
            Wrap(
              spacing: 8.w,
              runSpacing: 4.h,
              children: [
                if (widget.row.hasGrade)
                  DigifySquareCapsule(
                    label: widget.row.gradeNumber,
                    backgroundColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(10.r),
                    textColor: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    borderColor: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                  ),
                if (widget.row.hasEmploymentType)
                  DigifySquareCapsule(
                    label: widget.row.employmentTypeLabel,
                    borderRadius: BorderRadius.circular(10.r),
                    backgroundColor: widget.isDark ? AppColors.grayBgDark : AppColors.infoBg,
                    textColor: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    borderColor: Colors.transparent,
                  ),
              ],
            )
          else
            Text(
              widget.row.employmentTypeLabel,
              style: context.textTheme.labelSmall?.copyWith(color: AppColors.sidebarSecondaryText, fontSize: 12.sp),
            ),
        ],
      ),
      RequisitionsTableColumn.department => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.row.department, style: context.textTheme.titleSmall?.copyWith(color: primaryText)),
          Gap(4.h),
          Text(
            widget.row.roleTitle,
            style: context.textTheme.labelSmall?.copyWith(color: AppColors.sidebarSecondaryText, fontSize: 12.sp),
          ),
          Text(
            widget.row.hasHiringManager
                ? '${loc.hiringRequisitionsHiringManagerLabel} ${widget.row.hiringManager}'
                : widget.row.hiringManager,
            style: context.textTheme.labelSmall?.copyWith(color: AppColors.sidebarSecondaryText, fontSize: 12.sp),
          ),
        ],
      ),
      RequisitionsTableColumn.location => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.row.location, style: context.textTheme.titleSmall?.copyWith(color: primaryText)),
          Gap(4.h),
          if (widget.row.hasWorkMode)
            DigifySquareCapsule(
              label: widget.row.workModeLabel,
              backgroundColor: Colors.transparent,
              borderRadius: BorderRadius.circular(10.r),
              textColor: widget.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              borderColor: widget.isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            )
          else
            Text(
              widget.row.workModeLabel,
              style: context.textTheme.labelSmall?.copyWith(color: AppColors.sidebarSecondaryText, fontSize: 12.sp),
            ),
        ],
      ),
      RequisitionsTableColumn.openings => Text(
        '${widget.row.openings}',
        style: context.textTheme.titleSmall?.copyWith(color: primaryText),
      ),
      RequisitionsTableColumn.compensation => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.row.compensationRange, style: context.textTheme.titleSmall?.copyWith(color: primaryText)),
          Text(
            widget.row.compensationTypeLabel,
            style: context.textTheme.labelSmall?.copyWith(color: AppColors.sidebarSecondaryText, fontSize: 12.sp),
          ),
        ],
      ),
      RequisitionsTableColumn.status => Align(
        alignment: Alignment.centerLeft,
        child: DigifyStatusCapsule(status: widget.row.status),
      ),
      RequisitionsTableColumn.approval => Text(
        widget.row.hasApprovalProgress
            ? '${widget.row.approvalLabel} ${loc.hiringRequisitionsApprovalsLabel}'
            : widget.row.approvalLabel,
        style: context.textTheme.labelSmall?.copyWith(color: AppColors.sidebarSecondaryText, fontSize: 12.sp),
      ),
      RequisitionsTableColumn.priority =>
        widget.row.hasPriority
            ? Align(
                alignment: Alignment.centerLeft,
                child: RequisitionsPriorityCapsule(priority: widget.row.priorityLabel),
              )
            : Text(
                widget.row.priorityLabel,
                style: context.textTheme.labelSmall?.copyWith(color: AppColors.sidebarSecondaryText, fontSize: 12.sp),
              ),
      RequisitionsTableColumn.targetStart => Text(
        targetStart,
        style: context.textTheme.bodySmall?.copyWith(color: primaryText, fontSize: 13.5.sp),
      ),
    };
  }

  Widget _buildActionsCell() {
    final loc = AppLocalizations.of(context)!;
    final isDraft = widget.row.statusEnum == RequisitionStatus.draft;
    final isPending = widget.row.statusEnum == RequisitionStatus.submitted;
    final isApproving = ref.watch(approveRequisitionActionLoadingProvider(widget.row.id));
    final isDeleting = ref.watch(deleteRequisitionActionLoadingProvider(widget.row.id));
    final isRejecting = ref.watch(rejectRequisitionActionLoadingProvider(widget.row.id));

    return SizedBox(
      width: RequisitionsTableConfig.actionsWidth.w,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8.w,
            children: [
              if (canViewRequisitions)
                ActionButtonWidget(
                  type: ActionButtonType.view,
                  onTap: () => context.goNamed(RequisitionDetailPage.routeName, extra: widget.row),
                  width: 18.w,
                  height: 18.w,
                  padding: 6.w,
                  borderRadius: BorderRadius.circular(6.r),
                  customBorder: null,
                ),
              if (canCreateRequisition)
                ActionButtonWidget(
                  icon: Assets.icons.copyGray.path,
                  color: AppColors.dashCompensation,
                  tooltip: loc.duplicate,
                  onTap: () => context.pushNamed(CreateRequisitionScreen.duplicateRouteName, extra: widget.row),
                  width: 18.w,
                  height: 18.w,
                  padding: 6.w,
                  borderRadius: BorderRadius.circular(6.r),
                  customBorder: null,
                ),
              if (canUpdateRequisition && isPending)
                ActionButtonWidget(
                  icon: Assets.icons.checkIconGreen.path,
                  color: AppColors.success,
                  tooltip: loc.approve,
                  isLoading: isApproving,
                  onTap: isApproving
                      ? null
                      : () async {
                          final confirmed = await confirmApprove(context, itemName: widget.row.requisitionCode);
                          if (confirmed != true) return;
                          if (!mounted) return;
                          await ref
                              .read(approveRequisitionControllerProvider)
                              .approve(context, requisitionGuid: widget.row.id);
                        },
                  width: 18.w,
                  height: 18.w,
                  padding: 6.w,
                  borderRadius: BorderRadius.circular(6.r),
                  customBorder: null,
                ),
              if (canUpdateRequisition && isPending)
                ActionButtonWidget(
                  icon: Assets.icons.closeIcon.path,
                  color: AppColors.deleteIconRed,
                  tooltip: loc.reject,
                  isLoading: isRejecting,
                  onTap: isRejecting
                      ? null
                      : () async {
                          final reason = await confirmReject(context, itemName: widget.row.requisitionCode);
                          if (reason == null || reason.trim().isEmpty) return;
                          if (!mounted) return;
                          await ref
                              .read(rejectRequisitionControllerProvider)
                              .reject(context, requisitionGuid: widget.row.id, rejectionReason: reason.trim());
                        },
                  width: 18.w,
                  height: 18.w,
                  padding: 6.w,
                  borderRadius: BorderRadius.circular(6.r),
                  customBorder: null,
                ),
              if (canUpdateRequisition && isDraft)
                ActionButtonWidget(
                  icon: Assets.icons.deleteIconRed.path,
                  color: AppColors.deleteIconRed,
                  tooltip: loc.delete,
                  isLoading: isDeleting,
                  onTap: isDeleting
                      ? null
                      : () async {
                          final confirmed = await confirmDeleteDraft(context, itemName: widget.row.requisitionCode);
                          if (confirmed != true) return;
                          if (!mounted) return;
                          await ref
                              .read(deleteRequisitionControllerProvider)
                              .delete(context, requisitionGuid: widget.row.id);
                        },
                  width: 18.w,
                  height: 18.w,
                  padding: 6.w,
                  borderRadius: BorderRadius.circular(6.r),
                  customBorder: null,
                ),
              if (canUpdateRequisition && isDraft)
                ActionButtonWidget(
                  type: ActionButtonType.edit,
                  onTap: () {
                    if (context.screenLayout.isMobile) {
                      CreateRequisitionMobileSheet.show(context, requisitionToEdit: widget.row);
                    } else {
                      context.pushNamed(CreateRequisitionScreen.editRouteName, extra: widget.row);
                    }
                  },
                  width: 18.w,
                  height: 18.w,
                  padding: 6.w,
                  borderRadius: BorderRadius.circular(6.r),
                  customBorder: null,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTargetStart(BuildContext context) {
    return widget.row.targetStartLabel(locale: Localizations.localeOf(context).toString());
  }

  Widget _buildDivider(double width, {required bool isLast}) {
    if (isLast) {
      return SizedBox(width: width);
    }

    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
        child: child,
      ),
    );
  }
}
