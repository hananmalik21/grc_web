import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/badges/info_badge.dart';
import 'package:grc/core/widgets/buttons/action_button.dart';
import 'package:grc/core/widgets/buttons/icon_action_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_families/job_families_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_families/job_family_detail_dialog.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/job_families/job_family_form_dialog.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_delete_state.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobFamilyCard extends ConsumerWidget with JobFamiliesPermissionMixin {
  final JobFamily jobFamily;
  final List<JobLevel> jobLevels;
  final AppLocalizations localizations;
  final bool isDark;

  const JobFamilyCard({
    super.key,
    required this.jobFamily,
    required this.jobLevels,
    required this.localizations,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteState = ref.watch(jobFamilyDeleteStateProvider);
    final isDeleting = deleteState.deletingId == jobFamily.id;
    final cardContent = Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(jobFamily.nameEnglish, style: context.textTheme.titleMedium),
                    Gap(4.h),
                    Text(
                      jobFamily.nameArabic,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: context.textTheme.bodySmall?.copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
                    ),
                    Gap(8.h),
                    InfoBadge(text: jobFamily.code),
                  ],
                ),
              ),
              DigifyAsset(
                assetPath: Assets.icons.businessUnitDetailsIcon.path,
                color: AppColors.primaryLight,
                width: 24.sp,
                height: 24.sp,
              ),
            ],
          ),
          Gap(16.h),
          Text(
            jobFamily.description,
            style: context.textTheme.bodySmall?.copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 16.0)),
          Row(
            spacing: 8.w,
            children: [
              if (canViewJobFamily)
                Expanded(
                  child: ActionButton(
                    label: localizations.view,
                    onTap: () => JobFamilyDetailDialog.show(context, jobFamily: jobFamily, jobLevels: jobLevels),
                    iconPath: Assets.icons.viewIconBlue.path,
                    backgroundColor: AppColors.infoBg,
                    foregroundColor: AppColors.primary,
                  ),
                ),
              if (canUpdateJobFamily)
                Expanded(
                  child: ActionButton(
                    label: localizations.edit,
                    onTap: () =>
                        JobFamilyFormDialog.show(context, jobFamily: jobFamily, isEdit: true, onSave: (updated) {}),
                    iconPath: Assets.icons.editIconGreen.path,
                    backgroundColor: AppColors.greenBg,
                    foregroundColor: AppColors.greenButton,
                  ),
                ),
              if (canDeleteJobFamily)
                IconActionButton(
                  iconPath: Assets.icons.deleteIconRed.path,
                  bgColor: AppColors.errorBg,
                  iconColor: AppColors.error,
                  onPressed: isDeleting ? null : () => _handleDelete(context, ref),
                  isLoading: isDeleting,
                ),
            ],
          ),
        ],
      ),
    );

    return Material(color: Colors.transparent, borderRadius: BorderRadius.circular(10.r), child: cardContent);
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: 'Delete Job Family',
      message: 'Are you sure you want to delete this job family? This action cannot be undone.',
      itemName: jobFamily.nameEnglish,
      confirmLabel: 'Delete',
      cancelLabel: 'Cancel',
      type: ConfirmationType.danger,
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(jobFamilyNotifierProvider.notifier)
          .deleteJobFamily(ref, ref.read(deleteJobFamilyUseCaseProvider), id: jobFamily.id);

      if (context.mounted) {
        ToastService.success(context, 'Job family deleted successfully', title: 'Deleted');
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, 'Failed to delete job family', title: 'Error');
      }
    }
  }
}
