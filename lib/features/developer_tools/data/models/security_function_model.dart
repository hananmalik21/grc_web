import 'package:grc/features/developer_tools/domain/models/security_function.dart';

class SecurityFunctionModuleModel extends SecurityFunctionModule {
  const SecurityFunctionModuleModel({
    required super.moduleId,
    required super.moduleGuid,
    required super.moduleCode,
    required super.moduleName,
  });

  factory SecurityFunctionModuleModel.fromJson(Map<String, dynamic> json) {
    return SecurityFunctionModuleModel(
      moduleId: (json['module_id'] as num).toInt(),
      moduleGuid: json['module_guid'] as String,
      moduleCode: json['module_code'] as String,
      moduleName: json['module_name'] as String,
    );
  }
}

class SecurityFunctionModel extends SecurityFunction {
  const SecurityFunctionModel({
    required super.functionId,
    required super.functionGuid,
    required super.moduleId,
    required super.functionCode,
    required super.functionName,
    super.description,
    required super.functionType,
    required super.permissionKey,
    super.routeUrl,
    required super.displayOrder,
    required super.isActive,
    required super.isSystem,
    super.module,
  });

  factory SecurityFunctionModel.fromJson(Map<String, dynamic> json) {
    final moduleJson = json['module'] as Map<String, dynamic>?;
    return SecurityFunctionModel(
      functionId: (json['function_id'] as num).toInt(),
      functionGuid: json['function_guid'] as String,
      moduleId: (json['module_id'] as num).toInt(),
      functionCode: json['function_code'] as String,
      functionName: json['function_name'] as String,
      description: json['description'] as String?,
      functionType: json['function_type'] as String,
      permissionKey: json['permission_key'] as String,
      routeUrl: json['route_url'] as String?,
      displayOrder: (json['display_order'] as num).toInt(),
      isActive: (json['active_flag'] as String?) == 'Y',
      isSystem: (json['is_system_flag'] as String?) == 'Y',
      module: moduleJson != null ? SecurityFunctionModuleModel.fromJson(moduleJson) : null,
    );
  }
}
