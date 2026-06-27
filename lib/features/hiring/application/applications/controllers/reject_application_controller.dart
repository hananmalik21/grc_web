import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/features/hiring/application/applications/providers/application_detail_controller_provider.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_api_providers.dart';
import 'package:grc/features/hiring/application/applications/states/application_detail_state.dart';
import 'package:grc/features/hiring/application/applications/states/reject_application_state.dart';
import 'package:grc/features/hiring/domain/models/applications/reject_application_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RejectApplicationNotifier extends AutoDisposeFamilyNotifier<RejectApplicationState, RejectApplicationParams> {
  @override
  RejectApplicationState build(RejectApplicationParams params) {
    return const RejectApplicationState();
  }

  void setRejectionReasonCode(String? code) {
    state = state.copyWith(
      rejectionReasonCode: code,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('reason'),
      clearSubmitError: true,
    );
  }

  void setRejectionComments(String value) {
    state = state.copyWith(rejectionComments: value, clearSubmitError: true);
  }

  void setSendEmail(bool value) {
    state = state.copyWith(sendEmail: value, clearSubmitError: true);
  }

  bool validate() {
    final errors = <String, String>{};
    if (state.rejectionReasonCode == null || state.rejectionReasonCode!.trim().isEmpty) {
      errors['reason'] = 'Please select a rejection reason';
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

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      final rejectedBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';
      await ref
          .read(rejectApplicationUseCaseProvider)
          .call(
            RejectApplicationInput(
              applicationGuid: params.applicationGuid,
              enterpriseId: params.enterpriseId,
              rejectionReasonCode: state.rejectionReasonCode!,
              rejectionComments: state.rejectionComments,
              sendEmail: state.sendEmail,
              rejectedBy: rejectedBy,
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
      state = state.copyWith(isSubmitting: false, submitError: 'Failed to reject application. Please try again.');
      return false;
    }
  }
}
