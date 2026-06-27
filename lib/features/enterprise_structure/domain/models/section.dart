import 'package:flutter/foundation.dart';

@immutable
class SectionOverview {
  final String id;
  final String name;
  final String nameArabic;
  final String code;
  final String departmentName;
  final String businessUnitName;
  final String divisionName;
  final String companyName;
  final String headName;
  final String? headEmail;
  final String? headPhone;
  final bool isActive;
  final int employees;
  final String budget;
  final String focusArea;

  const SectionOverview({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.code,
    required this.departmentName,
    required this.businessUnitName,
    required this.divisionName,
    required this.companyName,
    required this.headName,
    this.headEmail,
    this.headPhone,
    required this.isActive,
    required this.employees,
    required this.budget,
    required this.focusArea,
  });
}

