import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/enterprise.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_enterprises_usecase.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for enterprises list
class EnterprisesState {
  final List<Enterprise> enterprises;
  final bool isLoading;
  final String? errorMessage;
  final bool hasError;

  const EnterprisesState({
    this.enterprises = const [],
    this.isLoading = false,
    this.errorMessage,
    this.hasError = false,
  });

  EnterprisesState copyWith({List<Enterprise>? enterprises, bool? isLoading, String? errorMessage, bool? hasError}) {
    return EnterprisesState(
      enterprises: enterprises ?? this.enterprises,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
    );
  }

  Enterprise? findEnterpriseById(int? id) {
    if (id == null || enterprises.isEmpty) return null;
    try {
      return enterprises.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }
}

/// Notifier for enterprises list
class EnterprisesNotifier extends StateNotifier<EnterprisesState> {
  final GetEnterprisesUseCase getEnterprisesUseCase;

  EnterprisesNotifier({required this.getEnterprisesUseCase}) : super(const EnterprisesState()) {
    _loadEnterprises();
  }

  Future<void> _loadEnterprises() async {
    state = state.copyWith(isLoading: true, hasError: false, errorMessage: null);

    try {
      final enterprises = await getEnterprisesUseCase();
      state = state.copyWith(enterprises: enterprises, isLoading: false, hasError: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, hasError: true, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: 'Failed to load enterprises: ${e.toString()}',
      );
    }
  }

  Future<void> refresh() async {
    await _loadEnterprises();
  }
}

/// Provider for enterprises list
final enterprisesProvider = StateNotifierProvider.autoDispose<EnterprisesNotifier, EnterprisesState>((ref) {
  final getEnterprisesUseCase = ref.watch(getEnterprisesUseCaseProvider);
  return EnterprisesNotifier(getEnterprisesUseCase: getEnterprisesUseCase);
});
