import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/time_tracking_and_attendance/data/config/attendance_table_config.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance_record.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AttendanceExpandedPanel extends StatelessWidget {
  final AttendanceRecord record;
  final bool isDark;

  const AttendanceExpandedPanel({super.key, required this.record, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final double totalWidth = AttendanceTableConfig.totalWidth.w;

    return Container(
      width: totalWidth,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarActiveBg.withAlpha(128),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildScheduleInfoCard(context)),
              Gap(21.w),
              Expanded(child: _buildActualAttendanceCard(context)),
            ],
          ),
          Gap(21.h),
          _buildLocationAndNotesCard(context),
        ],
      ),
    );
  }

  Widget _buildScheduleInfoCard(BuildContext context) {
    return _buildCardWrapper(
      context: context,
      title: 'Schedule Information',
      assetIcon: Assets.icons.auditTrailIconDepartment.path,
      child: Column(
        children: [
          _buildInfoRow(context, 'Schedule Date:', record.displayValue(record.scheduleDate)),
          Gap(10.h),
          _buildInfoRow(context, 'Schedule Start:', record.displayValue(record.scheduleStartTime)),
          Gap(10.h),
          _buildInfoRow(context, 'Schedule End:', record.displayValue(record.scheduleEndTime)),
          Gap(10.h),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 10.h)),
          Gap(10.h),
          _buildInfoRow(context, 'Duration:', record.displayValue(record.scheduledHours)),
        ],
      ),
    );
  }

  Widget _buildActualAttendanceCard(BuildContext context) {
    return _buildCardWrapper(
      context: context,
      title: 'Actual Attendance',
      assetIcon: Assets.icons.priceUpItem.path,
      child: Column(
        children: [
          _buildInfoRow(context, 'Check In Time:', record.displayValue(record.checkIn)),
          Gap(10.h),
          _buildInfoRow(context, 'Check Out Time:', record.displayValue(record.checkOut)),
          Gap(10.h),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 10.h)),
          Gap(10.h),
          _buildInfoRow(context, 'Hours Worked:', record.displayValue(record.hoursWorked)),
          Gap(10.h),
          _buildInfoRow(context, 'Overtime Hours:', record.displayValue(record.overtimeHours)),
        ],
      ),
    );
  }

  Widget _buildLocationAndNotesCard(BuildContext context) {
    return _buildCardWrapper(
      context: context,
      title: 'Location & Notes',
      assetIcon: Assets.icons.searchGreen.path,
      actions: [
        AppButton.primary(label: 'View on Map', onPressed: () {}, svgPath: Assets.icons.searchGreen.path, height: 25.h),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            context,
            'Location:',
            record.displayValue(record.checkInLocation ?? record.checkOutLocation),
            spaceBetween: false,
          ),
          Gap(10.h),
          _buildCompoundInfoRow(context, 'Check-In GPS:', record.displayValue(record.checkInLocation), ''),
          Gap(10.h),
          _buildCompoundInfoRow(context, 'Check-Out GPS:', record.displayValue(record.checkOutLocation), ''),
          Gap(10.h),
          _buildInfoRow(context, 'Notes:', record.displayValue(record.notes), spaceBetween: false),
        ],
      ),
    );
  }

  Widget _buildCardWrapper({
    required BuildContext context,
    required String title,
    required String assetIcon,
    required Widget child,
    List<Widget>? actions,
  }) {
    final borderColor = isDark ? AppColors.borderGreyDark : AppColors.cardBorder;
    final cardColor = isDark ? AppColors.cardBackgroundDark : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      padding: EdgeInsets.all(14.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DigifyAsset(
                assetPath: assetIcon,
                width: 18.w,
                height: 18.h,
                color: isDark ? AppColors.textPrimaryDark : AppColors.primary,
              ),
              Gap(8.w),
              Text(
                title,
                style: context.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                ),
              ),
              if (actions != null) ...[const Spacer(), ...actions],
            ],
          ),
          Gap(14.h),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, {bool spaceBetween = true}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (spaceBetween) ...[
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  value,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ] else ...[
          SizedBox(
            width: 130.w,
            child: Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCompoundInfoRow(BuildContext context, String label, String value1, String value2) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130.w,
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value1,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              if (value2 != '-' && value2.isNotEmpty) ...[
                Gap(4.h),
                Text(
                  value2,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
