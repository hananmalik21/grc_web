import 'package:grc/features/employee_management/domain/models/create_employee_basic_info_request.dart';
import 'package:grc/features/employee_management/domain/models/update_employee_basic_info_request.dart';
import 'package:grc/features/employee_management/domain/repositories/manage_employees_list_repository.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:grc/features/leave_management/domain/models/document.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEmployeeBasicInfoState {
  final CreateEmployeeBasicInfoRequest form;
  final bool isSubmitting;
  final String? submitError;

  final int formGenerationId;

  const AddEmployeeBasicInfoState({
    this.form = const CreateEmployeeBasicInfoRequest(),
    this.isSubmitting = false,
    this.submitError,
    this.formGenerationId = 0,
  });

  AddEmployeeBasicInfoState copyWith({
    CreateEmployeeBasicInfoRequest? form,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    int? formGenerationId,
  }) {
    return AddEmployeeBasicInfoState(
      form: form ?? this.form,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      formGenerationId: formGenerationId ?? this.formGenerationId,
    );
  }
}

class AddEmployeeBasicInfoNotifier extends StateNotifier<AddEmployeeBasicInfoState> {
  AddEmployeeBasicInfoNotifier(this._repository) : super(const AddEmployeeBasicInfoState());

  final ManageEmployeesListRepository _repository;

  void setFirstNameEn(String? value) {
    state = state.copyWith(
      form: state.form.copyWith(firstNameEn: value, clearFirstNameEn: value == null),
    );
  }

  void setLastNameEn(String? value) {
    state = state.copyWith(
      form: state.form.copyWith(lastNameEn: value, clearLastNameEn: value == null),
    );
  }

  void setMiddleNameEn(String? value) {
    state = state.copyWith(
      form: state.form.copyWith(middleNameEn: value, clearMiddleNameEn: value == null),
    );
  }

  void setFourthNameEn(String? value) {
    state = state.copyWith(
      form: state.form.copyWith(fourthNameEn: value, clearFourthNameEn: value == null),
    );
  }

  void setFirstNameAr(String? value) {
    state = state.copyWith(
      form: state.form.copyWith(firstNameAr: value, clearFirstNameAr: value == null),
    );
  }

  void setLastNameAr(String? value) {
    state = state.copyWith(
      form: state.form.copyWith(lastNameAr: value, clearLastNameAr: value == null),
    );
  }

  void setMiddleNameAr(String? value) {
    state = state.copyWith(
      form: state.form.copyWith(middleNameAr: value, clearMiddleNameAr: value == null),
    );
  }

  void setFourthNameAr(String? value) {
    state = state.copyWith(
      form: state.form.copyWith(fourthNameAr: value, clearFourthNameAr: value == null),
    );
  }

  void setEmail(String? value) {
    state = state.copyWith(
      form: state.form.copyWith(email: value, clearEmail: value == null),
    );
  }

  void setPhoneNumber(String? value) {
    state = state.copyWith(
      form: state.form.copyWith(phoneNumber: value, clearPhoneNumber: value == null),
    );
  }

  void setPhoneDialCode(String value) {
    state = state.copyWith(form: state.form.copyWith(phoneDialCode: value));
  }

  void setMobileNumber(String? value) {
    state = state.copyWith(
      form: state.form.copyWith(mobileNumber: value, clearMobileNumber: value == null),
    );
  }

  void setMobileDialCode(String value) {
    state = state.copyWith(form: state.form.copyWith(mobileDialCode: value));
  }

  void setDateOfBirth(DateTime? value) {
    state = state.copyWith(
      form: state.form.copyWith(dateOfBirth: value, clearDateOfBirth: value == null),
    );
  }

  void setEmployeeStatus(String? value) {
    state = state.copyWith(
      form: state.form.copyWith(employeeStatus: value, clearEmployeeStatus: value == null),
    );
  }

  void clearSubmitError() {
    state = state.copyWith(clearSubmitError: true);
  }

  void reset() {
    state = const AddEmployeeBasicInfoState(formGenerationId: 0);
  }

  Future<bool> submitStep1() async {
    if (!state.form.isStep1Valid) {
      state = state.copyWith(clearSubmitError: true);
      return false;
    }
    final (ok, _) = await submitWithRequest(state.form);
    return ok;
  }

  Future<(bool, Map<String, dynamic>?)> submitWithRequest(
    CreateEmployeeBasicInfoRequest request, {
    Document? document,
    String? documentTypeCode,
  }) async {
    state = state.copyWith(isSubmitting: true, clearSubmitError: true);
    try {
      final response = await _repository.createEmployee(
        request,
        document: document,
        documentTypeCode: documentTypeCode,
      );
      final result = response as Map<String, dynamic>?;
      final success = result?['success'] as bool? ?? false;
      state = state.copyWith(isSubmitting: false);
      return (success, result);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.toString().replaceFirst(RegExp(r'^Exception: '), ''));
      return (false, null);
    }
  }

  void setForm(CreateEmployeeBasicInfoRequest form) {
    state = state.copyWith(form: form, formGenerationId: state.formGenerationId + 1);
  }

  Future<(bool, Map<String, dynamic>?)> submitUpdate(
    String employeeGuid,
    UpdateEmployeeBasicInfoRequest request, {
    Document? document,
    String? documentTypeCode,
    String? docAction,
    int? replaceDocumentId,
  }) async {
    state = state.copyWith(isSubmitting: true, clearSubmitError: true);
    try {
      final response = await _repository.updateEmployee(
        employeeGuid,
        request,
        document: document,
        documentTypeCode: documentTypeCode,
        docAction: docAction,
        replaceDocumentId: replaceDocumentId,
      );
      final result = response as Map<String, dynamic>?;
      final success = result?['success'] as bool? ?? false;
      state = state.copyWith(isSubmitting: false);
      return (success, result);
    } catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.toString().replaceFirst(RegExp(r'^Exception: '), ''));
      return (false, null);
    }
  }
}

final addEmployeeBasicInfoProvider = StateNotifierProvider<AddEmployeeBasicInfoNotifier, AddEmployeeBasicInfoState>(
  (ref) => AddEmployeeBasicInfoNotifier(ref.read(manageEmployeesListRepositoryProvider)),
);
