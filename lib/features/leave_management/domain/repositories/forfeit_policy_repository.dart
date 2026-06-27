import 'package:grc/features/leave_management/domain/models/forfeit_policy.dart';

abstract class ForfeitPolicyRepository {
  Future<List<ForfeitPolicy>> getForfeitPolicies();
}
