import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_active_levels_usecase.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/manage_component_values_enterprise_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef EnterpriseIdGetter = int? Function();

class ActiveLevelsState {
  final List<ActiveStructureLevel> levels;
  final bool isLoading;
  final String? errorMessage;
  final bool hasError;

  const ActiveLevelsState({this.levels = const [], this.isLoading = false, this.errorMessage, this.hasError = false});

  ActiveLevelsState copyWith({
    List<ActiveStructureLevel>? levels,
    bool? isLoading,
    String? errorMessage,
    bool? hasError,
  }) {
    return ActiveLevelsState(
      levels: levels ?? this.levels,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
    );
  }
}

class ActiveLevelsNotifier extends StateNotifier<ActiveLevelsState> {
  final GetActiveLevelsUseCase getActiveLevelsUseCase;
  final EnterpriseIdGetter? enterpriseIdGetter;

  ActiveLevelsNotifier({required this.getActiveLevelsUseCase, this.enterpriseIdGetter})
    : super(const ActiveLevelsState()) {
    _loadLevels();
  }

  Future<void> _loadLevels() async {
    state = state.copyWith(isLoading: true, hasError: false, errorMessage: null);

    try {
      final enterpriseId = enterpriseIdGetter?.call();
      if (enterpriseIdGetter != null && enterpriseId == null) {
        state = state.copyWith(levels: [], isLoading: false, hasError: false);
        return;
      }
      final levels = await getActiveLevelsUseCase(enterpriseId: enterpriseId);
      state = state.copyWith(levels: levels, isLoading: false, hasError: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, hasError: true, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load active levels: ${e.toString()}',
      );
    }
  }

  Future<void> refresh() async {
    await _loadLevels();
  }
}

final manageComponentValuesActiveLevelsProvider = StateNotifierProvider<ActiveLevelsNotifier, ActiveLevelsState>((ref) {
  final getActiveLevelsUseCase = ref.watch(getActiveLevelsUseCaseProvider);
  return ActiveLevelsNotifier(
    getActiveLevelsUseCase: getActiveLevelsUseCase,
    enterpriseIdGetter: () => ref.read(manageComponentValuesEnterpriseIdProvider),
  );
});
