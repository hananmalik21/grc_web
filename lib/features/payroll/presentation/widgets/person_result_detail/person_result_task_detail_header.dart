import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/features/payroll/domain/models/payroll_process_result_task.dart';
import 'package:grc/features/payroll/domain/models/person_result_employee.dart';
import 'package:grc/features/payroll/presentation/widgets/person_result_detail/person_result_task_detail_stat_cards.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class PersonResultTaskDetailHeader extends StatelessWidget {
  const PersonResultTaskDetailHeader({super.key, required this.employee, required this.task});

  final PersonResultEmployee employee;
  final PayrollProcessResultTask task;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final status = task.statusLabel(
      completeLabel: loc.payrollPersonResultsTaskStatusComplete,
      inProgressLabel: loc.payrollPersonResultsTaskStatusInProgress,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _BackButton(onTap: () => context.pop()),
              Gap(16.w),
              AppAvatar(fallbackInitial: employee.name, size: 52.r),
              Gap(16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      loc.payrollPersonResultsArchiveResultDetails,
                      style: context.textTheme.headlineLarge?.copyWith(color: AppColors.cardBackground),
                    ),
                    Gap(2.h),
                    Text(
                      employee.name,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: AppColors.cardBackground.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(24.h),
          PersonResultTaskDetailStatCards(
            cards: [
              PersonResultTaskDetailStatCardData(
                label: loc.payrollPersonResultsArchiveStatus,
                value: status,
                iconPath: Assets.icons.checkIconGreen.path,
              ),
              PersonResultTaskDetailStatCardData(
                label: loc.payrollPersonResultsRecordsArchived,
                value: '1',
                iconPath: Assets.icons.employeeManagement.document.path,
              ),
              PersonResultTaskDetailStatCardData(
                label: loc.payrollPersonResultsPayrollPeriod,
                value: task.payrollPeriod,
                iconPath: Assets.icons.employeesAssignedIcon.path,
              ),
              PersonResultTaskDetailStatCardData(
                label: loc.payrollPersonResultsArchiveDate,
                value: task.processDate,
                iconPath: Assets.icons.clockIcon.path,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38.w,
      height: 38.w,
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.onPrimary.withValues(alpha: 0.25)),
      ),
      alignment: Alignment.center,
      child: DigifyAssetButton(
        onTap: onTap,
        assetPath: Assets.icons.employeeManagement.backArrow.path,
        color: AppColors.onPrimary,
        width: 18,
        height: 18,
        padding: 0,
        borderRadius: BorderRadius.circular(10.r),
      ),
    );
  }
}
