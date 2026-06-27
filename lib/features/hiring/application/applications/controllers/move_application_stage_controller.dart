import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/features/hiring/application/applications/providers/application_detail_controller_provider.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_api_providers.dart';
import 'package:grc/features/hiring/application/applications/states/application_detail_state.dart';
import 'package:grc/features/hiring/application/applications/states/move_application_stage_state.dart';
import 'package:grc/features/hiring/domain/models/applications/change_application_stage_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MoveApplicationStageNotifier
    extends AutoDisposeFamilyNotifier<MoveApplicationStageState, MoveApplicationStageParams> {
  @override
  MoveApplicationStageState build(MoveApplicationStageParams params) {
    return MoveApplicationStageState(currentStageCode: params.currentStageCode);
  }

  void setSelectedStageCode(String? code) {
    state = state.copyWith(
      selectedStageCode: code,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('stage'),
      clearSubmitError: true,
    );
  }

  void setComments(String value) {
    state = state.copyWith(comments: value, clearSubmitError: true);
  }

  bool validate() {
    final errors = <String, String>{};
    final target = state.selectedStageCode?.trim().toUpperCase() ?? '';

    if (target.isEmpty) {
      errors['stage'] = 'Please select a stage';
    } else if (target == state.currentStageCode.trim().toUpperCase()) {
      errors['stage'] = 'Selected stage must be different from the current stage';
    }

    state = state.copyWith(fieldErrors: errors, clearSubmitError: true);
    return errors.isEmpty;
  }

  Future<bool> submit() async {
    if (!validate()) return false;

    final params = arg;
    if (params.enterpriseId <= 0 || params.applicationGuid.isEmpty) {
      state = state.copyWith(submitError: 'Application not found');
      return false;
    }

    final target = state.selectedStageCode!.trim().toUpperCase();
    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      final updatedBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';
      await ref
          .read(changeApplicationStageUseCaseProvider)
          .call(
            ChangeApplicationStageInput(
              applicationGuid: params.applicationGuid,
              enterpriseId: params.enterpriseId,
              currentStageCode: target,
              updatedBy: updatedBy,
              comments: state.comments,
            ),
          );

      final detailParams = ApplicationDetailParams(
        enterpriseId: params.enterpriseId,
        applicationGuid: params.applicationGuid,
      );
      await ref.read(applicationDetailControllerProvider(detailParams).notifier).loadDetail();

      state = state.copyWith(isSubmitting: false);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(isSubmitting: false, submitError: 'Failed to change application stage. Please try again.');
      return false;
    }
  }
}
