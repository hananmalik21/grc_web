import 'dart:async';

import 'package:grc/gen/assets.gen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/enums/overtime_status.dart';
import '../../../../../core/network/exceptions.dart';
import '../../../data/repositories/overtime_repository_impl.dart';
import '../../../domain/models/overtime/overtime_management.dart';
import '../../../domain/models/overtime/overtime_record.dart';
import '../../../domain/repositories/overtime_repository.dart';

final overtimeRepositoryProvider = Provider<OvertimeRepository>((ref) {
  return OvertimeRepositoryImpl();
});

class OvertimeManagementNotifier extends StateNotifier<OvertimeManagement> {
  final OvertimeRepository _repository;
  Timer? _searchDebounce;

  OvertimeManagementNotifier(this._repository) : super(OvertimeManagement()) {
    _initializeMockData();
  }

  void _initializeMockData() {
    state = state.copyWith(
      categories: OvertimeCategory.values,
      selectedCategory: OvertimeCategory.all,
      stats: [
        OvertimeStat(
          title: 'Total Overtime',
          subTitle: '8 records',
          value: '25.0',
          icon: Assets.icons.attendance.halfDay.path,
        ),
        OvertimeStat(
          title: 'Total Amount',
          subTitle: 'Overtime compensation',
          value: 'KKWD 1085.00',
          icon: Assets.icons.budgetGreenIcon.path,
        ),
        OvertimeStat(
          title: 'Pending Approvals',
          subTitle: 'Awaiting manager review',
          value: '3',
          icon: Assets.icons.errorCircleRed.path,
        ),
        OvertimeStat(
          title: 'Approved',
          subTitle: 'Ready for payroll',
          value: '4',
          icon: Assets.icons.activeStructureIcon.path,
        ),
      ],
      records: [],
    );
  }

  Future<void> loadOvertime({int? page}) async {
    final tenantId = state.companyId != null ? int.tryParse(state.companyId!) : null;
    if (tenantId == null) {
      state = state.copyWith(records: [], isLoading: false, clearError: true);
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    if (page != null) {
      state = state.copyWith(currentPage: page);
    }

    try {
      final pageToFetch = page ?? state.currentPage;
      final searchQuery = state.searchQuery?.trim().isEmpty ?? true ? null : state.searchQuery?.trim();
      final result = await _repository.getOvertimeRequests(
        tenantId: tenantId,
        status: state.selectedStatus?.apiValue,
        searchQuery: searchQuery,
        orgUnitId: state.orgUnitId,
        levelCode: state.orgLevelCode,
        page: pageToFetch,
        pageSize: state.pageSize,
      );

      state = state.copyWith(
        records: result.records,
        currentPage: result.page,
        pageSize: result.pageSize,
        totalItems: result.total,
        hasMore: result.hasMore,
        isLoading: false,
        clearError: true,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message, clearError: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load overtime requests: ${e.toString()}',
        clearError: false,
      );
    }
  }

  void selectCategory(OvertimeCategory category) {
    state = state.copyWith(selectedCategory: category);
  }

  void selectStatus(OvertimeStatus? status) {
    state = state.copyWith(selectedStatus: status, clearStatus: status == null, currentPage: 1);
    loadOvertime(page: 1);
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value, currentPage: 1);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      loadOvertime(page: 1);
    });
  }

  void toggleOvertimeRecord(String? id) {
    state = state.copyWith(expandedRecord: id, clearExpandedRecord: id == null);
  }

  void setCompanyId(String? companyId) {
    if (state.companyId != companyId) {
      state = state.copyWith(companyId: companyId, clearOrgFilter: true, currentPage: 1);
      loadOvertime(page: 1);
    }
  }

  void setOrgFilter(String? unitId, String? levelCode) {
    state = state.copyWith(orgUnitId: unitId, orgLevelCode: levelCode, clearOrgFilter: unitId == null, currentPage: 1);
    loadOvertime(page: 1);
  }

  void clearSearchQuery() {
    _searchDebounce?.cancel();
    _searchDebounce = null;
    state = state.copyWith(searchQuery: null, clearSearchQuery: true, currentPage: 1);
    loadOvertime(page: 1);
  }

  void resetFilters() {
    _searchDebounce?.cancel();
    _searchDebounce = null;
    state = state.copyWith(
      orgUnitId: null,
      orgLevelCode: null,
      searchQuery: null,
      clearOrgFilter: true,
      clearSearchQuery: true,
      currentPage: 1,
    );
    loadOvertime(page: 1);
  }

  void goToPage(int page) {
    loadOvertime(page: page);
  }

  Future<String?> approveOvertimeRequest(String otRequestGuid) async {
    state = state.copyWith(approvingOvertimeGuid: otRequestGuid);
    final tenantId = state.companyId != null ? int.tryParse(state.companyId!) : null;
    if (tenantId == null) {
      state = state.copyWith(clearApprovingOvertimeGuid: true);
      return 'No tenant selected';
    }
    try {
      final data = await _repository.approveOvertimeRequest(otRequestGuid, tenantId: tenantId);
      state = state.copyWith(clearApprovingOvertimeGuid: true);
      if (data != null) {
        _optimisticallyUpdateRecord(otRequestGuid, data);
      } else {
        await loadOvertime(page: state.currentPage);
      }
      return null;
    } on AppException catch (e) {
      state = state.copyWith(clearApprovingOvertimeGuid: true);
      return e.message;
    } catch (e) {
      state = state.copyWith(clearApprovingOvertimeGuid: true);
      return 'Failed to approve overtime request: ${e.toString()}';
    }
  }

  Future<String?> rejectOvertimeRequest(String otRequestGuid) async {
    state = state.copyWith(rejectingOvertimeGuid: otRequestGuid);
    final tenantId = state.companyId != null ? int.tryParse(state.companyId!) : null;
    if (tenantId == null) {
      state = state.copyWith(clearRejectingOvertimeGuid: true);
      return 'No tenant selected';
    }
    try {
      final data = await _repository.rejectOvertimeRequest(otRequestGuid, tenantId: tenantId);
      state = state.copyWith(clearRejectingOvertimeGuid: true);
      if (data != null) {
        _optimisticallyUpdateRecord(otRequestGuid, data);
      } else {
        await loadOvertime(page: state.currentPage);
      }
      return null;
    } on AppException catch (e) {
      state = state.copyWith(clearRejectingOvertimeGuid: true);
      return e.message;
    } catch (e) {
      state = state.copyWith(clearRejectingOvertimeGuid: true);
      return 'Failed to reject overtime request: ${e.toString()}';
    }
  }

  Future<String?> updateOvertimeRequest(
    String otRequestGuid, {
    required double requestedHours,
    required String reason,
  }) async {
    final tenantId = state.companyId != null ? int.tryParse(state.companyId!) : null;
    if (tenantId == null) return 'No tenant selected';
    try {
      final data = await _repository.updateOvertimeRequest(
        otRequestGuid,
        tenantId: tenantId,
        requestedHours: requestedHours,
        reason: reason,
      );
      if (data != null) {
        _optimisticallyUpdateDraftRecord(otRequestGuid, data);
      } else {
        await loadOvertime(page: state.currentPage);
      }
      return null;
    } on AppException catch (e) {
      return e.message;
    } catch (e) {
      return 'Failed to update overtime request: ${e.toString()}';
    }
  }

  void _optimisticallyUpdateDraftRecord(String otRequestGuid, Map<String, dynamic> data) {
    final records = state.records;
    if (records == null || records.isEmpty) return;
    final newRecords = records.map((r) {
      if (r.otRequestGuid == otRequestGuid) {
        return OvertimeRecord.updatedFromDraftUpdate(r, data);
      }
      return r;
    }).toList();
    state = state.copyWith(records: newRecords);
  }

  Future<String?> cancelOvertimeRequest(String otRequestGuid) async {
    state = state.copyWith(cancelingOvertimeGuid: otRequestGuid);
    final tenantId = state.companyId != null ? int.tryParse(state.companyId!) : null;
    if (tenantId == null) {
      state = state.copyWith(clearCancelingOvertimeGuid: true);
      return 'No tenant selected';
    }
    try {
      await _repository.cancelOvertimeRequest(otRequestGuid, tenantId: tenantId);
      state = state.copyWith(clearCancelingOvertimeGuid: true);
      _optimisticallyRemoveRecord(otRequestGuid);
      return null;
    } on AppException catch (e) {
      state = state.copyWith(clearCancelingOvertimeGuid: true);
      return e.message;
    } catch (e) {
      state = state.copyWith(clearCancelingOvertimeGuid: true);
      return 'Failed to cancel overtime request: ${e.toString()}';
    }
  }

  void _optimisticallyUpdateRecord(String otRequestGuid, Map<String, dynamic> data) {
    final records = state.records;
    if (records == null || records.isEmpty) return;
    final newRecords = records.map((r) {
      if (r.otRequestGuid == otRequestGuid) {
        return OvertimeRecord.updatedFromActionResponse(r, data);
      }
      return r;
    }).toList();
    state = state.copyWith(records: newRecords);
  }

  void _optimisticallyRemoveRecord(String otRequestGuid) {
    final records = state.records;
    if (records == null || records.isEmpty) return;
    final newRecords = records.where((r) => r.otRequestGuid != otRequestGuid).toList();
    final newTotal = (state.totalItems - 1).clamp(0, state.totalItems);
    state = state.copyWith(records: newRecords, totalItems: newTotal);
  }
}

final overtimeManagementProvider = StateNotifierProvider<OvertimeManagementNotifier, OvertimeManagement>((ref) {
  final repo = ref.watch(overtimeRepositoryProvider);
  return OvertimeManagementNotifier(repo);
});
