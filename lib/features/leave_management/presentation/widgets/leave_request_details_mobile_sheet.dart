import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/leave_management/data/mappers/leave_type_mapper.dart';
import 'package:grc/features/leave_management/presentation/screens/leave_request_permission_mixin.dart';
import 'package:grc/features/leave_management/presentation/mixins/leave_requests_list_logic_mixin.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

/// Bottom sheet for viewing leave request details on mobile.
class LeaveRequestDetailsMobileSheet {
  LeaveRequestDetailsMobileSheet._();

  static Future<void> show(
    BuildContext context, {
    required TimeOffRequest request,
    String? department,
    String? position,
    VoidCallback? onApprove,
    VoidCallback? onReject,
  }) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Leave Request #${request.id}',
      child: _LeaveRequestDetailsSheetContent(
        request: request,
        department: department,
        position: position,
        onApprove: onApprove,
        onReject: onReject,
      ),
    );
  }
}

class _LeaveRequestDetailsSheetContent extends StatelessWidget with LeaveRequestPermissionMixin {
  const _LeaveRequestDetailsSheetContent({
    required this.request,
    this.department,
    this.position,
    this.onApprove,
    this.onReject,
  });

  final TimeOffRequest request;
  final String? department;
  final String? position;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isPending = request.status == RequestStatus.pending;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 4.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: _StatusBadge(request: request, isDark: isDark),
                ),
                Gap(16.h),
                _EmployeeInfoCard(request: request, department: department, position: position, isDark: isDark),
                Gap(12.h),
                _SubmittedOnCard(request: request, isDark: isDark),
                Gap(12.h),
                _LeavePeriodCard(request: request, isDark: isDark),
                Gap(12.h),
                _ReasonCard(request: request, isDark: isDark),
              ],
            ),
          ),
        ),
        if (isPending && canApproveLeaveRequest) ...[
          const DigifyDivider.horizontal(),
          _ActionFooter(onApprove: onApprove, onReject: onReject),
        ] else ...[
          const DigifyDivider.horizontal(),
          _CloseFooter(),
        ],
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget with LeaveRequestsListLogicMixin {
  const _StatusBadge({required this.request, required this.isDark});

  final TimeOffRequest request;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return DigifyStatusCapsule(status: getStatusLabel(request.status));
  }
}

class _EmployeeInfoCard extends StatelessWidget {
  const _EmployeeInfoCard({required this.request, required this.isDark, this.department, this.position});

  final TimeOffRequest request;
  final bool isDark;
  final String? department;
  final String? position;

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.sidebarMenuItemText;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return _InfoSection(
      title: 'Employee Information',
      isDark: isDark,
      cardBg: cardBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Employee Name', labelColor, context),
          Gap(6.h),
          _fieldValue(request.employeeName.isEmpty ? '-' : request.employeeName, valueColor, context),
          Gap(14.h),
          _fieldLabel('Employee Number', labelColor, context),
          Gap(6.h),
          _fieldValue('EMP${request.employeeId.toString().padLeft(3, '0')}', valueColor, context),
          Gap(14.h),
          _fieldLabel('Department', labelColor, context),
          Gap(6.h),
          _fieldValue(department ?? '-', valueColor, context),
          Gap(14.h),
          _fieldLabel('Position', labelColor, context),
          Gap(6.h),
          _fieldValue(position ?? '-', valueColor, context),
        ],
      ),
    );
  }
}

class _SubmittedOnCard extends StatelessWidget {
  const _SubmittedOnCard({required this.request, required this.isDark});

  final TimeOffRequest request;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final submittedAt = request.requestedAt;
    final dateStr = submittedAt != null ? DateFormat('EEEE, d MMMM yyyy').format(submittedAt) : '-';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
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
              children: [
                Text(
                  'Request Submitted On',
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    fontSize: 11.sp,
                  ),
                ),
                Gap(6.h),
                Text(
                  dateStr,
                  style: context.textTheme.titleSmall?.copyWith(color: AppColors.infoTextSecondary, fontSize: 13.sp),
                ),
              ],
            ),
          ),
          DigifyAsset(
            assetPath: Assets.icons.leaveManagementIcon.path,
            width: 30.w,
            height: 30.h,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _LeavePeriodCard extends StatelessWidget {
  const _LeavePeriodCard({required this.request, required this.isDark});

  final TimeOffRequest request;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final cardBg = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final leaveTypeLabel = request.leaveTypeInfo?.leaveNameEn ?? LeaveTypeMapper.getShortLabel(request.type);

    return _InfoSection(
      title: 'Leave Period Details',
      isDark: isDark,
      cardBg: cardBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldLabel('Leave Type', labelColor, context),
          Gap(6.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.infoBg,
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: AppColors.infoBorder, width: 1),
            ),
            child: Text(
              leaveTypeLabel,
              style: context.textTheme.bodySmall?.copyWith(color: valueColor, fontSize: 12.sp),
            ),
          ),
          Gap(14.h),
          _fieldLabel('Total Duration', labelColor, context),
          Gap(6.h),
          _fieldValue('${request.totalDays.toInt()} days', valueColor, context),
          Gap(14.h),
          _fieldLabel('Start Date', labelColor, context),
          Gap(6.h),
          _fieldValue(DateFormat('EEE, d MMM yyyy').format(request.startDate), valueColor, context),
          Gap(14.h),
          _fieldLabel('End Date', labelColor, context),
          Gap(6.h),
          _fieldValue(DateFormat('EEE, d MMM yyyy').format(request.endDate), valueColor, context),
        ],
      ),
    );
  }
}

class _ReasonCard extends StatelessWidget {
  const _ReasonCard({required this.request, required this.isDark});

  final TimeOffRequest request;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason for Leave',
          style: context.textTheme.bodySmall?.copyWith(color: labelColor, fontSize: 12.sp),
        ),
        Gap(8.h),
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
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.title, required this.isDark, required this.cardBg, required this.child});

  final String title;
  final bool isDark;
  final Color cardBg;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(color: valueColor, fontWeight: FontWeight.w600),
          ),
          Gap(12.h),
          child,
        ],
      ),
    );
  }
}

class _ActionFooter extends StatelessWidget {
  const _ActionFooter({this.onApprove, this.onReject});

  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
      child: Row(
        children: [
          Expanded(
            child: AppButton.danger(
              label: 'Reject',
              onPressed: () {
                Navigator.of(context).pop();
                onReject?.call();
              },
              height: 46,
            ),
          ),
          Gap(8.w),
          Expanded(
            child: AppButton(
              label: 'Approve',
              type: AppButtonType.primary,
              backgroundColor: AppColors.success,
              onPressed: () {
                Navigator.of(context).pop();
                onApprove?.call();
              },
              height: 46,
            ),
          ),
        ],
      ),
    );
  }
}

class _CloseFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
      child: SizedBox(
        width: double.infinity,
        child: AppButton.outline(label: 'Close', onPressed: () => Navigator.of(context).pop(), height: 46),
      ),
    );
  }
}

Widget _fieldLabel(String text, Color color, BuildContext context) {
  return Text(
    text,
    style: context.textTheme.bodySmall?.copyWith(color: color, fontSize: 11.sp),
  );
}

Widget _fieldValue(String text, Color color, BuildContext context) {
  return Text(
    text,
    style: context.textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w500, fontSize: 13.sp),
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
  );
}
