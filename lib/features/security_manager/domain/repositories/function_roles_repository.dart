import '../models/function_role.dart';

abstract class FunctionRolesRepository {
  Future<FunctionRolePage> getFunctionRoles({
    required int enterpriseId,
    String? search,
    int? moduleId,
    int page = 1,
    int pageSize = 10,
  });

  Future<void> deleteFunctionRole({required String functionRoleGuid, required int enterpriseId});

  Future<void> createFunctionRole({
    required int enterpriseId,
    required int moduleId,
    required String roleCode,
    required String roleName,
    required String description,
    required String statusCode,
    required int displayOrder,
    required String activeFlag,
    required String isSystemFlag,
    required String startDate,
    required List<Map<String, dynamic>> functionsJson,
    required List<Map<String, dynamic>> inheritedRolesJson,
  });

  Future<void> updateFunctionRole({
    required String functionRoleGuid,
    required int enterpriseId,
    required int moduleId,
    required String roleCode,
    required String roleName,
    required String description,
    required String statusCode,
    required int displayOrder,
    required String activeFlag,
    required String isSystemFlag,
    required String startDate,
    required List<Map<String, dynamic>> functionsJson,
    required List<Map<String, dynamic>> inheritedRolesJson,
  });
}
