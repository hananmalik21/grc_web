import 'package:grc/features/enterprise_structure/domain/models/department.dart';
import 'package:grc/features/enterprise_structure/domain/models/structure_list_item.dart';

/// DTO for Department
class DepartmentDto {
  final String id;
  final String name;
  final String? nameArabic;
  final String? code;
  final String? businessUnitName;
  final String? businessUnitNameArabic;
  final String? divisionName;
  final String? divisionNameArabic;
  final String? companyName;
  final String? companyNameArabic;
  final String? headName;
  final bool isActive;
  final int? employees;
  final int? sections;
  final String? budget;
  final String? headEmail;
  final String? headPhone;
  final String? description;
  final int? businessUnitId;
  final int? divisionId;
  final int? companyId;

  const DepartmentDto({
    required this.id,
    required this.name,
    this.nameArabic,
    this.code,
    this.businessUnitName,
    this.businessUnitNameArabic,
    this.divisionName,
    this.divisionNameArabic,
    this.companyName,
    this.companyNameArabic,
    this.headName,
    required this.isActive,
    this.employees,
    this.sections,
    this.budget,
    this.headEmail,
    this.headPhone,
    this.description,
    this.businessUnitId,
    this.divisionId,
    this.companyId,
  });

  /// Creates DTO from JSON
  factory DepartmentDto.fromJson(Map<String, dynamic> json) {
    // Parse department_id (can be int or string)
    final departmentId = (json['department_id'] as num?)?.toString() ??
        (json['department_id'] as String?) ??
        (json['id'] as num?)?.toString() ??
        (json['id'] as String?) ??
        '';

    // Parse department_name_en (primary name field from API)
    final departmentName = json['department_name_en'] as String? ??
        json['department_name'] as String? ??
        json['name'] as String? ??
        json['name_en'] as String? ??
        '';

    // Parse department_name_ar (Arabic name field from API)
    final departmentNameArabic = json['department_name_ar'] as String? ??
        json['department_name_arabic'] as String? ??
        json['name_arabic'] as String? ??
        json['name_ar'] as String?;

    // Parse department_code
    final departmentCode = json['department_code'] as String? ??
        json['code'] as String?;

    // Parse business_unit_name_en
    final businessUnitName = json['business_unit_name_en'] as String? ??
        json['business_unit_name'] as String?;

    // Parse business_unit_name_ar
    final businessUnitNameArabic = json['business_unit_name_ar'] as String? ??
        json['business_unit_name_arabic'] as String?;

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

    // Parse head_of_department
    final headName = json['head_of_department'] as String? ??
        json['head_name'] as String? ??
        json['head'] as String? ??
        json['manager'] as String?;

    // Parse status - API returns "ACTIVE" or "Inactive" string
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

    // Parse total_sub_departments (API uses total_sub_departments)
    final sectionsCount = (json['total_sub_departments'] as num?)?.toInt() ??
        (json['sections'] as num?)?.toInt() ??
        (json['section_count'] as num?)?.toInt() ??
        0;

    // Parse total_budget (API uses total_budget)
    final departmentBudget = json['total_budget'] != null
        ? (json['total_budget'] is num
            ? json['total_budget'].toString()
            : json['total_budget'] as String?)
        : (json['budget'] as String? ??
            json['annual_budget'] as String?);

    // Parse head_email
    final headEmail = json['head_email'] as String? ??
        json['headEmail'] as String? ??
        json['manager_email'] as String?;

    // Parse head_phone
    final headPhone = json['head_phone'] as String? ??
        json['headPhone'] as String? ??
        json['manager_phone'] as String?;

    // Parse description
    final departmentDescription = json['description'] as String?;

    // Parse business_unit_id
    final businessUnitId = (json['business_unit_id'] as num?)?.toInt() ??
        (json['businessUnitId'] as num?)?.toInt();

    // Parse division_id
    final divisionId = (json['division_id'] as num?)?.toInt() ??
        (json['divisionId'] as num?)?.toInt();

    // Parse company_id
    final companyId = (json['company_id'] as num?)?.toInt() ??
        (json['companyId'] as num?)?.toInt();

    return DepartmentDto(
      id: departmentId,
      name: departmentName,
      nameArabic: departmentNameArabic,
      code: departmentCode,
      businessUnitName: businessUnitName,
      businessUnitNameArabic: businessUnitNameArabic,
      divisionName: divisionName,
      divisionNameArabic: divisionNameArabic,
      companyName: companyName,
      companyNameArabic: companyNameArabic,
      headName: headName,
      isActive: isActive,
      employees: employeesCount,
      sections: sectionsCount,
      budget: departmentBudget,
      headEmail: headEmail,
      headPhone: headPhone,
      description: departmentDescription,
      businessUnitId: businessUnitId,
      divisionId: divisionId,
      companyId: companyId,
    );
  }

  /// Converts DTO to domain model
  DepartmentOverview toDomain() {
    return DepartmentOverview(
      id: id,
      name: name,
      nameArabic: nameArabic ?? '',
      code: code ?? '',
      businessUnitName: businessUnitName ?? '',
      divisionName: divisionName ?? '',
      companyName: companyName ?? '',
      headName: headName ?? '',
      headEmail: headEmail,
      headPhone: headPhone,
      isActive: isActive,
      employees: employees ?? 0,
      sections: sections ?? 0,
      budget: budget ?? '',
      focusArea: description ?? '',
    );
  }

  /// Creates JSON from DTO
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (nameArabic != null) 'name_arabic': nameArabic,
      if (code != null) 'code': code,
      if (businessUnitName != null) 'business_unit_name': businessUnitName,
      if (divisionName != null) 'division_name': divisionName,
      if (companyName != null) 'company_name': companyName,
      if (headName != null) 'head_name': headName,
      'is_active': isActive,
      if (employees != null) 'employees': employees,
      if (sections != null) 'sections': sections,
      if (budget != null) 'budget': budget,
      if (headEmail != null) 'head_email': headEmail,
      if (headPhone != null) 'head_phone': headPhone,
      if (description != null) 'description': description,
      if (businessUnitId != null) 'business_unit_id': businessUnitId,
      if (divisionId != null) 'division_id': divisionId,
      if (companyId != null) 'company_id': companyId,
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

/// DTO for paginated departments response
class PaginatedDepartmentsDto {
  final List<DepartmentDto> departments;
  final PaginationInfoDto pagination;
  final int total;
  final int count;

  const PaginatedDepartmentsDto({
    required this.departments,
    required this.pagination,
    required this.total,
    required this.count,
  });

  factory PaginatedDepartmentsDto.fromJson(Map<String, dynamic> json) {
    // Extract data array
    final data = json['data'] as List<dynamic>? ?? [];
    final departments = data
        .map((item) => DepartmentDto.fromJson(item as Map<String, dynamic>))
        .toList();

    // Extract meta information
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = meta['pagination'] as Map<String, dynamic>? ?? {};
    final pagination = PaginationInfoDto.fromJson(paginationJson);

    final total = (meta['total'] as num?)?.toInt() ?? 0;
    final count = (meta['count'] as num?)?.toInt() ?? 0;

    return PaginatedDepartmentsDto(
      departments: departments,
      pagination: pagination,
      total: total,
      count: count,
    );
  }

  PaginatedDepartments toDomain() {
    return PaginatedDepartments(
      departments: departments.map((d) => d.toDomain()).toList(),
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

