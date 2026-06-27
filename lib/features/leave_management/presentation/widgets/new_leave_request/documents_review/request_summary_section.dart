import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/leave_management/data/mappers/leave_type_mapper.dart';
import 'package:grc/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class RequestSummarySection extends StatelessWidget {
  final NewLeaveRequestState state;

  const RequestSummarySection({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyDivider(margin: EdgeInsets.only(bottom: 24.h)),
        Row(
          children: [
            DigifyAsset(assetPath: Assets.icons.leaveManagement.request.path, width: 20, height: 20),
            Gap(8.w),
            Text(
              localizations.requestSummary,
              style: context.textTheme.titleSmall?.copyWith(color: AppColors.dialogTitle, fontSize: 16.sp),
            ),
          ],
        ),
        Gap(16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.securityProfilesBackground,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _SummaryItem(
                      label: localizations.employee,
                      value: state.selectedEmployee?.fullName ?? localizations.notSelected,
                    ),
                  ),
                  Expanded(
                    child: _SummaryItem(
                      label: localizations.leaveType,
                      value: state.leaveType != null
                          ? LeaveTypeMapper.getShortLabel(state.leaveType!)
                          : localizations.notSelected,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Row(
                children: [
                  Expanded(
                    child: _SummaryItem(
                      label: localizations.startDate,
                      value: state.startDate != null
                          ? DateFormat('dd/MM/yyyy').format(state.startDate!)
                          : localizations.notSelected,
                    ),
                  ),
                  Expanded(
                    child: _SummaryItem(
                      label: localizations.endDate,
                      value: state.endDate != null
                          ? DateFormat('dd/MM/yyyy').format(state.endDate!)
                          : localizations.notSelected,
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              Row(
                children: [
                  Expanded(
                    child: _SummaryItem(
                      label: localizations.duration,
                      value: '${state.totalDays} ${localizations.days}',
                    ),
                  ),
                  Expanded(
                    child: _SummaryItem(
                      label: localizations.attachments,
                      value: localizations.filesCount(state.documents.length),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(color: AppColors.shiftExportButton, fontSize: 12.sp),
        ),
        Gap(4.h),
        Text(
          value,
          style: context.textTheme.titleSmall?.copyWith(color: AppColors.textPrimary, fontSize: 16.sp),
        ),
      ],
    );
  }
}
