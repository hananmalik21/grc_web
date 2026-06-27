import 'package:grc/features/developer_tools/data/datasources/function_management_remote_data_source.dart';
import 'package:grc/features/developer_tools/data/models/action_item.dart';
import 'package:grc/features/developer_tools/data/models/module_item.dart';
import 'package:grc/features/developer_tools/data/models/submodule_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Modules ──────────────────────────────────────────────────────────────────

class ModulesState {
  const ModulesState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.pageSize = 10,
    this.hasNext = false,
    this.hasPrevious = false,
  });

  final List<ModuleItem> items;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final bool hasNext;
  final bool hasPrevious;

  ModulesState copyWith({
    List<ModuleItem>? items,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? pageSize,
    bool? hasNext,
    bool? hasPrevious,
  }) {
    return ModulesState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      pageSize: pageSize ?? this.pageSize,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
    );
  }
}

class ModulesNotifier extends StateNotifier<ModulesState> {
  ModulesNotifier(this._dataSource) : super(const ModulesState()) {
    loadPage(1);
  }

  final FunctionManagementRemoteDataSource _dataSource;

  Future<void> loadPage(int page) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _dataSource.getModules(page: page, pageSize: state.pageSize);
      if (!mounted) return;
      state = state.copyWith(
        items: result.items,
        isLoading: false,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
        totalItems: result.totalItems,
        pageSize: result.pageSize,
        hasNext: result.hasNext,
        hasPrevious: result.hasPrevious,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to load modules. Please try again.');
    }
  }
}

final modulesProvider = StateNotifierProvider.autoDispose<ModulesNotifier, ModulesState>((ref) {
  return ModulesNotifier(ref.watch(functionManagementDataSourceProvider));
});

// ── Submodules ────────────────────────────────────────────────────────────────

class SubmodulesState {
  const SubmodulesState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.pageSize = 10,
    this.hasNext = false,
    this.hasPrevious = false,
  });

  final List<SubmoduleItem> items;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final bool hasNext;
  final bool hasPrevious;

  SubmodulesState copyWith({
    List<SubmoduleItem>? items,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? pageSize,
    bool? hasNext,
    bool? hasPrevious,
  }) {
    return SubmodulesState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      pageSize: pageSize ?? this.pageSize,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
    );
  }
}

class SubmodulesNotifier extends StateNotifier<SubmodulesState> {
  SubmodulesNotifier(this._dataSource, this._moduleGuid) : super(const SubmodulesState()) {
    loadPage(1);
  }

  final FunctionManagementRemoteDataSource _dataSource;
  final String _moduleGuid;

  Future<void> loadPage(int page) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _dataSource.getSubmodules(moduleGuid: _moduleGuid, page: page, pageSize: state.pageSize);
      if (!mounted) return;
      state = state.copyWith(
        items: result.items,
        isLoading: false,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
        totalItems: result.totalItems,
        pageSize: result.pageSize,
        hasNext: result.hasNext,
        hasPrevious: result.hasPrevious,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to load submodules. Please try again.');
    }
  }
}

final submodulesProvider = StateNotifierProvider.autoDispose.family<SubmodulesNotifier, SubmodulesState, String>((
  ref,
  moduleGuid,
) {
  return SubmodulesNotifier(ref.watch(functionManagementDataSourceProvider), moduleGuid);
});

// ── Actions ───────────────────────────────────────────────────────────────────

class ActionsState {
  const ActionsState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.pageSize = 10,
    this.hasNext = false,
    this.hasPrevious = false,
  });

  final List<ActionItem> items;
  final bool isLoading;
  final String? errorMessage;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final bool hasNext;
  final bool hasPrevious;

  ActionsState copyWith({
    List<ActionItem>? items,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    int? pageSize,
    bool? hasNext,
    bool? hasPrevious,
  }) {
    return ActionsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      pageSize: pageSize ?? this.pageSize,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
    );
  }
}

class ActionsNotifier extends StateNotifier<ActionsState> {
  ActionsNotifier(this._dataSource, this._subModuleGuid) : super(const ActionsState()) {
    loadPage(1);
  }

  final FunctionManagementRemoteDataSource _dataSource;
  final String _subModuleGuid;

  Future<void> loadPage(int page) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _dataSource.getActions(subModuleGuid: _subModuleGuid, page: page, pageSize: state.pageSize);
      if (!mounted) return;
      state = state.copyWith(
        items: result.items,
        isLoading: false,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
        totalItems: result.totalItems,
        pageSize: result.pageSize,
        hasNext: result.hasNext,
        hasPrevious: result.hasPrevious,
      );
    } catch (e) {
      if (!mounted) return;
      state = state.copyWith(isLoading: false, errorMessage: 'Failed to load actions. Please try again.');
    }
  }
}

final actionsProvider = StateNotifierProvider.autoDispose.family<ActionsNotifier, ActionsState, String>((
  ref,
  subModuleGuid,
) {
  return ActionsNotifier(ref.watch(functionManagementDataSourceProvider), subModuleGuid);
});
