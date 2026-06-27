import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/manage_component_values_permission_mixin.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrgUnitsMobileList extends StatelessWidget {
  const OrgUnitsMobileList({
    super.key,
    required this.units,
    required this.isLoading,
    required this.isDark,
    required this.localizations,
    this.paginationInfo,
    this.currentPage = 1,
    this.onPrevious,
    this.onNext,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.deletingOrgUnitId,
  });

  final List<OrgStructureLevel> units;
  final bool isLoading;
  final bool isDark;
  final AppLocalizations localizations;
  final PaginationInfo? paginationInfo;
  final int currentPage;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final Function(OrgStructureLevel)? onView;
  final Function(OrgStructureLevel)? onEdit;
  final Function(OrgStructureLevel)? onDelete;
  final String? deletingOrgUnitId;

  static List<OrgStructureLevel> _skeletonItems() => List.generate(
        5,
        (_) => const OrgStructureLevel(
          orgUnitId: 'x',
          orgStructureId: 'x',
          enterpriseId: 0,
          levelCode: 'DIV',
          orgUnitCode: 'ORG-001',
          orgUnitNameEn: 'Organization Unit Name',
          orgUnitNameAr: '',
          isActive: true,
          managerName: 'Manager Name',
          managerEmail: '',
          managerPhone: '',
          location: 'Riyadh',
          city: '',
          address: '',
          description: '',
          createdBy: '',
          createdDate: '',
          lastUpdatedBy: '',
          lastUpdatedDate: '',
          lastUpdateLogin: '',
        ),
      );

  @override
  Widget build(BuildContext context) {
    final displayUnits =
        isLoading && units.isEmpty ? _skeletonItems() : units;
    final totalPages = paginationInfo?.totalPages ?? 1;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeletonizer(
            enabled: isLoading,
            child: displayUnits.isEmpty && !isLoading
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 48.h,
                      horizontal: 16.w,
                    ),
                    child: Center(
                      child: Text(
                        localizations.noResultsFound,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(12.r),
                    itemCount: displayUnits.length,
                    separatorBuilder: (_, _) => Gap(10.h),
                    itemBuilder: (context, index) => _OrgUnitCard(
                      unit: displayUnits[index],
                      isDark: isDark,
                      localizations: localizations,
                      isDeleteLoading:
                          deletingOrgUnitId == displayUnits[index].orgUnitId,
                      onView: onView,
                      onEdit: onEdit,
                      onDelete: onDelete,
                    ),
                  ),
          ),
          const DigifyDivider.horizontal(),
          MobilePaginationControls(
            isDark: isDark,
            currentPage: currentPage,
            totalPages: totalPages,
            hasPrevious: paginationInfo?.hasPrevious ?? false,
            hasNext: paginationInfo?.hasNext ?? false,
            onPrevious: onPrevious,
            onNext: onNext,
          ),
        ],
      ),
    );
  }
}

class _OrgUnitCard extends StatelessWidget with ManageComponentValuesPermissionMixin {
  const _OrgUnitCard({
    required this.unit,
    required this.isDark,
    required this.localizations,
    required this.isDeleteLoading,
    this.onView,
    this.onEdit,
    this.onDelete,
  });

  final OrgStructureLevel unit;
  final bool isDark;
  final AppLocalizations localizations;
  final bool isDeleteLoading;
  final Function(OrgStructureLevel)? onView;
  final Function(OrgStructureLevel)? onEdit;
  final Function(OrgStructureLevel)? onDelete;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final tileBg =
        isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final subtitleColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      unit.displayName,
                      style: context.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Gap(2.h),
                    Text(
                      unit.orgUnitCode,
                      style: context.textTheme.labelSmall?.copyWith(
                        color: subtitleColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(8.w),
              DigifyCapsule(
                label: unit.isActive
                    ? localizations.active.toUpperCase()
                    : localizations.inactive.toUpperCase(),
                backgroundColor: unit.isActive
                    ? AppColors.activeStatusBg
                    : AppColors.inactiveStatusBg,
                textColor: unit.isActive
                    ? AppColors.successText
                    : AppColors.inactiveStatusText,
                borderColor: unit.isActive
                    ? AppColors.activeStatusBorder
                    : AppColors.inactiveStatusBorder,
              ),
            ],
          ),
          Gap(10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _InfoChip(
                label: 'Level',
                value: unit.levelCode,
                isDark: isDark,
              ),
              if (unit.parentName.isNotEmpty)
                _InfoChip(
                  label: 'Parent',
                  value: unit.parentName,
                  isDark: isDark,
                ),
              if (unit.managerName.isNotEmpty)
                _InfoChip(
                  label: 'Manager',
                  value: unit.managerName,
                  isDark: isDark,
                ),
            ],
          ),
          Gap(12.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (canViewComponentValue)
                AppMobileButton(
                  svgPath: Assets.icons.viewIconBlue.path,
                  backgroundColor: AppColors.viewIconBlue.withValues(alpha: 0.1),
                  foregroundColor: AppColors.viewIconBlue,
                  onPressed: onView != null ? () => onView!(unit) : null,
                ),
              if (canUpdateComponentValue) ...[
                Gap(8.w),
                AppMobileButton(
                  svgPath: Assets.icons.editIconGreen.path,
                  backgroundColor:
                      AppColors.editIconGreen.withValues(alpha: 0.1),
                  foregroundColor: AppColors.editIconGreen,
                  onPressed: onEdit != null ? () => onEdit!(unit) : null,
                ),
              ],
              if (canDeleteComponentValue) ...[
                Gap(8.w),
                AppMobileButton(
                  svgPath: Assets.icons.deleteIconRed.path,
                  backgroundColor:
                      AppColors.deleteIconRed.withValues(alpha: 0.1),
                  foregroundColor: AppColors.deleteIconRed,
                  isLoading: isDeleteLoading,
                  onPressed: isDeleteLoading
                      ? null
                      : (onDelete != null ? () => onDelete!(unit) : null),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.value,
    required this.isDark,
  });

  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final subtitleColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Wrap(
      spacing: 4.w,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          '$label:',
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 11.sp,
            color: subtitleColor,
          ),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 0.4.sw),
          child: DigifyCapsule(
            label: value,
            backgroundColor:
                isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
            textColor: subtitleColor,
          ),
        ),
      ],
    );
  }
}
