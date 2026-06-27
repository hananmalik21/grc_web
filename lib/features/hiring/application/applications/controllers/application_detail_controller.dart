import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/hiring/application/applications/mappers/application_detail_mapper.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_api_providers.dart';
import 'package:grc/features/hiring/application/applications/states/application_detail_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApplicationDetailNotifier extends AutoDisposeFamilyNotifier<ApplicationDetailState, ApplicationDetailParams> {
  @override
  ApplicationDetailState build(ApplicationDetailParams params) {
    Future.microtask(() => loadDetail());
    return ApplicationDetailState.initial();
  }

  Future<void> loadDetail() async {
    final params = arg;
    if (params.enterpriseId <= 0 || params.applicationGuid.isEmpty) {
      state = state.copyWith(isLoading: false, error: 'Application not found');
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final domain = await ref
          .read(getApplicationDetailUseCaseProvider)
          .call(applicationGuid: params.applicationGuid, enterpriseId: params.enterpriseId);

      state = state.copyWith(detail: toApplicationDetailData(domain), isLoading: false, clearError: true);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Failed to load application. Please try again.');
    }
  }

  void retry() => loadDetail();
}
