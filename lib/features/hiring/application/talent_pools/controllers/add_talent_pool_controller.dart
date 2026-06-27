import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/get_candidate_detail_provider.dart';
import 'package:grc/features/hiring/application/talent_pools/add_talent_pool_args.dart';
import 'package:grc/features/hiring/application/talent_pools/config/add_talent_pool_config.dart';
import 'package:grc/features/hiring/application/talent_pools/providers/talent_pools_api_providers.dart';
import 'package:grc/features/hiring/application/talent_pools/states/add_talent_pool_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTalentPoolNotifier extends AutoDisposeFamilyNotifier<AddTalentPoolState, AddTalentPoolArgs> {
  @override
  AddTalentPoolState build(AddTalentPoolArgs args) {
    Future.microtask(() => loadPools(page: 1));
    return AddTalentPoolState(
      candidateGuid: args.candidateGuid,
      selectedPoolGuids: args.initialSelectedPoolGuids,
      pageSize: AddTalentPoolConfig.pageSize,
    );
  }

  Future<void> loadPools({int? page}) async {
    final targetPage = page ?? state.currentPage;
    final enterpriseId = ref.read(candidatesTabEnterpriseIdProvider);

    if (enterpriseId == null || enterpriseId <= 0) {
      state = state.copyWith(isLoading: false, loadError: 'Select an enterprise first', clearLoadError: false);
      return;
    }

    state = state.copyWith(isLoading: true, clearLoadError: true);

    try {
      final response = await ref
          .read(getTalentPoolsUseCaseProvider)
          .call(enterpriseId: enterpriseId, page: targetPage, pageSize: AddTalentPoolConfig.pageSize);

      final pagination = response.pagination;
      final domainPage = response.toDomain();

      state = state.copyWith(
        pools: domainPage.items,
        currentPage: pagination?.page ?? targetPage,
        totalPages: pagination?.totalPages ?? 1,
        totalItems: pagination?.total ?? domainPage.items.length,
        pageSize: pagination?.pageSize ?? AddTalentPoolConfig.pageSize,
        hasNext: pagination?.hasNext ?? false,
        hasPrevious: pagination?.hasPrevious ?? false,
        isLoading: false,
        clearLoadError: true,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, loadError: e.message);
    } catch (_) {
      state = state.copyWith(isLoading: false, loadError: 'Failed to load talent pools. Please try again.');
    }
  }

  void togglePoolSelection(String poolGuid) {
    final normalized = normalizeTalentPoolGuid(poolGuid);
    final updated = Set<String>.from(state.selectedPoolGuids);
    if (updated.contains(normalized)) {
      updated.remove(normalized);
    } else {
      updated.add(normalized);
    }
    state = state.copyWith(selectedPoolGuids: updated);
  }

  void setNewPoolName(String value) {
    state = state.copyWith(newPoolName: value, clearCreatePoolError: true);
  }

  Future<bool> createPool() async {
    final enterpriseId = ref.read(candidatesTabEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      state = state.copyWith(createPoolError: 'Select an enterprise first');
      return false;
    }

    final poolName = state.newPoolName.trim();
    if (poolName.isEmpty) {
      state = state.copyWith(createPoolError: 'Pool name is required');
      return false;
    }

    final createdBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';

    state = state.copyWith(isCreatingPool: true, clearCreatePoolError: true);
    try {
      await ref
          .read(createTalentPoolUseCaseProvider)
          .call(enterpriseId: enterpriseId, poolName: poolName, createdBy: createdBy);

      state = state.copyWith(newPoolName: '', isCreatingPool: false);
      await loadPools(page: 1);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isCreatingPool: false, createPoolError: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(isCreatingPool: false, createPoolError: 'Failed to create talent pool. Please try again.');
      return false;
    }
  }

  Future<bool> addCandidateToSelectedPools() async {
    final enterpriseId = ref.read(candidatesTabEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      state = state.copyWith(assignPoolsError: 'Select an enterprise first');
      return false;
    }

    if (state.selectedPoolGuids.isEmpty) {
      state = state.copyWith(assignPoolsError: 'Select at least one pool');
      return false;
    }

    final updatedBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';

    state = state.copyWith(isAssigningPools: true, clearAssignPoolsError: true);
    try {
      await ref
          .read(addCandidateToTalentPoolsUseCaseProvider)
          .call(
            candidateGuid: state.candidateGuid,
            enterpriseId: enterpriseId,
            poolGuids: state.selectedPoolGuids.toList(),
            updatedBy: updatedBy,
          );

      final detailParams = GetCandidateDetailParams(enterpriseId: enterpriseId, candidateGuid: state.candidateGuid);
      ref.invalidate(getCandidateDetailProvider(detailParams));
      ref.invalidate(getCandidateDetailDataProvider(detailParams));

      state = state.copyWith(isAssigningPools: false);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isAssigningPools: false, assignPoolsError: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isAssigningPools: false,
        assignPoolsError: 'Failed to add candidate to selected pools. Please try again.',
      );
      return false;
    }
  }

  Future<void> nextPage() async {
    if (!state.hasNext || state.isLoading) return;
    await loadPools(page: state.currentPage + 1);
  }

  Future<void> previousPage() async {
    if (!state.hasPrevious || state.isLoading) return;
    await loadPools(page: state.currentPage - 1);
  }
}
