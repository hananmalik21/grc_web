import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_employee_detail/leave_request_employee_detail_chip.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_employee_detail/leave_request_employee_detail_leave_stats_cards.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LeaveRequestEmployeeDetailHeader extends ConsumerWidget {
  const LeaveRequestEmployeeDetailHeader({
    super.key,
    required this.employeeName,
    required this.employeeGuid,
    required this.isDark,
    required this.localizations,
    this.onExport,
    this.onAddLeaveRequest,
  });

  final String employeeName;
  final String employeeGuid;
  final bool isDark;
  final AppLocalizations localizations;
  final VoidCallback? onExport;
  final VoidCallback? onAddLeaveRequest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DigifyAssetButton(onTap: () => context.pop(), assetPath: Assets.icons.employeeManagement.backArrow.path),
              Gap(24.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Leave history',
                      style: context.textTheme.titleLarge?.copyWith(fontSize: 24.sp, color: textPrimary),
                    ),
                    Gap(8.h),
                    LeaveRequestEmployeeDetailChip(label: employeeName.isEmpty ? '—' : employeeName, isDark: isDark),
                  ],
                ),
              ),
              AppButton.outline(
                label: localizations.export,
                svgPath: Assets.icons.downloadTemplateIcon.path,
                onPressed: onExport,
              ),
              Gap(8.w),
              AppButton.primary(
                label: localizations.newLeaveRequest,
                svgPath: Assets.icons.addDepartmentIcon.path,
                onPressed: onAddLeaveRequest,
              ),
            ],
          ),
          Gap(24.h),
          LeaveRequestEmployeeDetailLeaveStatsCards(
            employeeGuid: employeeGuid,
            isDark: isDark,
            localizations: localizations,
          ),
        ],
      ),
    );
  }
}
