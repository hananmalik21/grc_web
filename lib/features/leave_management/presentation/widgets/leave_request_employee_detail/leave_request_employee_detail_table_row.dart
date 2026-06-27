import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/string_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/leave_management/data/config/leave_request_employee_detail_table_config.dart';
import 'package:grc/features/leave_management/data/mappers/leave_type_mapper.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class LeaveRequestEmployeeDetailTableRow extends StatelessWidget {
  const LeaveRequestEmployeeDetailTableRow({
    super.key,
    required this.request,
    required this.localizations,
    required this.isDark,
    this.onView,
  });

  final TimeOffRequest request;
  final AppLocalizations localizations;
  final bool isDark;
  final VoidCallback? onView;

  static final DateFormat _dateFormat = DateFormat('MM/dd/yyyy');

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Row(
        children: [
          if (LeaveRequestEmployeeDetailTableConfig.showLeaveNumber)
            _buildDataCell(
              _buildClickableText(context, request.id.toString(), onView),
              LeaveRequestEmployeeDetailTableConfig.leaveNumberWidth.w,
            ),
          if (LeaveRequestEmployeeDetailTableConfig.showLeaveType)
            _buildDataCell(_buildTypeCell(context), LeaveRequestEmployeeDetailTableConfig.leaveTypeWidth.w),
          if (LeaveRequestEmployeeDetailTableConfig.showDepartment)
            _buildDataCell(
              Text(
                request.department ?? '-',
                style: context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: primaryTextColor),
              ),
              LeaveRequestEmployeeDetailTableConfig.departmentWidth.w,
            ),
          if (LeaveRequestEmployeeDetailTableConfig.showPosition)
            _buildDataCell(
              Text(
                request.position ?? '-',
                style: context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: primaryTextColor),
              ),
              LeaveRequestEmployeeDetailTableConfig.positionWidth.w,
            ),
          if (LeaveRequestEmployeeDetailTableConfig.showStartDate)
            _buildDataCell(
              Text(
                _dateFormat.format(request.startDate),
                style: context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: primaryTextColor),
              ),
              LeaveRequestEmployeeDetailTableConfig.startDateWidth.w,
            ),
          if (LeaveRequestEmployeeDetailTableConfig.showEndDate)
            _buildDataCell(
              Text(
                _dateFormat.format(request.endDate),
                style: context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: primaryTextColor),
              ),
              LeaveRequestEmployeeDetailTableConfig.endDateWidth.w,
            ),
          if (LeaveRequestEmployeeDetailTableConfig.showDays)
            _buildDataCell(
              Text(
                request.totalDays == request.totalDays.toInt()
                    ? request.totalDays.toInt().toString()
                    : request.totalDays.toString(),
                style: context.textTheme.labelMedium?.copyWith(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: primaryTextColor,
                ),
              ),
              LeaveRequestEmployeeDetailTableConfig.daysWidth.w,
            ),
          if (LeaveRequestEmployeeDetailTableConfig.showSubmittedAt)
            _buildDataCell(
              Text(
                request.requestedAt != null ? _dateFormat.format(request.requestedAt!) : '-',
                style: context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: primaryTextColor),
              ),
              LeaveRequestEmployeeDetailTableConfig.submittedAtWidth.w,
            ),
          if (LeaveRequestEmployeeDetailTableConfig.showProcessedAt)
            _buildDataCell(
              Text(
                _processedAtText(),
                style: context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: primaryTextColor),
              ),
              LeaveRequestEmployeeDetailTableConfig.processedAtWidth.w,
            ),
          if (LeaveRequestEmployeeDetailTableConfig.showReason)
            _buildDataCell(
              Text(
                request.reason,
                style: context.textTheme.labelMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle),
              ),
              LeaveRequestEmployeeDetailTableConfig.reasonWidth.w,
            ),
          if (LeaveRequestEmployeeDetailTableConfig.showStatus)
            _buildDataCell(_buildStatusCell(context), LeaveRequestEmployeeDetailTableConfig.statusWidth.w),
          if (LeaveRequestEmployeeDetailTableConfig.showActions)
            _buildDataCell(_buildActionsCell(), LeaveRequestEmployeeDetailTableConfig.actionsWidth.w),
        ],
      ),
    );
  }

  String _processedAtText() {
    DateTime? processedAt;

    switch (request.status) {
      case RequestStatus.approved:
        processedAt = request.approvedAt;
        break;
      case RequestStatus.rejected:
        processedAt = request.rejectedAt;
        break;
      case RequestStatus.pending:
      case RequestStatus.cancelled:
      case RequestStatus.draft:
        processedAt = null;
        break;
    }

    if (processedAt == null) {
      return '-';
    }

    return _dateFormat.format(processedAt);
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 16.h),
      child: child,
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
    Color backgroundColor;
    Color textColor;
    String label;

    switch (request.status) {
      case RequestStatus.pending:
        backgroundColor = AppColors.pendingStatusBackground;
        textColor = AppColors.pendingStatucColor;
        label = localizations.leaveFilterPending;
        break;
      case RequestStatus.draft:
        backgroundColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey;
        textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
        label = localizations.leaveFilterDraft;
        break;
      case RequestStatus.approved:
        backgroundColor = AppColors.holidayIslamicPaidBg;
        textColor = AppColors.holidayIslamicPaidText;
        label = localizations.leaveFilterApproved;
        break;
      case RequestStatus.rejected:
        backgroundColor = AppColors.errorBg;
        textColor = AppColors.errorText;
        label = localizations.rejected;
        break;
      case RequestStatus.cancelled:
        backgroundColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey;
        textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
        label = 'Cancelled';
        break;
    }

    return DigifyCapsule(label: label.capitalizeFirst, backgroundColor: backgroundColor, textColor: textColor);
  }

  Widget _buildActionsCell() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyAssetButton(
          assetPath: Assets.icons.viewIconBlue.path,
          onTap: onView,
          width: 20,
          height: 20,
          color: AppColors.viewIconBlue,
          padding: 4.w,
        ),
      ],
    );
  }
}
