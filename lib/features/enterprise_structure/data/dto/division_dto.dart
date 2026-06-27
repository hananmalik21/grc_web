import 'package:grc/features/enterprise_structure/domain/models/division.dart';

/// DTO for Division
class DivisionDto {
  final String id;
  final String name;
  final String? nameArabic;
  final String? code;
  final String? companyName;
  final String? headName;
  final bool isActive;
  final int? employees;
  final int? departments;
  final String? budget;
  final String? location;
  final String? industry;
  final String? headEmail;
  final String? headPhone;
  final String? address;
  final String? city;
  final String? establishedDate;
  final String? description;
  final int? companyId;

  const DivisionDto({
    required this.id,
    required this.name,
    this.nameArabic,
    this.code,
    this.companyName,
    this.headName,
    required this.isActive,
    this.employees,
    this.departments,
    this.budget,
    this.location,
    this.industry,
    this.headEmail,
    this.headPhone,
    this.address,
    this.city,
    this.establishedDate,
    this.description,
    this.companyId,
  });

  /// Creates DTO from JSON
  factory DivisionDto.fromJson(Map<String, dynamic> json) {
    // Parse division_id (can be int or string)
    final divisionId = (json['division_id'] as num?)?.toString() ??
        (json['division_id'] as String?) ??
        (json['id'] as num?)?.toString() ??
        (json['id'] as String?) ??
        '';

    // Parse division_name_en (primary name field from API)
    final divisionName = json['division_name_en'] as String? ??
        json['division_name'] as String? ??
        json['name'] as String? ??
        json['name_en'] as String? ??
        '';

    // Parse division_name_ar (Arabic name field from API)
    final divisionNameArabic = json['division_name_ar'] as String? ??
        json['division_name_arabic'] as String? ??
        json['name_arabic'] as String? ??
        json['name_ar'] as String?;

    // Parse division_code
    final divisionCode = json['division_code'] as String? ??
        json['code'] as String?;

    // Parse company_name (prioritize company_name_en from API)
    final companyName = json['company_name_en'] as String? ??
        json['company_name'] as String?;

    // Parse head_of_division (API uses head_of_division)
    final headName = json['head_of_division'] as String? ??
        json['head_name'] as String? ??
        json['head'] as String? ??
        json['manager'] as String?;

    // Parse status - API returns "Active" or "Inactive" string
    final statusValue = json['status'] as String? ??
        json['is_active'] ??
        json['isActive'];
    final isActive = statusValue is bool
        ? statusValue
        : (statusValue?.toString().toUpperCase() == 'ACTIVE' ||
            statusValue?.toString().toUpperCase() == 'Y' ||
            statusValue?.toString() == 'true');

    // Parse total_employees
    final employeesCount = (json['total_employees'] as num?)?.toInt() ??
        (json['employees'] as num?)?.toInt() ??
        (json['employee_count'] as num?)?.toInt() ??
        0;

    // Parse total_departments
    final departmentsCount = (json['total_departments'] as num?)?.toInt() ??
        (json['departments'] as num?)?.toInt() ??
        (json['department_count'] as num?)?.toInt() ??
        0;

    // Parse annual_budget_kwd (API uses annual_budget_kwd)
    final divisionBudget = json['annual_budget_kwd'] != null
        ? (json['annual_budget_kwd'] is num
            ? json['annual_budget_kwd'].toString()
            : json['annual_budget_kwd'] as String?)
        : (json['budget'] as String? ??
            json['annual_budget'] as String?);

    // Parse location
    final divisionLocation = json['location'] as String? ??
        (json['city'] != null && json['country'] != null
            ? '${json['city']}, ${json['country']}'
            : json['address'] as String?);

    // Parse business_focus (API uses business_focus, not industry)
    final divisionIndustry = json['business_focus'] as String? ??
        json['industry'] as String? ??
        json['sector'] as String?;

    // Parse head_email
    final headEmail = json['head_email'] as String? ??
        json['headEmail'] as String? ??
        json['manager_email'] as String?;

    // Parse head_phone
    final headPhone = json['head_phone'] as String? ??
        json['headPhone'] as String? ??
        json['manager_phone'] as String?;

    // Parse address
    final divisionAddress = json['address'] as String? ??
        json['ADDRESS'] as String?;

    // Parse city
    final divisionCity = json['city'] as String? ??
        json['CITY'] as String?;

    // Parse established_date - handle ISO format
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

    // Parse description
    final divisionDescription = json['description'] as String? ??
        json['DESCRIPTION'] as String?;

    // Parse company_id
    final companyId = (json['company_id'] as num?)?.toInt() ??
        (json['companyId'] as num?)?.toInt() ??
        (json['COMPANY_ID'] as num?)?.toInt();

    return DivisionDto(
      id: divisionId,
      name: divisionName,
      nameArabic: divisionNameArabic,
      code: divisionCode,
      companyName: companyName,
      headName: headName,
      isActive: isActive,
      employees: employeesCount,
      departments: departmentsCount,
      budget: divisionBudget,
      location: divisionLocation,
      industry: divisionIndustry,
      headEmail: headEmail,
      headPhone: headPhone,
      address: divisionAddress,
      city: divisionCity,
      establishedDate: establishedDate,
      description: divisionDescription,
      companyId: companyId,
    );
  }

  /// Converts DTO to domain model
  DivisionOverview toDomain() {
    return DivisionOverview(
      id: id,
      name: name,
      nameArabic: nameArabic ?? '',
      code: code ?? '',
      companyName: companyName ?? '',
      headName: headName ?? '',
      isActive: isActive,
      employees: employees ?? 0,
      departments: departments ?? 0,
      budget: budget ?? '',
      location: location ?? '',
      industry: industry ?? '',
      headEmail: headEmail,
      headPhone: headPhone,
      address: address,
      city: city,
      establishedDate: establishedDate,
      description: description,
      companyId: companyId,
    );
  }

  /// Creates JSON from DTO
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (code != null) 'code': code,
      if (companyName != null) 'company_name': companyName,
      if (headName != null) 'head_name': headName,
      'is_active': isActive,
      if (employees != null) 'employees': employees,
      if (departments != null) 'departments': departments,
      if (budget != null) 'budget': budget,
      if (location != null) 'location': location,
      if (industry != null) 'industry': industry,
      if (headEmail != null) 'head_email': headEmail,
      if (headPhone != null) 'head_phone': headPhone,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (establishedDate != null) 'established_date': establishedDate,
      if (description != null) 'description': description,
      if (companyId != null) 'company_id': companyId,
    };
  }
}

