import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/hiring/application/requisition/mappers/job_posting_view_mapper.dart';
import 'package:grc/features/hiring/application/requisition/providers/job_postings_api_providers.dart';
import 'package:grc/features/hiring/application/requisition/providers/requisitions_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/requisition/states/requisition_job_postings_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequisitionJobPostingsNotifier extends AutoDisposeFamilyNotifier<RequisitionJobPostingsState, String> {
  @override
  RequisitionJobPostingsState build(String requisitionGuid) {
    ref.listen<int?>(requisitionsTabEnterpriseIdProvider, (previous, next) {
      if (previous == next) return;
      Future.microtask(refresh);
    });

    return const RequisitionJobPostingsState();
  }

  Future<void> refresh() async {
    final enterpriseId = ref.read(requisitionsTabEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      state = const RequisitionJobPostingsState(error: 'Select an enterprise first');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final postings = await ref
          .read(getJobPostingsByRequisitionUseCaseProvider)
          .call(enterpriseId: enterpriseId, requisitionGuid: arg);

      final items = postings.map(JobPostingViewMapper.fromDomain).toList();

      state = RequisitionJobPostingsState(items: items);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Failed to load job postings. Please try again.');
    }
  }
}
