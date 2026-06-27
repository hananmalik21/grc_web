import 'package:grc/core/services/debouncer.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/developer_tools/data/datasources/function_management_remote_data_source.dart';
import 'package:grc/features/developer_tools/data/repositories/functions_repository_impl.dart';
import 'package:grc/features/developer_tools/domain/repositories/functions_repository.dart';
import 'package:grc/features/developer_tools/domain/usecases/get_functions_use_case.dart';
import 'package:grc/features/developer_tools/presentation/providers/function_management_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final _functionsApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final _functionsDataSourceProvider = Provider<FunctionManagementRemoteDataSource>((ref) {
  return FunctionManagementRemoteDataSourceImpl(ref.watch(_functionsApiClientProvider));
});

final _functionsRepositoryProvider = Provider<FunctionsRepository>((ref) {
  return FunctionsRepositoryImpl(ref.watch(_functionsDataSourceProvider));
});

final _getFunctionsUseCaseProvider = Provider<GetFunctionsUseCase>((ref) {
  return GetFunctionsUseCase(ref.watch(_functionsRepositoryProvider));
});

class FunctionManagementNotifier extends StateNotifier<FunctionManagementState> {
  FunctionManagementNotifier(this._getfunctions) : super(const FunctionManagementState());

  final GetFunctionsUseCase _getfunctions;
  final Debouncer _searchDebouncer = Debouncer(delay: const Duration(milliseconds: 400));

  @override
  void dispose() {
    _searchDebouncer.dispose();
    super.dispose();
  }

  Future<void> refresh({bool showLoading = true}) async {
    if (showLoading) state = state.copyWith(isLoading: true, clearError: true);

    try {
      final page = await _getfunctions(
        search: state.searchQuery.trim().isEmpty ? null : state.searchQuery.trim(),
        page: state.currentPage,
        pageSize: state.effectivePageSize,
      );

      state = state.copyWith(
        functions: page.functions,
        currentPage: page.page,
        pageSize: page.pageSize,
        totalItems: page.total,
        totalPages: page.totalPages,
        hasNext: page.hasNext,
        hasPrevious: page.hasPrevious,
        isLoading: false,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load functions: ${e.toString()}');
    }
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query, currentPage: 1);
    _searchDebouncer.run(refresh);
  }

  void goToPage(int page) {
    final target = page.clamp(1, state.totalPages);
    if (target == state.currentPage) return;
    state = state.copyWith(currentPage: target);
    refresh();
  }

  void nextPage() => goToPage(state.safeCurrentPage + 1);

  void previousPage() => goToPage(state.safeCurrentPage - 1);
}

final functionManagementProvider = StateNotifierProvider<FunctionManagementNotifier, FunctionManagementState>((ref) {
  return FunctionManagementNotifier(ref.watch(_getFunctionsUseCaseProvider));
});
