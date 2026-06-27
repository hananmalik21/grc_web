import 'package:grc/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:flutter/foundation.dart';

@immutable
class BusinessUnitOverview {
  final String id;
  final String name;
  final String nameArabic;
  final String code;
  final String divisionName;
  final String companyName;
  final String headName;
  final String? headEmail;
  final String? headPhone;
  final bool isActive;
  final int employees;
  final int departments;
  final String budget;
  final String focusArea;
  final String location;
  final String city;
  final String? establishedDate;
  final String? description;

  const BusinessUnitOverview({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.code,
    required this.divisionName,
    required this.companyName,
    required this.headName,
    this.headEmail,
    this.headPhone,
    required this.isActive,
    required this.employees,
    required this.departments,
    required this.budget,
    required this.focusArea,
    required this.location,
    required this.city,
    this.establishedDate,
    this.description,
  });
}

/// Paginated response for business units
class PaginatedBusinessUnits {
  final List<BusinessUnitOverview> businessUnits;
  final PaginationInfo pagination;
  final int total;
  final int count;

  const PaginatedBusinessUnits({
    required this.businessUnits,
    required this.pagination,
    required this.total,
    required this.count,
  });
}

