import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/leave_management/data/config/leave_requests_table_config.dart';
import 'package:grc/features/leave_management/data/mappers/leave_type_mapper.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_requests_table_width_provider.dart';
import 'package:grc/features/leave_management/presentation/screens/leave_request_permission_mixin.dart';
import 'package:grc/features/leave_management/presentation/mixins/leave_requests_list_logic_mixin.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class LeaveRequestsTableRow extends ConsumerWidget with LeaveRequestPermissionMixin, LeaveRequestsListLogicMixin {
  final TimeOffRequest request;
  final AppLocalizations localizations;
  final bool isDark;
  final bool isApproveLoading;
  final bool isRejectLoading;
  final bool isDeleteLoading;
  final VoidCallback? onView;
  final VoidCallback? onViewEmployeeHistory;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onDelete;
  final VoidCallback? onUpdate;

  const LeaveRequestsTableRow({
    super.key,
    required this.request,
    required this.localizations,
    required this.isDark,
    this.isApproveLoading = false,
    this.isRejectLoading = false,
    this.isDeleteLoading = false,
    this.onView,
    this.onViewEmployeeHistory,
    this.onApprove,
    this.onReject,
    this.onDelete,
    this.onUpdate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle);
    final widths = ref.watch(leaveRequestsTableWidthsProvider);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              children: [
                if (LeaveRequestsTableConfig.showLeaveNumber) _buildDivider(widths.leaveNumber, isDark),
                if (LeaveRequestsTableConfig.showEmployeeNumber) _buildDivider(widths.employeeNumber, isDark),
                if (LeaveRequestsTableConfig.showEmployee) _buildDivider(widths.employee, isDark),
                if (LeaveRequestsTableConfig.showDepartment) _buildDivider(widths.department, isDark),
                if (LeaveRequestsTableConfig.showPosition) _buildDivider(widths.position, isDark),
                if (LeaveRequestsTableConfig.showLeaveType) _buildDivider(widths.leaveType, isDark),
                if (LeaveRequestsTableConfig.showStartDate) _buildDivider(widths.startDate, isDark),
                if (LeaveRequestsTableConfig.showEndDate) _buildDivider(widths.endDate, isDark),
                if (LeaveRequestsTableConfig.showDays) _buildDivider(widths.days, isDark),
                if (LeaveRequestsTableConfig.showReason) _buildDivider(widths.reason, isDark),
                if (LeaveRequestsTableConfig.showStatus) _buildDivider(widths.status, isDark),
                if (LeaveRequestsTableConfig.showActions) _buildDivider(widths.actions, isDark, isLast: true),
              ],
            ),
          ),
          Row(
            children: [
              if (LeaveRequestsTableConfig.showLeaveNumber)
                _buildDataCell(_buildClickableText(context, request.id.toString(), onView), widths.leaveNumber),
              if (LeaveRequestsTableConfig.showEmployeeNumber)
                _buildDataCell(
                  _buildClickableText(context, 'EMP${request.employeeId.toString().padLeft(3, '0')}', onView),
                  widths.employeeNumber,
                ),
              if (LeaveRequestsTableConfig.showEmployee)
                _buildDataCell(
                  _buildClickableText(
                    context,
                    request.employeeName.isEmpty ? '-' : request.employeeName,
                    onViewEmployeeHistory ?? onView,
                  ),
                  widths.employee,
                ),
              if (LeaveRequestsTableConfig.showDepartment)
                _buildDataCell(Text(request.department ?? '-', style: textStyle), widths.department),
              if (LeaveRequestsTableConfig.showPosition)
                _buildDataCell(Text(request.position ?? '-', style: textStyle), widths.position),
              if (LeaveRequestsTableConfig.showLeaveType) _buildDataCell(_buildTypeCell(context), widths.leaveType),
              if (LeaveRequestsTableConfig.showStartDate)
                _buildDataCell(
                  Text(DateFormat('MM/dd/yyyy').format(request.startDate), style: textStyle),
                  widths.startDate,
                ),
              if (LeaveRequestsTableConfig.showEndDate)
                _buildDataCell(
                  Text(DateFormat('MM/dd/yyyy').format(request.endDate), style: textStyle),
                  widths.endDate,
                ),
              if (LeaveRequestsTableConfig.showDays)
                _buildDataCell(
                  Text(
                    request.totalDays.toInt().toString(),
                    style: textStyle?.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  widths.days,
                ),
              if (LeaveRequestsTableConfig.showReason)
                _buildDataCell(Text(request.reason, style: textStyle), widths.reason),
              if (LeaveRequestsTableConfig.showStatus) _buildDataCell(_buildStatusCell(context), widths.status),
              if (LeaveRequestsTableConfig.showActions) _buildDataCell(_buildActionsCell(), widths.actions),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
      child: child,
    );
  }

  Widget _buildDivider(double width, bool isDark, {bool isLast = false}) {
    if (isLast) return SizedBox(width: width);
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1.w),
        ),
      ),
    );
  }

  Widget _buildClickableText(BuildContext context, String text, VoidCallback? onTap) {
    if (onTap == null) {
      return Text(
        text,
        style: context.textTheme.labelMedium?.copyWith(
          fontSize: 14.sp,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.r),
      child: Text(
        text,
        style: context.textTheme.labelMedium?.copyWith(
          fontSize: 14.sp,
          color: AppColors.primary,
          decoration: TextDecoration.none,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildTypeCell(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Text(
        request.leaveTypeInfo?.leaveNameEn ?? LeaveTypeMapper.getShortLabel(request.type),
        style: context.textTheme.bodyLarge?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.lightDark),
      ),
    );
  }

  Widget _buildStatusCell(BuildContext context) {
    return DigifyStatusCapsule(status: getStatusLabel(request.status));
  }

  Widget _buildActionsCell() {
    if (request.status == RequestStatus.pending) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canViewLeaveRequest)
            ActionButtonWidget(
              type: ActionButtonType.view,
              onTap: onView,
              width: 17.w,
              height: 17.w,
              padding: 5.w,
              borderRadius: BorderRadius.circular(6.r),
              customBorder: null,
            ),
          if (canApproveLeaveRequest) ...[
            Gap(8.w),
            ActionButtonWidget(
              icon: Assets.icons.checkIconGreen.path,
              color: AppColors.success,
              tooltip: 'Approve',
              onTap: onApprove,
              width: 17.w,
              height: 17.w,
              padding: 5.w,
              borderRadius: BorderRadius.circular(6.r),
              customBorder: null,
              isLoading: isApproveLoading,
            ),
            Gap(8.w),
            ActionButtonWidget(
              icon: Assets.icons.closeIcon.path,
              color: AppColors.error,
              tooltip: 'Reject',
              onTap: onReject,
              width: 17.w,
              height: 17.w,
              padding: 5.w,
              borderRadius: BorderRadius.circular(6.r),
              customBorder: null,
              isLoading: isRejectLoading,
            ),
          ],
        ],
      );
    }

    if (request.status == RequestStatus.draft) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canUpdateLeaveRequest)
            ActionButtonWidget(
              type: ActionButtonType.edit,
              onTap: onUpdate,
              width: 17.w,
              height: 17.w,
              padding: 5.w,
              borderRadius: BorderRadius.circular(6.r),
              customBorder: null,
            ),
          if (canDeleteLeaveRequest) ...[
            Gap(8.w),
            ActionButtonWidget(
              type: ActionButtonType.delete,
              onTap: onDelete,
              width: 17.w,
              height: 17.w,
              padding: 5.w,
              borderRadius: BorderRadius.circular(6.r),
              customBorder: null,
              isLoading: isDeleteLoading,
            ),
          ],
        ],
      );
    }

    // Approved / Rejected / Cancelled: show only view icon
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (canViewLeaveRequest)
          ActionButtonWidget(
            type: ActionButtonType.view,
            onTap: onView,
            width: 17.w,
            height: 17.w,
            padding: 5.w,
            borderRadius: BorderRadius.circular(6.r),
            customBorder: null,
          ),
      ],
    );
  }
}
