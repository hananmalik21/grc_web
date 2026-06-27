import 'package:grc/core/enums/enterprise_structure_enums.dart';
import 'package:flutter/foundation.dart';

@immutable
class OrgUnitTreeNode {
  final String orgUnitId;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;
  final String levelCode;
  final String? parentOrgUnitId;
  final String parentName;
  final String managerName;
  final String location;
  final String lastUpdatedDate;
  final bool isActive;
  final List<OrgUnitTreeNode> children;

  const OrgUnitTreeNode({
    required this.orgUnitId,
    required this.orgUnitCode,
    required this.orgUnitNameEn,
    required this.orgUnitNameAr,
    required this.levelCode,
    this.parentOrgUnitId,
    required this.parentName,
    required this.managerName,
    required this.location,
    required this.lastUpdatedDate,
    required this.isActive,
    required this.children,
  });

  String get displayName => orgUnitNameEn.isNotEmpty ? orgUnitNameEn : orgUnitNameAr;

  OrganizationLevel get level => OrganizationLevel.fromCode(levelCode);
}

@immutable
class OrgUnitTree {
  final String structureId;
  final String structureName;
  final List<OrgUnitTreeNode> tree;

  const OrgUnitTree({required this.structureId, required this.structureName, required this.tree});

  factory OrgUnitTree.mock() {
    return OrgUnitTree(
      structureId: '0',
      structureName: 'Loading...',
      tree: List.generate(
        5,
        (i) => OrgUnitTreeNode(
          orgUnitId: 'node_$i',
          orgUnitCode: 'CODE-$i',
          orgUnitNameEn: 'Loading Org Unit Name $i',
          orgUnitNameAr: 'تحميل الوحدة $i',
          levelCode: 'COMPANY',
          parentOrgUnitId: null,
          parentName: '-',
          managerName: 'Manager Name',
          location: 'Location Name',
          lastUpdatedDate: '2024-01-01',
          isActive: true,
          children: [],
        ),
      ),
    );
  }
}
