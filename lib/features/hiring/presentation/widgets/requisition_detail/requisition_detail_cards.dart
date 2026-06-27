import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_dot.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RequisitionDetailCard extends StatelessWidget {
  const RequisitionDetailCard({super.key, required this.title, required this.child, required this.isDark});

  final String title;
  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: context.textTheme.headlineSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(12.h),
          child,
        ],
      ),
    );
  }
}

class RequisitionInfoCard extends StatelessWidget {
  const RequisitionInfoCard({super.key, required this.row, required this.isDark});

  final RequisitionTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isMobile = context.isMobileLayout;

    return RequisitionDetailCard(
      title: loc.hiringRequisitionDetailsCardTitle,
      isDark: isDark,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: isMobile ? 1 : 4,
        childAspectRatio: isMobile ? 5 : 2.2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        children: [
          _buildInfoItem(context, loc.department, row.department),
          _buildInfoItem(context, loc.position, row.roleTitle),
          _buildInfoItem(context, loc.hiringRequisitionDetailGrade, row.gradeNumber),
          _buildInfoItem(context, loc.hiringRequisitionsTableColLocation, row.location),
          _buildInfoItem(context, loc.hiringRequisitionDetailEmploymentType, row.employmentTypeCode),
          _buildInfoItem(context, loc.hiringRequisitionDetailWorkMode, row.workModeCode),
          _buildInfoItem(context, loc.hiringRequisitionDetailOpenings, '${row.openings}'),
          _buildInfoItem(context, loc.hiringRequisitionDetailTargetStart, row.targetStartLabel()),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(color: labelColor, fontSize: 12.sp),
        ),
        Gap(2.h),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            color: valueColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class CompensationCard extends StatelessWidget {
  const CompensationCard({super.key, required this.row, required this.isDark});

  final RequisitionTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final loc = AppLocalizations.of(context)!;

    return RequisitionDetailCard(
      title: loc.hiringRequisitionCompensationCardTitle,
      isDark: isDark,
      child: Row(
        children: [
          DigifyAsset(
            assetPath: Assets.icons.attendanceIcon.path,
            width: 24.w,
            height: 24.w,
            color: AppColors.dialogCloseIcon,
          ),
          Gap(16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                row.compensationRange,
                style: context.textTheme.titleLarge?.copyWith(fontSize: 24.sp, color: valueColor),
              ),
              Gap(4.h),
              Text(row.compensationTypeLabel, style: context.textTheme.bodyMedium?.copyWith(color: labelColor)),
            ],
          ),
        ],
      ),
    );
  }
}

class JobDescriptionCard extends StatelessWidget {
  const JobDescriptionCard({super.key, required this.row, required this.isDark});

  final RequisitionTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final loc = AppLocalizations.of(context)!;
    final summary = row.positionSummary ?? '---';

    return RequisitionDetailCard(
      title: loc.hiringRequisitionJobDescriptionCardTitle,
      isDark: isDark,
      child: Text(summary, style: context.textTheme.titleSmall?.copyWith(color: textColor)),
    );
  }
}

class RequirementsCard extends StatelessWidget {
  const RequirementsCard({super.key, required this.row, required this.isDark});

  final RequisitionTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.sidebarMenuItemText;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final loc = AppLocalizations.of(context)!;
    final qualificationItems = <String>[
      if (row.minimumQualifications != null) row.minimumQualifications!,
      if (row.preferredQualifications != null) row.preferredQualifications!,
    ];
    final requiredSkills = row.requiredSkills;
    final preferredSkills = row.preferredSkills;

    return RequisitionDetailCard(
      title: loc.hiringRequisitionRequirementsCardTitle,
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.hiringRequisitionDetailQualifications,
            style: context.textTheme.titleSmall?.copyWith(color: labelColor),
          ),
          Gap(8.h),
          ...qualificationItems.map((item) => _buildListItem(item, valueColor)),
          if (requiredSkills.isNotEmpty || preferredSkills.isNotEmpty) ...[
            Gap(16.h),
            Text(
              loc.hiringRequisitionDetailSkillsRequired,
              style: context.textTheme.titleSmall?.copyWith(color: labelColor),
            ),
            Gap(8.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                ...requiredSkills.map((skill) => _buildSkillBadge(skill.name)),
                ...preferredSkills.map((skill) => _buildSkillBadge(skill.name)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildListItem(String text, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DigifyStatusDot(color: color, size: 3),
          Gap(8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: color, fontSize: 15.3.sp, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillBadge(String label) {
    return DigifyCapsule(label: label, backgroundColor: AppColors.infoBg, textColor: AppColors.primary);
  }
}

class HiringTeamCard extends StatelessWidget {
  const HiringTeamCard({super.key, required this.row, required this.isDark});

  final RequisitionTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return RequisitionDetailCard(
      title: loc.hiringRequisitionHiringTeamCardTitle,
      isDark: isDark,
      child: Column(
        children: [
          _buildTeamMember(context, loc.hiringRequisitionDetailHiringManager, row.hiringManager),
          if (row.hasRecruiter) ...[
            Gap(16.h),
            _buildTeamMember(context, loc.hiringRequisitionDetailRecruiter, row.recruiterName!),
          ],
          if (row.hasHrbp) ...[Gap(16.h), _buildTeamMember(context, loc.hiringRequisitionDetailHrbp, row.hrbpName!)],
        ],
      ),
    );
  }

  Widget _buildTeamMember(BuildContext context, String role, String name) {
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.sidebarMenuItemText;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(role, style: context.textTheme.titleSmall?.copyWith(color: labelColor)),
        Gap(4.h),
        Row(
          children: [
            AppAvatar(fallbackInitial: name, size: 40.r),
            Gap(12.w),
            Text(
              name,
              style: context.textTheme.titleSmall?.copyWith(color: valueColor, fontSize: 15.sp),
            ),
          ],
        ),
      ],
    );
  }
}

class PriorityCard extends StatelessWidget {
  const PriorityCard({super.key, required this.row, required this.isDark});

  final RequisitionTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return RequisitionDetailCard(
      title: loc.hiringRequisitionPriorityCardTitle,
      isDark: isDark,
      child: Align(
        alignment: Alignment.centerLeft,
        child: DigifyCapsule(
          label: '${row.priorityLabel} ${loc.hiringRequisitionPriorityCardTitle}',
          backgroundColor: AppColors.errorBg,
          textColor: AppColors.brandRed,
        ),
      ),
    );
  }
}

class QuickStatsCard extends StatelessWidget {
  const QuickStatsCard({super.key, required this.row, required this.isDark});

  final RequisitionTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return RequisitionDetailCard(
      title: loc.hiringRequisitionQuickStatsCardTitle,
      isDark: isDark,
      child: Column(
        children: [
          _buildStatRow(context, loc.hiringRequisitionDetailTabApplications, '3'),
          Gap(12.h),
          _buildStatRow(context, loc.hiringRequisitionDetailStatShortlisted, '1'),
          Gap(12.h),
          _buildStatRow(context, loc.hiringRequisitionDetailStatInInterview, '1'),
          Gap(12.h),
          _buildStatRow(context, loc.hiringRequisitionDetailStatDaysOpen, '20'),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value) {
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.textTheme.bodyMedium?.copyWith(color: labelColor)),
        DigifyStatusCapsule(
          status: value,
          variant: DigifyStatusCapsuleVariant.rounded,
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        ),
      ],
    );
  }
}
