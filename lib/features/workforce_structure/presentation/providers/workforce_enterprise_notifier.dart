import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkforceEnterpriseNotifier extends StateNotifier<int?> {
  WorkforceEnterpriseNotifier() : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
  }
}
