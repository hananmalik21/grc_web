import 'package:flutter/foundation.dart';

@immutable
class DivisionOverview {
  final String id;
  final String name;
  final String nameArabic;
  final String code;
  final String companyName;
  final String headName;
  final bool isActive;
  final int employees;
  final int departments;
  final String budget;
  final String location;
  final String industry;
  final String? headEmail;
  final String? headPhone;
  final String? address;
  final String? city;
  final String? establishedDate;
  final String? description;
  final int? companyId;

  const DivisionOverview({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.code,
    required this.companyName,
    required this.headName,
    required this.isActive,
    required this.employees,
    required this.departments,
    required this.budget,
    required this.location,
    required this.industry,
    this.headEmail,
    this.headPhone,
    this.address,
    this.city,
    this.establishedDate,
    this.description,
    this.companyId,
  });
}

