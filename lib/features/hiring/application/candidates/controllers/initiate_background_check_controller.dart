import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/features/hiring/application/candidates/mappers/initiate_background_check_request_mapper.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_api_providers.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/candidates/states/initiate_background_check_state.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/application/candidates/providers/get_candidate_detail_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InitiateBackgroundCheckNotifier extends AutoDisposeFamilyNotifier<InitiateBackgroundCheckState, String> {
  @override
  InitiateBackgroundCheckState build(String candidateGuid) {
    return InitiateBackgroundCheckState(candidateGuid: candidateGuid);
  }

  void setProvider(String value) {
    state = state.copyWith(provider: value, clearSubmitError: true);
  }

  void setCheckType(BackgroundCheckType value) {
    state = state.copyWith(checkType: value, clearSubmitError: true);
  }

  void toggleComponent(BackgroundCheckComponent component, bool selected) {
    final components = Set<BackgroundCheckComponent>.from(state.selectedComponents);
    if (selected) {
      components.add(component);
    } else {
      components.remove(component);
    }
    state = state.copyWith(selectedComponents: components, clearSubmitError: true);
  }

  void setPriority(String? value) {
    state = state.copyWith(
      priority: value,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('priority'),
      clearSubmitError: true,
    );
  }

  void setAdditionalNotes(String value) {
    state = state.copyWith(additionalNotes: value, clearSubmitError: true);
  }

  bool validate() {
    final errors = <String, String>{};
    final priority = state.priority?.trim().toUpperCase();
    if (priority == null || priority.isEmpty || !HiringConfig.backgroundCheckPriorityOptions.contains(priority)) {
      errors['priority'] = 'Priority is required';
    }
    if (state.selectedComponents.isEmpty) {
      errors['components'] = 'Select at least one check component';
    }

    state = state.copyWith(fieldErrors: errors, clearSubmitError: true);
    return errors.isEmpty;
  }

  Future<bool> submit() async {
    if (!validate()) return false;

    final enterpriseId = ref.read(candidatesTabEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      state = state.copyWith(submitError: 'Select an enterprise first');
      return false;
    }

    final createdBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';

    final input = InitiateBackgroundCheckRequestMapper.fromState(
      state: state,
      enterpriseId: enterpriseId,
      createdBy: createdBy,
    );

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      await ref.read(initiateBackgroundCheckUseCaseProvider).call(input);

      final detailParams = GetCandidateDetailParams(enterpriseId: enterpriseId, candidateGuid: state.candidateGuid);
      ref.invalidate(getCandidateDetailProvider(detailParams));
      ref.invalidate(getCandidateDetailDataProvider(detailParams));

      state = state.copyWith(isSubmitting: false);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        submitError: 'Failed to initiate background check. Please try again.',
      );
      return false;
    }
  }
}
