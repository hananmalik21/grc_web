import 'package:grc/features/security_manager/domain/models/data_role.dart';

abstract class DataRolesRepository {
  Future<DataRolePage> getDataRoles({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
    String? dataTypeCode,
  });
  Future<void> createDataRole({required Map<String, dynamic> body});
  Future<void> updateDataRole({required String dataRoleGuid, required Map<String, dynamic> body});
  Future<void> deleteDataRole({required String dataRoleGuid, required int enterpriseId, required String actor});
}
