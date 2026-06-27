import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/enterprise_structure/data/config/manage_org_units_table_config.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/org_units_table_width_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_component_values/manage_component_values_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrgUnitsTableRow extends ConsumerWidget with ManageComponentValuesPermissionMixin {
  final OrgStructureLevel unit;
  final int index;
  final bool isDark;
  final AppLocalizations localizations;
  final Function(OrgStructureLevel)? onView;
  final Function(OrgStructureLevel)? onEdit;
  final Function(OrgStructureLevel)? onDelete;
  final bool isDeleteLoading;

  const OrgUnitsTableRow({
    super.key,
    required this.unit,
    required this.index,
    required this.isDark,
    required this.localizations,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.isDeleteLoading = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyle = context.textTheme.labelMedium?.copyWith(
      fontSize: 14.sp,
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
    );
    final secondaryStyle = context.textTheme.bodySmall?.copyWith(
      fontSize: 12.sp,
      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
    );
    final widths = ref.watch(orgUnitsTableWidthsProvider);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (canViewComponentValue && onView != null) ? () => onView!(unit) : null,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Row(
                  children: [
                    if (ManageOrgUnitsTableConfig.showIndex) _buildDivider(widths.index),
                    if (ManageOrgUnitsTableConfig.showOrgStructure) _buildDivider(widths.orgStructure),
                    if (ManageOrgUnitsTableConfig.showEnterpriseId) _buildDivider(widths.enterpriseId),
                    if (ManageOrgUnitsTableConfig.showLevelCode) _buildDivider(widths.levelCode),
                    if (ManageOrgUnitsTableConfig.showOrgUnitCode) _buildDivider(widths.orgUnitCode),
                    if (ManageOrgUnitsTableConfig.showNameEn) _buildDivider(widths.nameEn),
                    if (ManageOrgUnitsTableConfig.showNameAr) _buildDivider(widths.nameAr),
                    if (ManageOrgUnitsTableConfig.showParent) _buildDivider(widths.parent),
                    if (ManageOrgUnitsTableConfig.showManager) _buildDivider(widths.manager),
                    if (ManageOrgUnitsTableConfig.showLocation) _buildDivider(widths.location),
                    if (ManageOrgUnitsTableConfig.showActive) _buildDivider(widths.active),
                    if (ManageOrgUnitsTableConfig.showLastUpdated) _buildDivider(widths.lastUpdated),
                    if (ManageOrgUnitsTableConfig.showActions) _buildDivider(widths.actions, isLast: true),
                  ],
                ),
              ),
              Row(
                children: [
                  if (ManageOrgUnitsTableConfig.showIndex)
                    _buildDataCell(Text('$index', style: textStyle), widths.index),
                  if (ManageOrgUnitsTableConfig.showOrgStructure)
                    _buildDataCell(Text(unit.orgStructureName ?? '-', style: textStyle), widths.orgStructure),
                  if (ManageOrgUnitsTableConfig.showEnterpriseId)
                    _buildDataCell(Text(unit.enterpriseId.toString(), style: textStyle), widths.enterpriseId),
                  if (ManageOrgUnitsTableConfig.showLevelCode)
                    _buildDataCell(Text(unit.levelCode, style: secondaryStyle), widths.levelCode),
                  if (ManageOrgUnitsTableConfig.showOrgUnitCode)
                    _buildDataCell(Text(unit.orgUnitCode, style: textStyle), widths.orgUnitCode),
                  if (ManageOrgUnitsTableConfig.showNameEn)
                    _buildDataCell(Text(unit.orgUnitNameEn, style: textStyle), widths.nameEn),
                  if (ManageOrgUnitsTableConfig.showNameAr)
                    _buildDataCell(
                      unit.orgUnitNameAr.isNotEmpty
                          ? Text(unit.orgUnitNameAr, style: textStyle, textDirection: TextDirection.rtl)
                          : Text('-', style: secondaryStyle),
                      widths.nameAr,
                    ),
                  if (ManageOrgUnitsTableConfig.showParent)
                    _buildDataCell(Text(unit.parentUnit?.name ?? '-', style: secondaryStyle), widths.parent),
                  if (ManageOrgUnitsTableConfig.showManager)
                    _buildDataCell(Text(unit.managerName, style: textStyle), widths.manager),
                  if (ManageOrgUnitsTableConfig.showLocation)
                    _buildDataCell(Text(unit.location, style: textStyle), widths.location),
                  if (ManageOrgUnitsTableConfig.showActive) _buildDataCell(_buildStatusBadge(), widths.active),
                  if (ManageOrgUnitsTableConfig.showLastUpdated)
                    _buildDataCell(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(unit.lastUpdatedDate, style: textStyle),
                          Text('by HR Admin', style: secondaryStyle),
                        ],
                      ),
                      widths.lastUpdated,
                    ),
                  if (ManageOrgUnitsTableConfig.showActions)
                    _buildDataCell(
                      Row(
                        spacing: 8.w,
                        children: [
                          if (canViewComponentValue)
                            ActionButtonWidget(
                              type: ActionButtonType.view,
                              onTap: onView != null ? () => onView!(unit) : null,
                              width: 18.w,
                              height: 18.w,
                              padding: 6.w,
                              borderRadius: BorderRadius.circular(6.r),
                              customBorder: null,
                            ),
                          if (canUpdateComponentValue)
                            ActionButtonWidget(
                              type: ActionButtonType.edit,
                              onTap: onEdit != null ? () => onEdit!(unit) : null,
                              width: 18.w,
                              height: 18.w,
                              padding: 6.w,
                              borderRadius: BorderRadius.circular(6.r),
                              customBorder: null,
                            ),
                          if (canDeleteComponentValue)
                            ActionButtonWidget(
                              type: ActionButtonType.delete,
                              onTap: isDeleteLoading ? null : (onDelete != null ? () => onDelete!(unit) : null),
                              isLoading: isDeleteLoading,
                              width: 18.w,
                              height: 18.w,
                              padding: 6.w,
                              borderRadius: BorderRadius.circular(6.r),
                              customBorder: null,
                            ),
                        ],
                      ),
                      widths.actions,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return DigifyStatusCapsule(
      status: unit.isActive ? localizations.active.toUpperCase() : localizations.inactive.toUpperCase(),
    );
  }

  Widget _buildDataCell(Widget child, double width) {
    return Container(
      width: width,
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: ManageOrgUnitsTableConfig.cellPaddingHorizontal.w,
        vertical: 16.h,
      ),
      alignment: Alignment.centerLeft,
      child: child,
    );
  }

  Widget _buildDivider(double width, {bool isLast = false}) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                right: BorderSide(color: AppColors.cardBorder, width: 1.w),
              ),
      ),
    );
  }
}
