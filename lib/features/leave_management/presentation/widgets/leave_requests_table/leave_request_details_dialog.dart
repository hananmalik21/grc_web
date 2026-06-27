import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/string_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/leave_management/data/mappers/leave_type_mapper.dart';
import 'package:grc/features/leave_management/presentation/screens/leave_request_permission_mixin.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class LeaveRequestDetailsDialog {
  static Future<void> show(
    BuildContext context, {
    required TimeOffRequest request,
    String? department,
    String? position,
    VoidCallback? onApprove,
    VoidCallback? onReject,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _LeaveRequestDetailsDialogContent(
        request: request,
        department: department,
        position: position,
        onApprove: onApprove,
        onReject: onReject,
      ),
    );
  }
}

class _LeaveRequestDetailsDialogContent extends StatelessWidget with LeaveRequestPermissionMixin {
  final TimeOffRequest request;
  final String? department;
  final String? position;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const _LeaveRequestDetailsDialogContent({
    required this.request,
    this.department,
    this.position,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isPending = request.status == RequestStatus.pending;

    return AppDialog(
      title: 'Leave Request Details',
      subtitle: '${request.id}',
      width: 672.w,
      onClose: () => context.pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        spacing: 16.h,
        children: [
          Center(child: _buildStatusBadge(context, isDark)),
          _buildEmployeeInformationCard(context, isDark),
          _buildRequestSubmittedOnCard(context, isDark),
          _buildLeavePeriodDetailsCard(context, isDark),
          _buildReasonForLeaveCard(context, isDark),
        ],
      ),
      actions: _buildActions(context, isPending),
    );
  }

  Widget _buildStatusBadge(BuildContext context, bool isDark) {
    Color backgroundColor;
    Color textColor;

    switch (request.status) {
      case RequestStatus.pending:
        backgroundColor = AppColors.pendingStatusBackground;
        textColor = AppColors.pendingStatucColor;
        break;
      case RequestStatus.approved:
        backgroundColor = AppColors.holidayIslamicPaidBg;
        textColor = AppColors.holidayIslamicPaidText;
        break;
      case RequestStatus.rejected:
        backgroundColor = AppColors.errorBg;
        textColor = AppColors.errorText;
        break;
      default:
        backgroundColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey;
        textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
        break;
    }

    String label;
    switch (request.status) {
      case RequestStatus.pending:
        label = 'pending';
        break;
      case RequestStatus.approved:
        label = 'approved';
        break;
      case RequestStatus.rejected:
        label = 'rejected';
        break;
      case RequestStatus.draft:
        label = 'draft';
        break;
      case RequestStatus.cancelled:
        label = 'cancelled';
        break;
    }

    return DigifyCapsule(label: label.capitalizeFirst, backgroundColor: backgroundColor, textColor: textColor);
  }

  Widget _buildEmployeeInformationCard(BuildContext context, bool isDark) {
    final cardBg = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.sidebarMenuItemText;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Employee Information', style: context.textTheme.titleMedium?.copyWith(color: valueColor)),
          Gap(10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'Employee Name', labelColor),
                    Gap(7.h),
                    Text(
                      request.employeeName.isEmpty ? '-' : request.employeeName,
                      style: context.textTheme.titleMedium?.copyWith(color: valueColor, fontSize: 14.sp),
                    ),
                    Gap(20.h),
                    _buildLabel(context, 'Department', labelColor),
                    Gap(7.h),
                    Text(
                      department ?? '-',
                      style: context.textTheme.titleMedium?.copyWith(color: valueColor, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'Employee Number', labelColor),
                    Gap(7.h),
                    Text(
                      'EMP${request.employeeId.toString().padLeft(3, '0')}',
                      style: context.textTheme.titleMedium?.copyWith(color: valueColor, fontSize: 14.sp),
                    ),
                    Gap(20.h),
                    _buildLabel(context, 'Position', labelColor),
                    Gap(7.h),
                    Text(
                      position ?? '-',
                      style: context.textTheme.titleMedium?.copyWith(color: valueColor, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text, Color color) {
    return Text(
      text,
      style: context.textTheme.titleMedium?.copyWith(color: color, fontSize: 12.sp),
    );
  }

  Widget _buildRequestSubmittedOnCard(BuildContext context, bool isDark) {
    final submittedAt = request.requestedAt;
    final dateStr = submittedAt != null ? DateFormat('EEEE, d MMMM yyyy').format(submittedAt) : '-';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(17.sp),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.permissionBadgeBorder, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLabel(
                  context,
                  'Request Submitted On',
                  isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                Gap(7.h),
                Text(
                  dateStr,
                  style: context.textTheme.titleMedium?.copyWith(color: AppColors.infoTextSecondary, fontSize: 15.sp),
                ),
              ],
            ),
          ),
          DigifyAsset(
            assetPath: Assets.icons.leaveManagementIcon.path,
            width: 35.w,
            height: 35.h,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLeavePeriodDetailsCard(BuildContext context, bool isDark) {
    final cardBg = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final leaveTypeLabel = request.leaveTypeInfo?.leaveNameEn ?? LeaveTypeMapper.getShortLabel(request.type);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Leave Period Details', style: context.textTheme.titleMedium?.copyWith(color: valueColor)),
          Gap(10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'Leave Type', labelColor),
                    Gap(7.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.infoBg,
                        borderRadius: BorderRadius.circular(6.r),
                        border: Border.all(color: AppColors.infoBorder, width: 1),
                      ),
                      child: Text(
                        leaveTypeLabel,
                        style: context.textTheme.titleMedium?.copyWith(color: valueColor, fontSize: 14.sp),
                      ),
                    ),
                    Gap(17.h),
                    _buildLabel(context, 'Start Date', labelColor),
                    Gap(7.h),
                    Text(
                      DateFormat('EEE, d MMM yyyy').format(request.startDate),
                      style: context.textTheme.titleMedium?.copyWith(color: valueColor, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildLabel(context, 'Total Duration', labelColor),
                    Gap(7.h),
                    Text(
                      '${request.totalDays.toInt()} days',
                      style: context.textTheme.titleMedium?.copyWith(color: valueColor, fontSize: 14.sp),
                    ),
                    Gap(27.h),
                    _buildLabel(context, 'End Date', labelColor),
                    Gap(7.h),
                    Text(
                      DateFormat('EEE, d MMM yyyy').format(request.endDate),
                      style: context.textTheme.titleMedium?.copyWith(color: valueColor, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReasonForLeaveCard(BuildContext context, bool isDark) {
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, 'Reason for Leave', labelColor),
        Gap(10.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: isDark ? AppColors.inputBgDark : AppColors.tableHeaderBackground,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.cardBorder, width: 1),
          ),
          child: Text(
            request.reason.isEmpty ? '-' : request.reason,
            style: context.textTheme.bodyMedium?.copyWith(color: valueColor),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context, bool isPending) {
    final closeButton = AppButton.outline(label: 'Close', onPressed: () => context.pop());

    if (!isPending) {
      return [closeButton];
    }

    return [
      closeButton,
      if (canApproveLeaveRequest) ...[
        Gap(8.w),
        AppButton.danger(
          label: 'Reject',
          onPressed: () {
            context.pop();
            onReject?.call();
          },
        ),
        Gap(8.w),
        AppButton(
          label: 'Approve',
          type: AppButtonType.primary,
          backgroundColor: AppColors.success,
          onPressed: () {
            context.pop();
            onApprove?.call();
          },
        ),
      ],
    ];
  }
}
