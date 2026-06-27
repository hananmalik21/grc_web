/// Represents a single security function returned by
/// `GET /api/security/functions`.
class SecurityFunction {
  const SecurityFunction({
    required this.functionId,
    required this.functionGuid,
    required this.functionCode,
    required this.functionName,
    this.description,
    required this.functionType,
    required this.permissionKey,
    this.routeUrl,
    required this.displayOrder,
    required this.isActive,
    required this.moduleId,
    required this.moduleCode,
    required this.moduleName,
  });

  final int functionId;
  final String functionGuid;
  final String functionCode;
  final String functionName;
  final String? description;
  final String functionType;
  final String permissionKey;
  final String? routeUrl;
  final int displayOrder;
  final bool isActive;
  final int moduleId;
  final String moduleCode;
  final String moduleName;

  factory SecurityFunction.fromJson(Map<String, dynamic> json) {
    final module = json['module'] as Map<String, dynamic>? ?? {};
    return SecurityFunction(
      functionId: json['function_id'] as int,
      functionGuid: json['function_guid'] as String,
      functionCode: json['function_code'] as String,
      functionName: json['function_name'] as String,
      description: json['description'] as String?,
      functionType: json['function_type'] as String,
      permissionKey: json['permission_key'] as String,
      routeUrl: json['route_url'] as String?,
      displayOrder: json['display_order'] as int,
      isActive: (json['active_flag'] as String?) == 'Y',
      moduleId: module['module_id'] as int? ?? 0,
      moduleCode: module['module_code'] as String? ?? '',
      moduleName: module['module_name'] as String? ?? '',
    );
  }
}

class SecurityFunctionPage {
  const SecurityFunctionPage({
    required this.functions,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<SecurityFunction> functions;
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
}

/// Placeholder used for skeleton loading UI.
const skeletonSecurityFunction = SecurityFunction(
  functionId: 0,
  functionGuid: 'skeleton-guid',
  functionCode: 'EMP_CREATION',
  functionName: 'Employee Creation',
  description: 'Create and manage employee records',
  functionType: 'MENU',
  permissionKey: 'EMP:CREATE',
  routeUrl: '/employees',
  displayOrder: 10,
  isActive: true,
  moduleId: 9,
  moduleCode: 'HR_CORE',
  moduleName: 'HR Core',
);
