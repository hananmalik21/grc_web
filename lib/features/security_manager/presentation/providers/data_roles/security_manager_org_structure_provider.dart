import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_active_org_structure_levels_usecase.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecurityManagerOrgStructureNotifier extends StateNotifier<OrgStructureState> {
  SecurityManagerOrgStructureNotifier(this._ref, this._useCase) : super(const OrgStructureState()) {
    _enterpriseSubscription = _ref.listen<int?>(
      securityManagerEnterpriseIdProvider,
      (_, _) => loadForCurrentEnterprise(),
    );
    loadForCurrentEnterprise();
  }

  final Ref _ref;
  final GetActiveOrgStructureLevelsUseCase _useCase;
  late final ProviderSubscription<int?> _enterpriseSubscription;

  Future<void> loadForCurrentEnterprise() async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      state = const OrgStructureState();
      return;
    }

    state = const OrgStructureState(isLoading: true);

    try {
      final orgStructure = await _useCase(tenantId: enterpriseId);
      if (_ref.read(securityManagerEnterpriseIdProvider) != enterpriseId) {
        return;
      }
      state = OrgStructureState(orgStructure: orgStructure, isLoading: false);
    } catch (e) {
      if (_ref.read(securityManagerEnterpriseIdProvider) != enterpriseId) {
        return;
      }
      state = OrgStructureState(isLoading: false, error: e.toString());
    }
  }

  @override
  void dispose() {
    _enterpriseSubscription.close();
    super.dispose();
  }
}

final securityManagerOrgStructureNotifierProvider =
    StateNotifierProvider<SecurityManagerOrgStructureNotifier, OrgStructureState>((ref) {
      return SecurityManagerOrgStructureNotifier(ref, ref.read(getActiveOrgStructureLevelsUseCaseProvider));
    });
