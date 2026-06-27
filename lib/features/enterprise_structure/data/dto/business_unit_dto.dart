import 'package:grc/features/enterprise_structure/domain/models/business_unit.dart';
import 'package:grc/features/enterprise_structure/domain/models/structure_list_item.dart';

/// DTO for Business Unit
class BusinessUnitDto {
  final String id;
  final String name;
  final String? nameArabic;
  final String? code;
  final String? divisionName;
  final String? divisionNameArabic;
  final String? companyName;
  final String? companyNameArabic;
  final String? headName;
  final bool isActive;
  final int? employees;
  final int? departments;
  final String? budget;
  final String? focusArea;
  final String? location;
  final String? city;
  final String? headEmail;
  final String? headPhone;
  final String? establishedDate;
  final String? description;
  final int? companyId;
  final int? divisionId;

  const BusinessUnitDto({
    required this.id,
    required this.name,
    this.nameArabic,
    this.code,
    this.divisionName,
    this.divisionNameArabic,
    this.companyName,
    this.companyNameArabic,
    this.headName,
    required this.isActive,
    this.employees,
    this.departments,
    this.budget,
    this.focusArea,
    this.location,
    this.city,
    this.headEmail,
    this.headPhone,
    this.establishedDate,
    this.description,
    this.companyId,
    this.divisionId,
  });

  /// Creates DTO from JSON
  factory BusinessUnitDto.fromJson(Map<String, dynamic> json) {
    // Parse business_unit_id (can be int or string)
    final businessUnitId = (json['business_unit_id'] as num?)?.toString() ??
        (json['business_unit_id'] as String?) ??
        (json['id'] as num?)?.toString() ??
        (json['id'] as String?) ??
        '';

    // Parse unit_name_en (primary name field from API)
    final unitName = json['unit_name_en'] as String? ??
        json['unit_name'] as String? ??
        json['name'] as String? ??
        json['name_en'] as String? ??
        '';

    // Parse unit_name_ar (Arabic name field from API)
    final unitNameArabic = json['unit_name_ar'] as String? ??
        json['unit_name_arabic'] as String? ??
        json['name_arabic'] as String? ??
        json['name_ar'] as String?;

    // Parse unit_code
    final unitCode = json['unit_code'] as String? ??
        json['code'] as String?;

    // Parse division_name_en
    final divisionName = json['division_name_en'] as String? ??
        json['division_name'] as String?;

    // Parse division_name_ar
    final divisionNameArabic = json['division_name_ar'] as String? ??
        json['division_name_arabic'] as String?;

    // Parse company_name_en
    final companyName = json['company_name_en'] as String? ??
        json['company_name'] as String?;

    // Parse company_name_ar
    final companyNameArabic = json['company_name_ar'] as String? ??
        json['company_name_arabic'] as String?;

    // Parse head_of_unit
    final headName = json['head_of_unit'] as String? ??
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
    final unitBudget = json['annual_budget_kwd'] != null
        ? (json['annual_budget_kwd'] is num
            ? json['annual_budget_kwd'].toString()
            : json['annual_budget_kwd'] as String?)
        : (json['budget'] as String? ??
            json['annual_budget'] as String?);

    // Parse business_focus (API uses business_focus)
    final unitFocusArea = json['business_focus'] as String? ??
        json['focus_area'] as String? ??
        json['focus'] as String?;

    // Parse location
    final unitLocation = json['location'] as String? ??
        json['address'] as String?;

    // Parse city
    final unitCity = json['city'] as String?;

    // Parse head_email
    final headEmail = json['head_email'] as String? ??
        json['headEmail'] as String? ??
        json['manager_email'] as String?;

    // Parse head_phone
    final headPhone = json['head_phone'] as String? ??
        json['headPhone'] as String? ??
        json['manager_phone'] as String?;

    // Parse established_date - handle ISO format
    final establishedDateRaw = json['established_date'] as String? ??
        json['establishedDate'] as String?;
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
    final unitDescription = json['description'] as String?;

    // Parse company_id
    final companyId = (json['company_id'] as num?)?.toInt() ??
        (json['companyId'] as num?)?.toInt();

    // Parse division_id
    final divisionId = (json['division_id'] as num?)?.toInt() ??
        (json['divisionId'] as num?)?.toInt();

    return BusinessUnitDto(
      id: businessUnitId,
      name: unitName,
      nameArabic: unitNameArabic,
      code: unitCode,
      divisionName: divisionName,
      divisionNameArabic: divisionNameArabic,
      companyName: companyName,
      companyNameArabic: companyNameArabic,
      headName: headName,
      isActive: isActive,
      employees: employeesCount,
      departments: departmentsCount,
      budget: unitBudget,
      focusArea: unitFocusArea,
      location: unitLocation,
      city: unitCity,
      headEmail: headEmail,
      headPhone: headPhone,
      establishedDate: establishedDate,
      description: unitDescription,
      companyId: companyId,
      divisionId: divisionId,
    );
  }

  /// Converts DTO to domain model
  BusinessUnitOverview toDomain() {
    return BusinessUnitOverview(
      id: id,
      name: name,
      nameArabic: nameArabic ?? '',
      code: code ?? '',
      divisionName: divisionName ?? '',
      companyName: companyName ?? '',
      headName: headName ?? '',
      headEmail: headEmail,
      headPhone: headPhone,
      isActive: isActive,
      employees: employees ?? 0,
      departments: departments ?? 0,
      budget: budget ?? '',
      focusArea: focusArea ?? '',
      location: location ?? '',
      city: city ?? '',
      establishedDate: establishedDate,
      description: description,
    );
  }

  /// Creates JSON from DTO
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (code != null) 'code': code,
      if (divisionName != null) 'division_name': divisionName,
      if (companyName != null) 'company_name': companyName,
      if (headName != null) 'head_name': headName,
      'is_active': isActive,
      if (employees != null) 'employees': employees,
      if (departments != null) 'departments': departments,
      if (budget != null) 'budget': budget,
      if (focusArea != null) 'focus_area': focusArea,
      if (location != null) 'location': location,
      if (city != null) 'city': city,
      if (headEmail != null) 'head_email': headEmail,
      if (headPhone != null) 'head_phone': headPhone,
      if (establishedDate != null) 'established_date': establishedDate,
      if (description != null) 'description': description,
      if (companyId != null) 'company_id': companyId,
      if (divisionId != null) 'division_id': divisionId,
    };
  }
}

/// DTO for pagination info
class PaginationInfoDto {
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const PaginationInfoDto({
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationInfoDto.fromJson(Map<String, dynamic> json) {
    return PaginationInfoDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ??
          (json['pageSize'] as num?)?.toInt() ??
          10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ??
          (json['totalPages'] as num?)?.toInt() ??
          1,
      hasNext: json['has_next'] as bool? ??
          json['hasNext'] as bool? ??
          false,
      hasPrevious: json['has_previous'] as bool? ??
          json['hasPrevious'] as bool? ??
          false,
    );
  }
}

/// DTO for paginated business units response
class PaginatedBusinessUnitsDto {
  final List<BusinessUnitDto> businessUnits;
  final PaginationInfoDto pagination;
  final int total;
  final int count;

  const PaginatedBusinessUnitsDto({
    required this.businessUnits,
    required this.pagination,
    required this.total,
    required this.count,
  });

  factory PaginatedBusinessUnitsDto.fromJson(Map<String, dynamic> json) {
    // Extract data array
    final data = json['data'] as List<dynamic>? ?? [];
    final businessUnits = data
        .map((item) => BusinessUnitDto.fromJson(item as Map<String, dynamic>))
        .toList();

    // Extract meta information
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = meta['pagination'] as Map<String, dynamic>? ?? {};
    final pagination = PaginationInfoDto.fromJson(paginationJson);

    final total = (meta['total'] as num?)?.toInt() ?? 0;
    final count = (meta['count'] as num?)?.toInt() ?? 0;

    return PaginatedBusinessUnitsDto(
      businessUnits: businessUnits,
      pagination: pagination,
      total: total,
      count: count,
    );
  }

  PaginatedBusinessUnits toDomain() {
    return PaginatedBusinessUnits(
      businessUnits: businessUnits.map((bu) => bu.toDomain()).toList(),
      pagination: _paginationToDomain(),
      total: total,
      count: count,
    );
  }

  PaginationInfo _paginationToDomain() {
    return PaginationInfo(
      page: pagination.page,
      pageSize: pagination.pageSize,
      total: pagination.total,
      totalPages: pagination.totalPages,
      hasNext: pagination.hasNext,
      hasPrevious: pagination.hasPrevious,
    );
  }
}

