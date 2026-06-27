import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/enterprise_structure/data/config/manage_org_units_table_config.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/org_units_table_width_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrgUnitsTableHeader extends ConsumerWidget {
  final bool isDark;

  const OrgUnitsTableHeader({super.key, required this.isDark});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerColor = isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground;
    final widths = ref.watch(orgUnitsTableWidthsProvider);

    final headerCells = <Widget>[];

    if (ManageOrgUnitsTableConfig.showIndex) {
      headerCells.add(_buildHeaderCell(context, '#', widths.index, OrgUnitsColumn.rowNumber, ref));
    }
    if (ManageOrgUnitsTableConfig.showOrgStructure) {
      headerCells.add(
        _buildHeaderCell(context, 'Org Structure', widths.orgStructure, OrgUnitsColumn.orgStructure, ref),
      );
    }
    if (ManageOrgUnitsTableConfig.showEnterpriseId) {
      headerCells.add(
        _buildHeaderCell(context, 'Enterprise Id', widths.enterpriseId, OrgUnitsColumn.enterpriseId, ref),
      );
    }
    if (ManageOrgUnitsTableConfig.showLevelCode) {
      headerCells.add(_buildHeaderCell(context, 'Level Code', widths.levelCode, OrgUnitsColumn.levelCode, ref));
    }
    if (ManageOrgUnitsTableConfig.showOrgUnitCode) {
      headerCells.add(_buildHeaderCell(context, 'Org Unit Code', widths.orgUnitCode, OrgUnitsColumn.orgUnitCode, ref));
    }
    if (ManageOrgUnitsTableConfig.showNameEn) {
      headerCells.add(_buildHeaderCell(context, 'Name (En)', widths.nameEn, OrgUnitsColumn.nameEn, ref));
    }
    if (ManageOrgUnitsTableConfig.showNameAr) {
      headerCells.add(_buildHeaderCell(context, 'Name (Ar)', widths.nameAr, OrgUnitsColumn.nameAr, ref));
    }
    if (ManageOrgUnitsTableConfig.showParent) {
      headerCells.add(_buildHeaderCell(context, 'Parent', widths.parent, OrgUnitsColumn.parent, ref));
    }
    if (ManageOrgUnitsTableConfig.showManager) {
      headerCells.add(_buildHeaderCell(context, 'Manager', widths.manager, OrgUnitsColumn.manager, ref));
    }
    if (ManageOrgUnitsTableConfig.showLocation) {
      headerCells.add(_buildHeaderCell(context, 'Location', widths.location, OrgUnitsColumn.location, ref));
    }
    if (ManageOrgUnitsTableConfig.showActive) {
      headerCells.add(_buildHeaderCell(context, 'Active', widths.active, OrgUnitsColumn.active, ref));
    }
    if (ManageOrgUnitsTableConfig.showLastUpdated) {
      headerCells.add(_buildHeaderCell(context, 'Last Updated', widths.lastUpdated, OrgUnitsColumn.lastUpdated, ref));
    }
    if (ManageOrgUnitsTableConfig.showActions) {
      headerCells.add(_buildHeaderCell(context, 'Actions', widths.actions, OrgUnitsColumn.actions, ref, isLast: true));
    }

    return Container(
      color: headerColor,
      child: Row(children: headerCells),
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String text,
    double width,
    OrgUnitsColumn column,
    WidgetRef ref, {
    bool isLast = false,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: isLast ? Colors.transparent : AppColors.cardBorder, width: 1.w),
          bottom: BorderSide(color: AppColors.cardBorder, width: 1.w),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: ManageOrgUnitsTableConfig.cellPaddingHorizontal.w,
              vertical: 14.h,
            ),
            alignment: Alignment.centerLeft,
            child: Text(
              text.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.labelSmall?.copyWith(
                color: AppColors.tableHeaderText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (!isLast)
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              width: 15.w,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (details) {
                  ref.read(orgUnitsTableWidthsProvider.notifier).updateWidth(column, details.delta.dx);
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeColumn,
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
