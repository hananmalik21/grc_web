import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_families/job_families_permission_mixin.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_families/job_family_detail_mobile_sheet.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_families/job_family_form_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class JobFamilyDetailDialog extends ConsumerWidget with JobFamiliesPermissionMixin {
  final JobFamily jobFamily;
  final List<JobLevel> jobLevels;

  const JobFamilyDetailDialog({super.key, required this.jobFamily, required this.jobLevels});

  static Future<void> show(BuildContext context, {required JobFamily jobFamily, required List<JobLevel> jobLevels}) {
    if (context.isMobileLayout) {
      return DigifyBottomSheet.show<void>(
        context,
        type: DigifyBottomSheetType.custom,
        title: AppLocalizations.of(context)!.jobFamilyDetails,
        child: JobFamilyDetailMobileSheet(
          jobFamily: jobFamily,
          onEdit: () => JobFamilyFormDialog.show(context, jobFamily: jobFamily, isEdit: true, onSave: (_) {}),
        ),
      );
    }

    return showDialog<void>(
      context: context,
      builder: (_) => JobFamilyDetailDialog(jobFamily: jobFamily, jobLevels: jobLevels),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final totalPositions = jobFamily.totalPositions.toString();
    final filledPositions = jobFamily.filledPositions.toString();
    final fillRate = '${jobFamily.fillRate.toStringAsFixed(0)}%';

    return AppDialog(
      title: localizations.jobFamilyDetails,
      width: 540.w,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.basicInformation,
            style: context.textTheme.titleSmall?.copyWith(fontSize: 15.0, color: AppColors.textPrimary),
          ),
          Gap(16.h),
          _buildCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.description,
                  style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
                Gap(4.h),
                Text(
                  jobFamily.description,
                  style: context.textTheme.titleSmall?.copyWith(fontSize: 15.0, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          Gap(24.h),
          Text(
            localizations.positionStatistics,
            style: context.textTheme.titleSmall?.copyWith(fontSize: 15.0, color: AppColors.textPrimary),
          ),
          Gap(16.h),
          Row(
            children: [
              _buildStatBlock(
                context: context,
                label: localizations.totalPositions,
                value: totalPositions,
                backgroundColor: const Color(0xFFE8F0FE),
                valueColor: AppColors.primary,
              ),
              Gap(8.w),
              _buildStatBlock(
                context: context,
                label: localizations.filledPositions,
                value: filledPositions,
                backgroundColor: const Color(0xFFEAF8F1),
                valueColor: AppColors.greenButton,
              ),
              Gap(8.w),
              _buildStatBlock(
                context: context,
                label: localizations.fillRate,
                value: fillRate,
                backgroundColor: const Color(0xFFF4EBFF),
                valueColor: const Color(0xFF6D2AE6),
              ),
            ],
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: localizations.close, onPressed: () => context.pop()),
        if (canUpdateJobFamily) ...[
          Gap(12.w),
          AppButton.primary(
            label: localizations.edit,
            onPressed: () {
              JobFamilyFormDialog.show(context, jobFamily: jobFamily, isEdit: true, onSave: (updated) {});
            },
          ),
        ],
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(color: AppColors.securityProfilesBackground, borderRadius: BorderRadius.circular(10.r)),
      child: child,
    );
  }

  Widget _buildStatBlock({
    required BuildContext context,
    required String label,
    required String value,
    required Color backgroundColor,
    required Color valueColor,
  }) {
    return Expanded(
      child: Container(
        height: 88.h,
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(14.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            Text(
              value,
              style: context.textTheme.headlineLarge?.copyWith(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                color: valueColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
