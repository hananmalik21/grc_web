import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserManagementEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  UserManagementEnterpriseNotifier(this.ref) : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}
