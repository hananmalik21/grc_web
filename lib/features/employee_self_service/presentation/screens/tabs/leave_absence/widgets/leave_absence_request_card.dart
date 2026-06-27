import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/string_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/features/employee_self_service/presentation/providers/leave_absence/leave_absence_state.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_labeled_value.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class LeaveAbsenceRequestCard extends StatelessWidget {
  const LeaveAbsenceRequestCard({super.key, required this.request, required this.onView, required this.onDownload});

  final LeaveAbsenceRequestRecord request;
  final VoidCallback onView;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10.w,
                runSpacing: 8.h,
                children: [
                  Text(
                    request.leaveType,
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontSize: 16.sp,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  _StatusPill(status: request.status),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DigifyAssetButton(
                  assetPath: Assets.icons.viewIconBlue.path,
                  width: 18.w,
                  height: 18.h,
                  onTap: onView,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                Gap(8.w),
                DigifyAssetButton(
                  assetPath: Assets.icons.downloadIcon.path,
                  width: 18.w,
                  height: 18.h,
                  onTap: onDownload,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ],
            ),
          ],
        ),
        Gap(16.h),
        Wrap(
          spacing: 24.w,
          runSpacing: 16.h,
          children: [
            EssLabeledValue(label: 'Request ID', value: request.id),
            EssLabeledValue(
              label: 'Date Range',
              value:
                  '${DateFormat('yyyy-MM-dd').format(request.startDate)} to ${DateFormat('yyyy-MM-dd').format(request.endDate)}',
            ),
            EssLabeledValue(label: 'Duration', value: request.durationLabel),
            EssLabeledValue(label: 'Applied Date', value: DateFormat('yyyy-MM-dd').format(request.appliedDate)),
          ],
        ),
        Gap(14.h),
        EssLabeledValue(label: 'Reason', value: request.reason),
        Gap(10.h),
        EssLabeledValue(label: 'Approver', value: request.approver),
        if (request.approverComment != null && request.approverComment!.isNotEmpty) ...[
          Gap(14.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.infoBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.infoBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Approver Comments', style: context.textTheme.labelMedium?.copyWith(color: AppColors.infoText)),
                Gap(4.h),
                Text(
                  request.approverComment!,
                  style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.infoTextSecondary),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final LeaveAbsenceRequestStatus status;

  @override
  Widget build(BuildContext context) {
    return switch (status) {
      LeaveAbsenceRequestStatus.approved => DigifySquareCapsule(
        label: status.label.capitalizeEachWord,
        backgroundColor: AppColors.greenBg,
        textColor: AppColors.greenTextSecondary,
        borderColor: AppColors.greenBorder,
        borderRadius: BorderRadius.circular(7.r),
      ),
      LeaveAbsenceRequestStatus.pending => DigifySquareCapsule(
        label: status.label.capitalizeEachWord,
        backgroundColor: AppColors.warningBg,
        textColor: AppColors.warningText,
        borderColor: AppColors.warningBorder,
        borderRadius: BorderRadius.circular(7.r),
      ),
      LeaveAbsenceRequestStatus.rejected => DigifySquareCapsule(
        label: status.label.capitalizeEachWord,
        backgroundColor: AppColors.redBg,
        textColor: AppColors.redTextSecondary,
        borderColor: AppColors.redBorder,
        borderRadius: BorderRadius.circular(7.r),
      ),
      LeaveAbsenceRequestStatus.all => const SizedBox.shrink(),
    };
  }
}
