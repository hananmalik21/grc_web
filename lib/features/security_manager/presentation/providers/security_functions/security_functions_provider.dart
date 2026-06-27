import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:grc/features/security_manager/data/repositories/security_functions/security_functions_repository_impl.dart';
import 'package:grc/features/security_manager/domain/models/security_function.dart';
import 'package:grc/features/security_manager/domain/repositories/security_functions_repository.dart';
import 'package:grc/features/security_manager/domain/usecases/get_security_functions_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _securityFunctionsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _securityFunctionsRepositoryProvider = Provider<SecurityFunctionsRepository>((ref) {
  return SecurityFunctionsRepositoryImpl(ref.watch(_securityFunctionsApiClientProvider));
});

final _getSecurityFunctionsUseCaseProvider = Provider<GetSecurityFunctionsUseCase>((ref) {
  return GetSecurityFunctionsUseCase(ref.watch(_securityFunctionsRepositoryProvider));
});

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class SecurityFunctionsState {
  const SecurityFunctionsState({
    this.functions = const [],
    this.isLoading = false,
    this.error,
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalItems = 0,
    this.totalPages = 1,
    this.hasNext = false,
    this.hasPrevious = false,
    this.searchQuery = '',
  });

  final List<SecurityFunction> functions;
  final bool isLoading;
  final String? error;
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  final String searchQuery;

  SecurityFunctionsState copyWith({
    List<SecurityFunction>? functions,
    bool? isLoading,
    String? error,
    bool clearError = false,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
    String? searchQuery,
  }) {
    return SecurityFunctionsState(
      functions: functions ?? this.functions,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class SecurityFunctionsNotifier extends StateNotifier<SecurityFunctionsState> {
  SecurityFunctionsNotifier(this._useCase) : super(const SecurityFunctionsState());

  final GetSecurityFunctionsUseCase _useCase;
  final Debouncer _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 400));

  @override
  void dispose() {
    _searchDebouncer.dispose();
    super.dispose();
  }

  Future<void> load({int page = 1, String? search}) async {
    final query = search ?? state.searchQuery;
    state = state.copyWith(isLoading: true, clearError: true, searchQuery: query);
    try {
      final result = await _useCase(
        page: page,
        pageSize: state.pageSize,
        search: query.trim().isEmpty ? null : query.trim(),
      );
      state = state.copyWith(
        functions: result.functions,
        isLoading: false,
        currentPage: result.page,
        totalItems: result.total,
        totalPages: result.totalPages,
        hasNext: result.hasNext,
        hasPrevious: result.hasPrevious,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load functions: ${e.toString()}');
    }
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
    _searchDebouncer.run(() => load(page: 1, search: query));
  }

  Future<void> nextPage() => load(page: state.currentPage + 1);

  Future<void> previousPage() => load(page: state.currentPage - 1);

  Future<void> goToPage(int page) => load(page: page);
}

final securityFunctionsProvider = StateNotifierProvider<SecurityFunctionsNotifier, SecurityFunctionsState>((ref) {
  return SecurityFunctionsNotifier(ref.watch(_getSecurityFunctionsUseCaseProvider));
});
