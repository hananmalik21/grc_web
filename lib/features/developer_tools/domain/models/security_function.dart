const skeletonSecurityFunction = SecurityFunction(
  functionId: 0,
  functionGuid: 'skeleton-function-guid',
  moduleId: 0,
  functionCode: 'SKELETON_CODE',
  functionName: 'Skeleton Function Name',
  description: 'Skeleton description text here',
  functionType: 'MENU',
  permissionKey: 'SKELETON:KEY',
  routeUrl: '/skeleton',
  displayOrder: 0,
  isActive: true,
  isSystem: false,
  module: SecurityFunctionModule(
    moduleId: 0,
    moduleGuid: 'skeleton-module-guid',
    moduleCode: 'SKELETON_MODULE',
    moduleName: 'Skeleton Module',
  ),
);

class SecurityFunctionModule {
  const SecurityFunctionModule({
    required this.moduleId,
    required this.moduleGuid,
    required this.moduleCode,
    required this.moduleName,
  });

  final int moduleId;
  final String moduleGuid;
  final String moduleCode;
  final String moduleName;
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

class SecurityFunction {
  const SecurityFunction({
    required this.functionId,
    required this.functionGuid,
    required this.moduleId,
    required this.functionCode,
    required this.functionName,
    this.description,
    required this.functionType,
    required this.permissionKey,
    this.routeUrl,
    required this.displayOrder,
    required this.isActive,
    required this.isSystem,
    this.module,
  });

  final int functionId;
  final String functionGuid;
  final int moduleId;
  final String functionCode;
  final String functionName;
  final String? description;
  final String functionType;
  final String permissionKey;
  final String? routeUrl;
  final int displayOrder;
  final bool isActive;
  final bool isSystem;
  final SecurityFunctionModule? module;
}
