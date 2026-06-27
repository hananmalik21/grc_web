import 'package:grc/core/enums/security_enums.dart';

const skeletonFunctionRole = FunctionRole(
  functionRoleId: 0,
  functionRoleGuid: '',
  enterpriseId: 0,
  moduleId: 0,
  moduleCode: 'HR_CORE',
  moduleName: 'HR Core',
  roleCode: 'FUNC_PLACEHOLDER',
  roleName: 'Employee Management Functions',
  description: 'Access to employee management screens and functions',
  statusCode: 'ACTIVE',
  displayOrder: 0,
  isActive: true,
  functions: [
    FunctionRoleFunction(
      functionId: 0,
      functionGuid: '',
      functionCode: 'EMP_LIST',
      functionName: 'Employee List',
      assignmentType: FunctionAssignmentType.direct,
    ),
    FunctionRoleFunction(
      functionId: 1,
      functionGuid: '',
      functionCode: 'EMP_CREATE',
      functionName: 'Employee Creation',
      assignmentType: FunctionAssignmentType.direct,
    ),
  ],
);

class FunctionRoleFunction {
  const FunctionRoleFunction({
    required this.functionId,
    required this.functionGuid,
    required this.functionCode,
    required this.functionName,
    this.description,
    required this.assignmentType,
    this.sourceParentRoleId,
    this.sourceParentRoleCode,
  });

  final int functionId;
  final String functionGuid;
  final String functionCode;
  final String functionName;
  final String? description;
  final FunctionAssignmentType assignmentType;
  final int? sourceParentRoleId;
  final String? sourceParentRoleCode;

  factory FunctionRoleFunction.fromJson(Map<String, dynamic> json) {
    return FunctionRoleFunction(
      functionId: json['function_id'] as int,
      functionGuid: json['function_guid'] as String,
      functionCode: json['function_code'] as String,
      functionName: json['function_name'] as String,
      description: json['description'] as String?,
      assignmentType: FunctionAssignmentType.fromString(json['assignment_type'] as String),
      sourceParentRoleId: json['source_parent_role_id'] as int?,
      sourceParentRoleCode: json['source_parent_role_code'] as String?,
    );
  }
}

class FunctionRole {
  const FunctionRole({
    required this.functionRoleId,
    required this.functionRoleGuid,
    required this.enterpriseId,
    required this.moduleId,
    required this.moduleCode,
    required this.moduleName,
    required this.roleCode,
    required this.roleName,
    this.description,
    required this.statusCode,
    required this.displayOrder,
    required this.isActive,
    required this.functions,
  });

  final int functionRoleId;
  final String functionRoleGuid;
  final int enterpriseId;
  final int moduleId;
  final String moduleCode;
  final String moduleName;
  final String roleCode;
  final String roleName;
  final String? description;
  final String statusCode;
  final int displayOrder;
  final bool isActive;
  final List<FunctionRoleFunction> functions;

  factory FunctionRole.fromJson(Map<String, dynamic> json) {
    final functionsJson = json['functions'] as List<dynamic>? ?? [];
    return FunctionRole(
      functionRoleId: json['function_role_id'] as int,
      functionRoleGuid: json['function_role_guid'] as String,
      enterpriseId: json['enterprise_id'] as int,
      moduleId: json['module_id'] as int,
      moduleCode: json['module_code'] as String,
      moduleName: json['module_name'] as String,
      roleCode: json['role_code'] as String,
      roleName: json['role_name'] as String,
      description: json['description'] as String?,
      statusCode: json['status_code'] as String,
      displayOrder: json['display_order'] as int,
      isActive: (json['active_flag'] as String?) == 'Y',
      functions: functionsJson.map((f) => FunctionRoleFunction.fromJson(f as Map<String, dynamic>)).toList(),
    );
  }
}

class FunctionRolePage {
  const FunctionRolePage({
    required this.roles,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<FunctionRole> roles;
  final int page;
  final int pageSize;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
}
