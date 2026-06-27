import 'package:grc/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:flutter/foundation.dart';

@immutable
class DepartmentOverview {
  final String id;
  final String name;
  final String nameArabic;
  final String code;
  final String businessUnitName;
  final String divisionName;
  final String companyName;
  final String headName;
  final String? headEmail;
  final String? headPhone;
  final bool isActive;
  final int employees;
  final int sections;
  final String budget;
  final String focusArea;

  const DepartmentOverview({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.code,
    required this.businessUnitName,
    required this.divisionName,
    required this.companyName,
    required this.headName,
    this.headEmail,
    this.headPhone,
    required this.isActive,
    required this.employees,
    required this.sections,
    required this.budget,
    required this.focusArea,
  });
}

/// Paginated response for departments
class PaginatedDepartments {
  final List<DepartmentOverview> departments;
  final PaginationInfo pagination;
  final int total;
  final int count;

  const PaginatedDepartments({
    required this.departments,
    required this.pagination,
    required this.total,
    required this.count,
  });
}
