import 'package:flutter/foundation.dart';

@immutable
class CompanyOverview {
  final String id;
  final String name;
  final String nameArabic;
  final String entityCode;
  final String registrationNumber;
  final bool isActive;
  final int employees;
  final String location;
  final String industry;
  final String phone;
  final String email;
  final String? legalNameEn;
  final String? legalNameAr;
  final String? taxId;
  final String? establishedDate;
  final String? country;
  final String? city;
  final String? address;
  final String? poBox;
  final String? zipCode;
  final String? website;
  final String? currencyCode;
  final String? fiscalYearStart;
  final String? orgStructureId;

  const CompanyOverview({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.entityCode,
    required this.registrationNumber,
    required this.isActive,
    required this.employees,
    required this.location,
    required this.industry,
    required this.phone,
    required this.email,
    this.legalNameEn,
    this.legalNameAr,
    this.taxId,
    this.establishedDate,
    this.country,
    this.city,
    this.address,
    this.poBox,
    this.zipCode,
    this.website,
    this.currencyCode,
    this.fiscalYearStart,
    this.orgStructureId,
  });
}

