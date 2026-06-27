import 'package:grc/features/hiring/application/requisition/providers/requisitions_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class RequisitionControllerBase {
  const RequisitionControllerBase(this.ref);

  final Ref ref;

  int? get enterpriseId => ref.read(requisitionsTabEnterpriseIdProvider);

  bool get hasEnterpriseSelected => enterpriseId != null && enterpriseId! > 0;

  void refreshRequisitions() {
    ref.read(requisitionsTabRefreshTickProvider.notifier).state++;
  }
}
