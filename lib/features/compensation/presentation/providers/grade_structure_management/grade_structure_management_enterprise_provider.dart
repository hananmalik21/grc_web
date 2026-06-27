import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/services/initialization/providers/initialization_providers.dart';
import 'grade_structure_managment_provider.dart';

final gradeStructureManagementSelectedEnterpriseProvider =
    StateNotifierProvider<GradeStructureManagementEnterpriseNotifier, int?>((
      ref,
    ) {
      final notifier = GradeStructureManagementEnterpriseNotifier(ref);
      final initialActive = ref.read(activeEnterpriseIdProvider);

      if (initialActive != null) {
        notifier.setEnterpriseId(initialActive);
      }

      ref.listen<int?>(activeEnterpriseIdProvider, (previous, next) {
        if (next != null && !notifier.hasSelection) {
          notifier.setEnterpriseId(next);
        }
      });

      return notifier;
    });

class GradeStructureManagementEnterpriseNotifier extends StateNotifier<int?> {
  final Ref ref;

  GradeStructureManagementEnterpriseNotifier(this.ref) : super(null);

  bool get hasSelection => state != null;

  void setEnterpriseId(int? enterpriseId) {
    state = enterpriseId;
    if (enterpriseId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(gradeStructureManagementProvider.notifier)
            .setCompanyId(enterpriseId.toString());
      });
    }
  }
}

final gradeStructureManagementEnterpriseIdProvider = Provider<int?>((ref) {
  final selected = ref.watch(
    gradeStructureManagementSelectedEnterpriseProvider,
  );
  final active = ref.watch(activeEnterpriseIdProvider);
  return selected ?? active;
});
