import 'package:grc/features/enterprise_structure/domain/models/enterprise.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_enterprises_usecase.dart';

class AppInitializationService {
  final GetEnterprisesUseCase getEnterprisesUseCase;
  final void Function(int?)? onActiveEnterpriseReady;
  final void Function()? initializeLocation;

  List<Enterprise>? _enterprises;
  int? _activeEnterpriseId;

  AppInitializationService({
    required this.getEnterprisesUseCase,
    this.onActiveEnterpriseReady,
    this.initializeLocation,
  });

  Future<void> initializeAfterAuth({int? preferredEnterpriseId, void Function()? onEnterprisesLoaded}) async {
    initializeLocation?.call();
    await _loadEnterprises();
    _setEnterpriseIdFromEnterprises(preferredEnterpriseId: preferredEnterpriseId);
    onEnterprisesLoaded?.call();
  }

  void _setEnterpriseIdFromEnterprises({int? preferredEnterpriseId}) {
    if (preferredEnterpriseId != null) {
      _activeEnterpriseId = preferredEnterpriseId;
      onActiveEnterpriseReady?.call(_activeEnterpriseId);
      return;
    }

    final list = _enterprises;
    if (list != null && list.isNotEmpty) {
      _activeEnterpriseId = list.first.id;
      onActiveEnterpriseReady?.call(_activeEnterpriseId);
    }
  }

  Future<void> _loadEnterprises() async {
    try {
      _enterprises = await getEnterprisesUseCase();
    } catch (e) {
      _enterprises = [];
    }
  }

  List<Enterprise>? get enterprises => _enterprises;

  int? get activeEnterpriseId => _activeEnterpriseId;

  Future<void> refreshEnterprises() async {
    await _loadEnterprises();
  }

  void clearCache() {
    _enterprises = null;
    _activeEnterpriseId = null;
  }
}
