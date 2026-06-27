import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_popup_menu_button.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/hiring/application/candidates/controllers/delete_candidate_controller.dart';
import 'package:grc/features/hiring/application/candidates/providers/delete_candidate_providers.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/screens/candidate_detail_page.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CandidateCard extends StatelessWidget {
  const CandidateCard({required this.candidate, super.key});

  final CandidateData candidate;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cardColor = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final mutedTextColor = isDark ? AppColors.textMutedDark : AppColors.tableHeaderText;

    return InkWell(
      onTap: () => context.pushNamed(CandidateDetailPage.routeName, extra: candidate),
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor),
          boxShadow: AppShadows.primaryShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppAvatar(fallbackInitial: candidate.name, size: 56.r),
                      const Spacer(),
                      DigifyStatusCapsule(status: candidate.status),
                      Gap(8.w),
                      _CandidateActionsMenu(candidate: candidate),
                    ],
                  ),
                  Gap(16.h),
                  Text(candidate.name, style: context.textTheme.headlineSmall?.copyWith(color: textColor)),
                  Gap(4.h),
                  Text(candidate.jobTitle, style: context.textTheme.bodyMedium?.copyWith(color: subTextColor)),
                  Gap(2.h),
                  Text(
                    candidate.company,
                    style: context.textTheme.labelSmall?.copyWith(color: mutedTextColor, fontSize: 12.sp),
                  ),
                  Gap(12.h),
                  _buildRating(context, candidate.rating, subTextColor),
                  Gap(16.h),
                  _buildContactInfo(context, candidate, subTextColor),
                  DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 12.h)),
                  _buildSkills(context, candidate.skills, subTextColor, isDark),
                  DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 12.h)),
                  _buildTalentPools(context, candidate.talentPoolLabels, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRating(BuildContext context, double rating, Color color) {
    return Row(
      children: [
        for (int i = 0; i < 5; i++)
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Icon(
              i < rating.floor()
                  ? Icons.star_rounded
                  : (i < rating ? Icons.star_half_rounded : Icons.star_border_rounded),
              size: 14.r,
              color: AppColors.warning,
            ),
          ),
        Gap(4.w),
        Text(
          rating.toString(),
          style: context.textTheme.labelSmall?.copyWith(color: color, fontSize: 12.sp),
        ),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context, CandidateData candidate, Color color) {
    return Column(
      children: [
        _buildInfoRow(context, Assets.icons.emailCardIcon.path, candidate.email, color),
        Gap(8.h),
        _buildInfoRow(context, Assets.icons.leaveManagement.phone.path, candidate.phone, color),
        Gap(8.h),
        _buildInfoRow(context, Assets.icons.mapPinGray.path, candidate.location, color),
        Gap(8.h),
        _buildInfoRow(context, Assets.icons.businessUnitBasicIcon.path, candidate.experience, color),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String assetPath, String text, Color color) {
    return Row(
      children: [
        DigifyAsset(assetPath: assetPath, width: 14.r, height: 14.r, color: color),
        Gap(8.w),
        Expanded(
          child: Text(
            text,
            style: context.textTheme.bodyMedium?.copyWith(color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSkills(BuildContext context, List<CandidateSkillData> skills, Color color, bool isDark) {
    final skillNames = skills.map((skill) => skill.name.trim()).where((name) => name.isNotEmpty).toList();
    final visibleSkills = skillNames.take(4).toList();
    final hiddenSkillCount = skillNames.length - visibleSkills.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DigifyAsset(assetPath: Assets.icons.compensation.badge.path, width: 14.r, height: 14.r, color: color),
            Gap(4.w),
            Text('Skills:', style: context.textTheme.labelSmall?.copyWith(color: color)),
          ],
        ),
        Gap(8.h),
        Wrap(
          spacing: 4.w,
          runSpacing: 4.h,
          children: [
            for (final skill in visibleSkills)
              DigifySquareCapsule(
                label: skill,
                backgroundColor: isDark ? AppColors.infoBgDark : AppColors.cardBackgroundGrey,
                textColor: isDark ? AppColors.textPrimaryDark : AppColors.textDarkSlate,
                borderRadius: BorderRadius.circular(4.r),
              ),
            if (hiddenSkillCount > 0)
              DigifySquareCapsule(
                label: '+$hiddenSkillCount more',
                backgroundColor: isDark ? AppColors.infoBgDark : AppColors.cardBackgroundGrey,
                textColor: AppColors.primary,
                borderRadius: BorderRadius.circular(4.r),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildTalentPools(BuildContext context, List<String> talentPools, bool isDark) {
    return Wrap(
      spacing: 4.w,
      runSpacing: 4.h,
      children: [
        for (final talentPool in talentPools)
          DigifyCapsule(
            label: talentPool,
            backgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.jobRoleBg,
            textColor: AppColors.primary,
          ),
      ],
    );
  }
}

class _CandidateActionsMenu extends ConsumerWidget {
  const _CandidateActionsMenu({required this.candidate});

  final CandidateData candidate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDeleting = ref.watch(deleteCandidateLoadingProvider(candidate.id));

    return DigifyPopupMenuButton(
      elevation: 10,
      shadowColor: AppColors.textMutedDark,
      constraints: BoxConstraints(minWidth: 180.w, maxWidth: 220.w),
      actions: [
        DigifyPopupMenuAction(
          value: 'view',
          label: 'View',
          icon: DigifyAsset(
            assetPath: Assets.icons.blueEyeIcon.path,
            width: 15.r,
            height: 15.r,
            color: AppColors.primary,
          ),
          onSelected: () => context.pushNamed(CandidateDetailPage.routeName, extra: candidate),
        ),
        DigifyPopupMenuAction(
          value: 'delete',
          label: loc.delete,
          icon: DigifyAsset(
            assetPath: Assets.icons.redDeleteIcon.path,
            width: 15.r,
            height: 15.r,
            color: AppColors.error,
          ),
          onSelected: isDeleting ? null : () => _confirmDelete(context, ref, loc),
          isDestructive: true,
        ),
      ],
      child: DigifyAsset(assetPath: Assets.icons.employeeManagement.more.path, width: 20.w, height: 20.w),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, AppLocalizations loc) async {
    final confirmed = await AppConfirmationDialog.show(
      context,
      title: loc.delete,
      message: loc.hiringCandidatesDeleteConfirmMessage,
      itemName: candidate.name,
      confirmLabel: loc.delete,
      cancelLabel: loc.close,
      type: ConfirmationType.danger,
      svgPath: Assets.icons.deleteIconRed.path,
    );

    if (confirmed != true || !context.mounted) return;

    await ref.read(deleteCandidateControllerProvider).delete(context, candidateGuid: candidate.id);
  }
}
