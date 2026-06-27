import 'package:grc/features/security_manager/domain/models/duty_role.dart';

abstract class DutyRolesRepository {
  Future<DutyRolePage> getDutyRoles({
    required int enterpriseId,
    String? search,
    String? categoryCode,
    int page = 1,
    int pageSize = 10,
  });

  Future<void> createDutyRole({
    required int enterpriseId,
    required String name,
    required String code,
    required String categoryCode,
    required String status,
    required String description,
    required String requiresManagerApproval,
    required String activeFlag,
    required String actor,
    required List<Map<String, dynamic>> functionRoles,
    required List<Map<String, dynamic>> inheritedDutyRoles,
    String? effectiveDate,
    String? expirationDate,
  });

  Future<void> updateDutyRole({
    required String dutyRoleGuid,
    required int enterpriseId,
    required String name,
    required String code,
    required String categoryCode,
    required String status,
    required String description,
    required String requiresManagerApproval,
    required String activeFlag,
    required String actor,
    required List<Map<String, dynamic>> functionRoles,
    required List<Map<String, dynamic>> inheritedDutyRoles,
    String? effectiveDate,
    String? expirationDate,
  });

  Future<void> deleteDutyRole({required String dutyRoleGuid, required int enterpriseId, required String actor});
}
