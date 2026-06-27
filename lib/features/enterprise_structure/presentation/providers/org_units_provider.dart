import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/enterprise_structure/domain/models/paginated_org_units_response.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_org_units_by_level_usecase.dart';
import 'package:grc/features/enterprise_structure/domain/usecases/get_org_units_paginated_usecase.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrgUnitsState {
  final List<OrgStructureLevel> units;
  final bool isLoading;
  final String? errorMessage;
  final bool hasError;
  final String? levelCode;
  final String? structureId;
  final int? enterpriseId;
  final String? searchQuery;
  final int currentPage;
  final int pageSize;
  final int totalPages;
  final int totalItems;

  const OrgUnitsState({
    this.units = const [],
    this.isLoading = false,
    this.errorMessage,
    this.hasError = false,
    this.levelCode,
    this.structureId,
    this.enterpriseId,
    this.searchQuery,
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalPages = 1,
    this.totalItems = 0,
  });

  OrgUnitsState copyWith({
    List<OrgStructureLevel>? units,
    bool? isLoading,
    String? errorMessage,
    bool? hasError,
    String? levelCode,
    String? structureId,
    int? enterpriseId,
    String? searchQuery,
    int? currentPage,
    int? pageSize,
    int? totalPages,
    int? totalItems,
  }) {
    return OrgUnitsState(
      units: units ?? this.units,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      hasError: hasError ?? this.hasError,
      levelCode: levelCode ?? this.levelCode,
      structureId: structureId ?? this.structureId,
      enterpriseId: enterpriseId ?? this.enterpriseId,
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  bool get hasNextPage => currentPage < totalPages;
  bool get hasPreviousPage => currentPage > 1;

  PaginationInfo get pagination => PaginationInfo(
    currentPage: currentPage,
    totalPages: totalPages,
    totalItems: totalItems,
    pageSize: pageSize,
    hasNext: hasNextPage,
    hasPrevious: hasPreviousPage,
  );
}

class OrgUnitsNotifier extends StateNotifier<OrgUnitsState> {
  final GetOrgUnitsByLevelUseCase getOrgUnitsByLevelUseCase;
  final GetOrgUnitsPaginatedUseCase getOrgUnitsPaginatedUseCase;

  OrgUnitsNotifier({required this.getOrgUnitsByLevelUseCase, required this.getOrgUnitsPaginatedUseCase})
    : super(const OrgUnitsState());

  Future<void> loadOrgUnits(
    String levelCode, {
    String? structureId,
    int? enterpriseId,
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    if (state.currentPage == page &&
        state.isLoading &&
        state.levelCode == levelCode &&
        state.structureId == structureId &&
        state.searchQuery == search) {
      return;
    }

    try {
      state = state.copyWith(
        isLoading: true,
        hasError: false,
        errorMessage: null,
        levelCode: levelCode,
        structureId: structureId,
        enterpriseId: enterpriseId,
        searchQuery: search,
        currentPage: page,
        pageSize: pageSize,
      );
    } catch (_) {
      return;
    }

    try {
      PaginatedOrgUnitsResponse? paginatedResponse;

      if (structureId != null) {
        paginatedResponse = await getOrgUnitsPaginatedUseCase.call(
          structureId,
          levelCode,
          enterpriseId: enterpriseId,
          search: search,
          page: page,
          pageSize: pageSize,
        );
      } else {
        final units = await getOrgUnitsByLevelUseCase(levelCode);
        paginatedResponse = PaginatedOrgUnitsResponse(
          units: units,
          currentPage: 1,
          pageSize: units.length,
          totalPages: 1,
          totalItems: units.length,
        );
      }

      try {
        state = state.copyWith(
          units: paginatedResponse.units,
          isLoading: false,
          hasError: false,
          currentPage: paginatedResponse.currentPage,
          totalPages: paginatedResponse.totalPages,
          totalItems: paginatedResponse.totalItems,
        );
      } catch (_) {
        return;
      }
    } on AppException catch (e) {
      try {
        state = state.copyWith(isLoading: false, hasError: true, errorMessage: e.message);
      } catch (_) {
        return;
      }
    } catch (e) {
      try {
        state = state.copyWith(
          isLoading: false,
          hasError: true,
          errorMessage: 'Failed to load org units: ${e.toString()}',
        );
      } catch (_) {
        return;
      }
    }
  }

  Future<void> search(String query) async {
    if (state.levelCode != null && state.structureId != null) {
      await loadOrgUnits(
        state.levelCode!,
        structureId: state.structureId,
        enterpriseId: state.enterpriseId,
        search: query,
        page: 1,
        pageSize: state.pageSize,
      );
    }
  }

  Future<void> goToPage(int page) async {
    if (page < 1 || (state.totalPages > 0 && page > state.totalPages)) {
      return;
    }

    if (state.levelCode == null || state.structureId == null) {
      return;
    }

    if (state.currentPage == page && !state.isLoading) {
      return;
    }

    await loadOrgUnits(
      state.levelCode!,
      structureId: state.structureId,
      enterpriseId: state.enterpriseId,
      search: state.searchQuery,
      page: page,
      pageSize: state.pageSize,
    );
  }

  Future<void> nextPage() async {
    if (state.hasNextPage) {
      await goToPage(state.currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (state.hasPreviousPage) {
      await goToPage(state.currentPage - 1);
    }
  }

  bool get hasNextPage => state.hasNextPage;
  bool get hasPreviousPage => state.hasPreviousPage;

  Future<void> refresh() async {
    if (state.levelCode != null) {
      await loadOrgUnits(
        state.levelCode!,
        structureId: state.structureId,
        enterpriseId: state.enterpriseId,
        search: state.searchQuery,
        page: state.currentPage,
        pageSize: state.pageSize,
      );
    }
  }

  void updateUnitLocal(OrgStructureLevel updatedUnit) {
    try {
      final updatedUnits = state.units.map((unit) {
        return unit.orgUnitId == updatedUnit.orgUnitId ? updatedUnit : unit;
      }).toList();
      state = state.copyWith(units: updatedUnits);
    } catch (_) {}
  }

  void removeUnitLocal(String orgUnitId) {
    try {
      final updatedUnits = state.units.where((unit) => unit.orgUnitId != orgUnitId).toList();
      state = state.copyWith(units: updatedUnits, totalItems: state.totalItems > 0 ? state.totalItems - 1 : 0);
    } catch (_) {}
  }

  void clear() {
    try {
      state = const OrgUnitsState();
    } catch (_) {}
  }
}

final orgUnitsProvider = StateNotifierProvider.autoDispose.family<OrgUnitsNotifier, OrgUnitsState, String>((
  ref,
  levelCode,
) {
  final getOrgUnitsByLevelUseCase = ref.watch(getOrgUnitsByLevelUseCaseProvider);
  final getOrgUnitsPaginatedUseCase = ref.watch(getOrgUnitsPaginatedUseCaseProvider);
  final notifier = OrgUnitsNotifier(
    getOrgUnitsByLevelUseCase: getOrgUnitsByLevelUseCase,
    getOrgUnitsPaginatedUseCase: getOrgUnitsPaginatedUseCase,
  );

  return notifier;
});
