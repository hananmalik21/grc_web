/// Enterprise security module from `GET /api/security/modules`.
class SecurityModule {
  const SecurityModule({
    required this.moduleId,
    required this.moduleGuid,
    required this.moduleCode,
    required this.moduleName,
    this.description,
    this.categoryCode,
    this.statusCode,
    this.icon,
    this.colorCode,
    this.displayOrder,
    required this.activeFlag,
    this.isSystemFlag,
    this.startDate,
    this.endDate,
    this.createdBy,
    this.creationDate,
    this.lastUpdatedBy,
    this.lastUpdateDate,
  });

  final int moduleId;
  final String moduleGuid;
  final String moduleCode;
  final String moduleName;
  final String? description;
  final String? categoryCode;
  final String? statusCode;
  final String? icon;
  final String? colorCode;
  final int? displayOrder;
  final String activeFlag;
  final String? isSystemFlag;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? createdBy;
  final DateTime? creationDate;
  final String? lastUpdatedBy;
  final DateTime? lastUpdateDate;

  factory SecurityModule.fromJson(Map<String, dynamic> json) {
    return SecurityModule(
      moduleId: (json['module_id'] as num).toInt(),
      moduleGuid: json['module_guid'] as String,
      moduleCode: json['module_code'] as String,
      moduleName: json['module_name'] as String,
      description: json['description'] as String?,
      categoryCode: json['category_code'] as String?,
      statusCode: json['status_code'] as String?,
      icon: json['icon'] as String?,
      colorCode: json['color_code'] as String?,
      displayOrder: (json['display_order'] as num?)?.toInt(),
      activeFlag: json['active_flag'] as String? ?? 'Y',
      isSystemFlag: json['is_system_flag'] as String?,
      startDate: _parseDate(json['start_date']),
      endDate: _parseDate(json['end_date']),
      createdBy: json['created_by'] as String?,
      creationDate: _parseDate(json['creation_date']),
      lastUpdatedBy: json['last_updated_by'] as String?,
      lastUpdateDate: _parseDate(json['last_update_date']),
    );
  }

  static DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    return DateTime.tryParse(value as String);
  }
}

/// Paginated modules response metadata.
class SecurityModulePage {
  const SecurityModulePage({
    required this.modules,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<SecurityModule> modules;
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
}
