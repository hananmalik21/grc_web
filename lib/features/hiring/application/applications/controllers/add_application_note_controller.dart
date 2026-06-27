import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/features/hiring/application/applications/providers/application_detail_controller_provider.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_api_providers.dart';
import 'package:grc/features/hiring/application/applications/states/add_application_note_state.dart';
import 'package:grc/features/hiring/application/applications/states/application_detail_state.dart';
import 'package:grc/features/hiring/domain/models/applications/add_application_note_input.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddApplicationNoteNotifier extends AutoDisposeFamilyNotifier<AddApplicationNoteState, AddApplicationNoteParams> {
  @override
  AddApplicationNoteState build(AddApplicationNoteParams params) {
    return const AddApplicationNoteState();
  }

  void setNoteTypeCode(String? code) {
    if (code == null) return;
    state = state.copyWith(
      noteTypeCode: code,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('noteType'),
      clearSubmitError: true,
    );
  }

  void setNoteText(String value) {
    state = state.copyWith(
      noteText: value,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove('noteText'),
      clearSubmitError: true,
    );
  }

  void setIsPrivate(bool value) {
    state = state.copyWith(isPrivate: value, clearSubmitError: true);
  }

  bool validate() {
    final errors = <String, String>{};
    if (state.noteText.trim().isEmpty) {
      errors['noteText'] = 'Notes are required';
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
      final createdBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';
      await ref
          .read(addApplicationNoteUseCaseProvider)
          .call(
            AddApplicationNoteInput(
              applicationGuid: params.applicationGuid,
              enterpriseId: params.enterpriseId,
              noteTypeCode: state.noteTypeCode,
              noteText: state.noteText,
              isPrivate: state.isPrivate,
              createdBy: createdBy,
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
      state = state.copyWith(isSubmitting: false, submitError: 'Failed to save note. Please try again.');
      return false;
    }
  }
}
