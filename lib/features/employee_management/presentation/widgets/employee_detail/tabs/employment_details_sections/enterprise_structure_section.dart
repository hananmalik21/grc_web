import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/employee_management/presentation/utils/employee_detail_formatters.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/employee_detail_bordered_section_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class EnterpriseStructureSection extends StatelessWidget {
  const EnterpriseStructureSection({super.key, required this.isDark, this.fullDetails});

  final bool isDark;
  final EmployeeFullDetails? fullDetails;

  static String _byLevel(List<OrgStructureItem> list, String levelCode) {
    final found = list.where((e) => e.levelCode == levelCode).toList();
    if (found.isEmpty) return '—';
    return displayValue(found.first.orgUnitNameEn);
  }

  @override
  Widget build(BuildContext context) {
    final list = fullDetails?.assignment.orgStructureList ?? [];
    final left = [
      EmployeeDetailBorderedField(label: 'Company', value: _byLevel(list, 'COMPANY')),
      EmployeeDetailBorderedField(label: 'Division', value: _byLevel(list, 'DIVISION')),
      EmployeeDetailBorderedField(label: 'Business Unit', value: _byLevel(list, 'BUSINESS_UNIT')),
    ];
    final right = [
      EmployeeDetailBorderedField(label: 'Department', value: _byLevel(list, 'DEPARTMENT')),
      EmployeeDetailBorderedField(label: 'Section', value: _byLevel(list, 'SECTION')),
    ];
    return EmployeeDetailBorderedSectionCard(
      title: 'Enterprise Structure',
      titleIconAssetPath: Assets.icons.enterpriseStructureIcon.path,
      leftColumnFields: left,
      rightColumnFields: right,
      isDark: isDark,
    );
  }
}
