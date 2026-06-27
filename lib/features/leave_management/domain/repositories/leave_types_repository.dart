import 'package:grc/features/leave_management/domain/models/api_leave_type.dart';

abstract class LeaveTypesRepository {
  Future<List<ApiLeaveType>> getLeaveTypes({String? search, int? tenantId});
}
