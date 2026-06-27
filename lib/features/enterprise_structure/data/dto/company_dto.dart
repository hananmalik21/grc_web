import 'package:grc/features/enterprise_structure/domain/models/company.dart';

/// DTO for Company
class CompanyDto {
  final String id;
  final String name;
  final String? nameArabic;
  final String? entityCode;
  final String? registrationNumber;
  final bool isActive;
  final int? employees;
  final String? location;
  final String? industry;
  final String? phone;
  final String? email;
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

  const CompanyDto({
    required this.id,
    required this.name,
    this.nameArabic,
    this.entityCode,
    this.registrationNumber,
    required this.isActive,
    this.employees,
    this.location,
    this.industry,
    this.phone,
    this.email,
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

  /// Creates DTO from JSON
  factory CompanyDto.fromJson(Map<String, dynamic> json) {
    // Parse company_id (can be int or string)
    final companyId = (json['company_id'] as num?)?.toString() ??
        (json['company_id'] as String?) ??
        (json['id'] as num?)?.toString() ??
        (json['id'] as String?) ??
        '';

    // Parse company_name_en (primary name field from API)
    final companyName = json['company_name_en'] as String? ??
        json['company_name'] as String? ??
        json['name'] as String? ??
        json['name_en'] as String? ??
        '';

    // Parse company_name_ar (Arabic name field from API)
    final companyNameArabic = json['company_name_ar'] as String? ??
        json['company_name_arabic'] as String? ??
        json['name_arabic'] as String? ??
        json['name_ar'] as String?;

    // Parse company_code
    final companyCode = json['company_code'] as String? ??
        json['entity_code'] as String? ??
        json['code'] as String?;

    // Parse registration_number
    final registrationNum = json['registration_number'] as String? ??
        json['registrationNumber'] as String?;

    // Parse status - API returns "Active" or "Inactive" string
    final statusValue = json['status'] as String? ??
        json['is_active'] ??
        json['isActive'];
    final isActive = statusValue is bool
        ? statusValue
        : (statusValue?.toString().toUpperCase() == 'ACTIVE' ||
            statusValue?.toString().toUpperCase() == 'Y' ||
            statusValue?.toString() == 'true');

    // Parse total_employees (primary field from API)
    final employeesCount = (json['total_employees'] as num?)?.toInt() ??
        (json['employees'] as num?)?.toInt() ??
        (json['employee_count'] as num?)?.toInt() ??
        0;

    // Parse location (for display, can be city + country or address)
    final companyLocation = json['location'] as String? ??
        (json['city'] != null && json['country'] != null
            ? '${json['city']}, ${json['country']}'
            : json['address'] as String?);

    // Parse industry
    final companyIndustry = json['industry'] as String? ??
        json['sector'] as String?;

    // Parse phone
    final companyPhone = json['phone'] as String? ??
        json['phone_number'] as String?;

    // Parse email
    final companyEmail = json['email'] as String? ??
        json['email_address'] as String?;

    // Parse additional fields - prioritize lowercase with underscores (API format)
    final legalNameEn = json['legal_name_en'] as String? ??
        json['legalNameEn'] as String? ??
        json['LEGAL_NAME_EN'] as String?;
    
    final legalNameAr = json['legal_name_ar'] as String? ??
        json['legalNameAr'] as String? ??
        json['LEGAL_NAME_AR'] as String?;
    
    final taxId = json['tax_id'] as String? ??
        json['taxId'] as String? ??
        json['TAX_ID'] as String?;
    
    // Parse established_date - handle ISO format (2020-01-15T00:00:00.000Z)
    final establishedDateRaw = json['established_date'] as String? ??
        json['establishedDate'] as String? ??
        json['ESTABLISHED_DATE'] as String?;
    String? establishedDate = establishedDateRaw;
    if (establishedDateRaw != null && establishedDateRaw.isNotEmpty) {
      if (establishedDateRaw.contains('T')) {
        // Extract date part from ISO format (YYYY-MM-DD)
        establishedDate = establishedDateRaw.split('T').first;
      } else if (establishedDateRaw.contains(' ')) {
        // Handle space-separated format
        establishedDate = establishedDateRaw.split(' ').first;
      }
    }
    
    final country = json['country'] as String? ??
        json['COUNTRY'] as String?;
    
    final city = json['city'] as String? ??
        json['CITY'] as String?;
    
    // Parse address - prioritize lowercase with underscores (API format)
    final address = json['address'] as String? ??
        json['ADDRESS'] as String?;
    
    final poBox = json['po_box'] as String? ??
        json['poBox'] as String? ??
        json['PO_BOX'] as String?;
    
    final zipCode = json['zip_code'] as String? ??
        json['zipCode'] as String? ??
        json['ZIP_CODE'] as String?;
    
    final website = json['website'] as String? ??
        json['WEBSITE'] as String?;
    
    final currencyCode = json['currency_code'] as String? ??
        json['currencyCode'] as String? ??
        json['CURRENCY_CODE'] as String?;
    
    final fiscalYearStart = json['fiscal_year_start'] as String? ??
        json['fiscalYearStart'] as String? ??
        json['FISCAL_YEAR_START'] as String?;
    
    final orgStructureId = (json['org_structure_id'] as String?) ??
        (json['org_structure_id'] as num?)?.toString() ??
        (json['orgStructureId'] as String?) ??
        (json['orgStructureId'] as num?)?.toString() ??
        (json['ORG_STRUCTURE_ID'] as String?) ??
        (json['ORG_STRUCTURE_ID'] as num?)?.toString();

    return CompanyDto(
      id: companyId,
      name: companyName,
      nameArabic: companyNameArabic,
      entityCode: companyCode,
      registrationNumber: registrationNum,
      isActive: isActive,
      employees: employeesCount,
      location: companyLocation,
      industry: companyIndustry,
      phone: companyPhone,
      email: companyEmail,
      legalNameEn: legalNameEn,
      legalNameAr: legalNameAr,
      taxId: taxId,
      establishedDate: establishedDate,
      country: country,
      city: city,
      address: address,
      poBox: poBox,
      zipCode: zipCode,
      website: website,
      currencyCode: currencyCode,
      fiscalYearStart: fiscalYearStart,
      orgStructureId: orgStructureId,
    );
  }

  /// Converts DTO to domain model
  CompanyOverview toDomain() {
    return CompanyOverview(
      id: id,
      name: name,
      nameArabic: nameArabic ?? '',
      entityCode: entityCode ?? '',
      registrationNumber: registrationNumber ?? '',
      isActive: isActive,
      employees: employees ?? 0,
      location: location ?? '',
      industry: industry ?? '',
      phone: phone ?? '',
      email: email ?? '',
      legalNameEn: legalNameEn,
      legalNameAr: legalNameAr,
      taxId: taxId,
      establishedDate: establishedDate,
      country: country,
      city: city,
      address: address,
      poBox: poBox,
      zipCode: zipCode,
      website: website,
      currencyCode: currencyCode,
      fiscalYearStart: fiscalYearStart,
      orgStructureId: orgStructureId,
    );
  }

  /// Creates JSON from DTO
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (entityCode != null) 'entity_code': entityCode,
      if (registrationNumber != null) 'registration_number': registrationNumber,
      'is_active': isActive,
      if (employees != null) 'employees': employees,
      if (location != null) 'location': location,
      if (industry != null) 'industry': industry,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
    };
  }
}

