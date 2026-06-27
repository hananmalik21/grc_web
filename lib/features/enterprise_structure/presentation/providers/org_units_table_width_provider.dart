import 'package:grc/features/enterprise_structure/data/config/manage_org_units_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum OrgUnitsColumn {
  rowNumber,
  orgStructure,
  enterpriseId,
  levelCode,
  orgUnitCode,
  nameEn,
  nameAr,
  parent,
  manager,
  location,
  active,
  lastUpdated,
  actions,
}

class OrgUnitsTableColumnWidths {
  final double? indexOverride;
  final double? orgStructureOverride;
  final double? enterpriseIdOverride;
  final double? levelCodeOverride;
  final double? orgUnitCodeOverride;
  final double? nameEnOverride;
  final double? nameArOverride;
  final double? parentOverride;
  final double? managerOverride;
  final double? locationOverride;
  final double? activeOverride;
  final double? lastUpdatedOverride;
  final double? actionsOverride;

  const OrgUnitsTableColumnWidths({
    this.indexOverride,
    this.orgStructureOverride,
    this.enterpriseIdOverride,
    this.levelCodeOverride,
    this.orgUnitCodeOverride,
    this.nameEnOverride,
    this.nameArOverride,
    this.parentOverride,
    this.managerOverride,
    this.locationOverride,
    this.activeOverride,
    this.lastUpdatedOverride,
    this.actionsOverride,
  });

  double get index => indexOverride ?? ManageOrgUnitsTableConfig.indexWidth.w;
  double get orgStructure => orgStructureOverride ?? ManageOrgUnitsTableConfig.orgStructureWidth.w;
  double get enterpriseId => enterpriseIdOverride ?? ManageOrgUnitsTableConfig.enterpriseIdWidth.w;
  double get levelCode => levelCodeOverride ?? ManageOrgUnitsTableConfig.levelCodeWidth.w;
  double get orgUnitCode => orgUnitCodeOverride ?? ManageOrgUnitsTableConfig.orgUnitCodeWidth.w;
  double get nameEn => nameEnOverride ?? ManageOrgUnitsTableConfig.nameEnWidth.w;
  double get nameAr => nameArOverride ?? ManageOrgUnitsTableConfig.nameArWidth.w;
  double get parent => parentOverride ?? ManageOrgUnitsTableConfig.parentWidth.w;
  double get manager => managerOverride ?? ManageOrgUnitsTableConfig.managerWidth.w;
  double get location => locationOverride ?? ManageOrgUnitsTableConfig.locationWidth.w;
  double get active => activeOverride ?? ManageOrgUnitsTableConfig.activeWidth.w;
  double get lastUpdated => lastUpdatedOverride ?? ManageOrgUnitsTableConfig.lastUpdatedWidth.w;
  double get actions => actionsOverride ?? ManageOrgUnitsTableConfig.actionsWidth.w;

  OrgUnitsTableColumnWidths copyWith({
    double? indexOverride,
    double? orgStructureOverride,
    double? enterpriseIdOverride,
    double? levelCodeOverride,
    double? orgUnitCodeOverride,
    double? nameEnOverride,
    double? nameArOverride,
    double? parentOverride,
    double? managerOverride,
    double? locationOverride,
    double? activeOverride,
    double? lastUpdatedOverride,
    double? actionsOverride,
  }) {
    return OrgUnitsTableColumnWidths(
      indexOverride: indexOverride ?? this.indexOverride,
      orgStructureOverride: orgStructureOverride ?? this.orgStructureOverride,
      enterpriseIdOverride: enterpriseIdOverride ?? this.enterpriseIdOverride,
      levelCodeOverride: levelCodeOverride ?? this.levelCodeOverride,
      orgUnitCodeOverride: orgUnitCodeOverride ?? this.orgUnitCodeOverride,
      nameEnOverride: nameEnOverride ?? this.nameEnOverride,
      nameArOverride: nameArOverride ?? this.nameArOverride,
      parentOverride: parentOverride ?? this.parentOverride,
      managerOverride: managerOverride ?? this.managerOverride,
      locationOverride: locationOverride ?? this.locationOverride,
      activeOverride: activeOverride ?? this.activeOverride,
      lastUpdatedOverride: lastUpdatedOverride ?? this.lastUpdatedOverride,
      actionsOverride: actionsOverride ?? this.actionsOverride,
    );
  }
}

final orgUnitsTableWidthsProvider = StateNotifierProvider<OrgUnitsTableWidthsNotifier, OrgUnitsTableColumnWidths>((
  ref,
) {
  return OrgUnitsTableWidthsNotifier();
});

class OrgUnitsTableWidthsNotifier extends StateNotifier<OrgUnitsTableColumnWidths> {
  OrgUnitsTableWidthsNotifier() : super(const OrgUnitsTableColumnWidths());

  void updateWidth(OrgUnitsColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(60.0, 600.0);

    switch (column) {
      case OrgUnitsColumn.rowNumber:
        state = state.copyWith(indexOverride: clampWidth(state.index));
        break;
      case OrgUnitsColumn.orgStructure:
        state = state.copyWith(orgStructureOverride: clampWidth(state.orgStructure));
        break;
      case OrgUnitsColumn.enterpriseId:
        state = state.copyWith(enterpriseIdOverride: clampWidth(state.enterpriseId));
        break;
      case OrgUnitsColumn.levelCode:
        state = state.copyWith(levelCodeOverride: clampWidth(state.levelCode));
        break;
      case OrgUnitsColumn.orgUnitCode:
        state = state.copyWith(orgUnitCodeOverride: clampWidth(state.orgUnitCode));
        break;
      case OrgUnitsColumn.nameEn:
        state = state.copyWith(nameEnOverride: clampWidth(state.nameEn));
        break;
      case OrgUnitsColumn.nameAr:
        state = state.copyWith(nameArOverride: clampWidth(state.nameAr));
        break;
      case OrgUnitsColumn.parent:
        state = state.copyWith(parentOverride: clampWidth(state.parent));
        break;
      case OrgUnitsColumn.manager:
        state = state.copyWith(managerOverride: clampWidth(state.manager));
        break;
      case OrgUnitsColumn.location:
        state = state.copyWith(locationOverride: clampWidth(state.location));
        break;
      case OrgUnitsColumn.active:
        state = state.copyWith(activeOverride: clampWidth(state.active));
        break;
      case OrgUnitsColumn.lastUpdated:
        state = state.copyWith(lastUpdatedOverride: clampWidth(state.lastUpdated));
        break;
      case OrgUnitsColumn.actions:
        state = state.copyWith(actionsOverride: clampWidth(state.actions));
        break;
    }
  }
}
