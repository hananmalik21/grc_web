import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/enums/overtime_status.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/overtime/overtime_record.dart';
import '../../../../data/config/overtime_table_config.dart';
import '../overtime_status_chip.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OvertimeExpandedPanel extends StatelessWidget {
  final OvertimeRecord record;
  final bool isDark;

  const OvertimeExpandedPanel({super.key, required this.record, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: OvertimeTableConfig.totalWidth.w,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarActiveBg.withAlpha(128),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.r)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildEmployeeDetailsCard(context)),
            Gap(21.w),
            Expanded(child: _buildOvertimeDetailsCard(context)),
            Gap(21.w),
            Expanded(child: _buildApprovalCard(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeDetailsCard(BuildContext context) {
    return _buildCardWrapper(
      context: context,
      title: 'Employee Details',
      assetIcon: Assets.icons.userIcon.path,
      child: Column(
        children: [
          _buildInfoRow(context, 'Position:', record.positionDisplay),
          Gap(10.h),
          _buildInfoRow(context, 'Department:', record.departmentDisplay),
          Gap(10.h),
          _buildInfoRow(context, 'Line Manager:', record.lineManagerDisplay),
        ],
      ),
    );
  }

  Widget _buildOvertimeDetailsCard(BuildContext context) {
    return _buildCardWrapper(
      context: context,
      title: 'Overtime Details',
      assetIcon: Assets.icons.clockIcon.path,
      child: Column(
        children: [
          _buildInfoRow(context, 'Regular Hours:', '${record.regularHoursDisplay} hrs'),
          Gap(10.h),
          _buildInfoRow(context, 'Overtime Hours:', '${record.overtimeHoursDisplay} hrs'),
          Gap(10.h),
          _buildInfoRow(context, 'Overtime Type:', record.typeDisplay),
          Gap(10.h),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 10.h)),
          Gap(10.h),
          _buildInfoRow(context, 'Rate Multiplier:', '${record.rateDisplay}x'),
        ],
      ),
    );
  }

  Widget _buildApprovalCard(BuildContext context) {
    return _buildCardWrapper(
      context: context,
      title: 'Approval Information',
      assetIcon: Assets.icons.sectionIconPurple.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Status:',
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              OvertimeStatusChip(status: OvertimeStatus.fromString(record.approvalInformation?.status ?? "")),
            ],
          ),
          Gap(10.h),
          _buildInfoRow(context, 'Approved By:', record.approvedByDisplay),
          Gap(10.h),
          _buildInfoRow(context, 'Approved Date:', record.approvedDateDisplay),
          Gap(10.h),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 10.h)),
          Gap(10.h),
          _buildInfoRow(context, 'Reason:', record.reasonDisplay),
        ],
      ),
    );
  }

  Widget _buildCardWrapper({
    required BuildContext context,
    required String title,
    required String assetIcon,
    required Widget child,
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
        mainAxisSize: MainAxisSize.max,
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
}
