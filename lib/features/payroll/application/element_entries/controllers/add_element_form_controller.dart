import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_assigned_component.dart';
import 'package:grc/features/payroll/application/element_entries/mappers/add_element_form_request_mapper.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_repository_provider.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_tab_provider.dart';
import 'package:grc/features/payroll/application/element_entries/states/add_element_form_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddElementFormController extends AutoDisposeNotifier<AddElementFormState> {
  static const String approvalStatusDraft = 'DRAFT';
  static const String approvalStatusSubmitted = 'SUBMITTED';

  @override
  AddElementFormState build() {
    final employee = ref.watch(elementEntriesTabProvider.select((s) => s.selectedEmployee));
    return AddElementFormState.initial(assignmentNumber: employee?.assignmentNumber ?? '');
  }

  void initializeDefaults(AddElementFormDefaults defaults) {
    if (state.isInitialized) return;

    state = state.copyWith(isInitialized: true, creatorType: defaults.creatorType);
  }

  void clearElementComponent() {
    if (state.elementComponent == null) return;
    state = state.copyWith(clearElementComponent: true);
  }

  void syncAssignmentNumber(String assignmentNumber) {
    if (state.assignmentNumber == assignmentNumber) return;
    state = state.copyWith(assignmentNumber: assignmentNumber);
  }

  void reset() {
    final employee = ref.read(elementEntriesTabProvider.select((s) => s.selectedEmployee));
    state = AddElementFormState.initial(assignmentNumber: employee?.assignmentNumber ?? '');
  }

  void setEffectiveAsOfDate(DateTime value) => state = state.copyWith(effectiveAsOfDate: value);

  void setEffectiveStartDate(DateTime value) => state = state.copyWith(effectiveStartDate: value);

  void setEffectiveEndDate(DateTime value) => state = state.copyWith(effectiveEndDate: value);

  void setEntryType(String? value) => state = state.copyWith(entryType: value);

  void setSource(String? value) => state = state.copyWith(source: value);

  void setElementProcessingType(String? value) => state = state.copyWith(elementProcessingType: value);

  void setElementComponent(EmployeeAssignedComponent? value) =>
      state = state.copyWith(elementComponent: value, clearElementComponent: value == null);

  void setElementClassification(String? value) => state = state.copyWith(elementClassification: value);

  void setCreatorType(String? value) => state = state.copyWith(creatorType: value);

  void setPayValue(String value) => state = state.copyWith(payValue: value);

  void setContextSegment(String? value) =>
      state = state.copyWith(contextSegment: value, clearContextSegment: value == null);

  void setSubpriority(String value) => state = state.copyWith(subpriority: value);

  void setSequenceNumber(String value) => state = state.copyWith(sequenceNumber: value);

  void setReason(String value) => state = state.copyWith(reason: value);

  void setAmount(String value) => state = state.copyWith(amount: value);

  void setCostAllocationKeyFlexfield(String? value) =>
      state = state.copyWith(costAllocationKeyFlexfield: value, clearCostAllocationKeyFlexfield: value == null);

  void setCostingType(String? value) => state = state.copyWith(costingType: value, clearCostingType: value == null);

  void setAccountCode(String value) => state = state.copyWith(accountCode: value);

  void setCostCentre(String value) => state = state.copyWith(costCentre: value);

  void setProcessed(bool value) => state = state.copyWith(processed: value);

  void setRetroactiveEntry(bool value) => state = state.copyWith(retroactiveEntry: value);

  void setAutomaticEntry(bool value) => state = state.copyWith(automaticEntry: value);

  void setSelectedTab(AddElementTab tab) => state = state.copyWith(selectedTab: tab);

  String? firstValidationError(AppLocalizations loc) {
    final enterpriseId = ref.read(elementEntriesEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) return loc.payrollAddElementValidationEnterprise;

    final employeeId = ref.read(elementEntriesTabProvider.select((s) => s.selectedEmployee?.employeeId));
    if (employeeId == null || employeeId <= 0) return loc.payrollAddElementValidationEmployee;

    if (state.effectiveAsOfDate == null) return loc.payrollAddElementValidationEffectiveAsOfDate;
    if (state.entryType == null || state.entryType!.isEmpty) return loc.payrollAddElementValidationEntryType;
    if (state.elementComponent == null) return loc.payrollAddElementValidationElement;
    if (state.effectiveStartDate == null) return loc.payrollAddElementValidationEffectiveStartDate;
    if (state.amount.trim().isEmpty) return loc.payrollAddElementValidationAmount;
    return null;
  }

  Future<String?> saveDraft(AppLocalizations loc) async {
    return _createElementEntry(approvalStatusCode: approvalStatusDraft, validate: true, loc: loc);
  }

  Future<String?> submit(AppLocalizations loc) async {
    return _createElementEntry(approvalStatusCode: approvalStatusSubmitted, validate: true, loc: loc);
  }

  Future<String?> _createElementEntry({
    required String approvalStatusCode,
    required bool validate,
    AppLocalizations? loc,
  }) async {
    if (state.isSavingDraft || state.isSubmitting) return null;

    if (validate) {
      final validationError = firstValidationError(loc!);
      if (validationError != null) return validationError;
    }

    final enterpriseId = ref.read(elementEntriesEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      return loc?.payrollAddElementValidationEnterprise ?? 'Enterprise is required';
    }

    final employeeId = ref.read(elementEntriesTabProvider.select((s) => s.selectedEmployee?.employeeId));
    if (employeeId == null || employeeId <= 0) {
      return loc?.payrollAddElementValidationEmployee ?? 'Employee is required';
    }

    final isDraft = approvalStatusCode == approvalStatusDraft;
    state = state.copyWith(isSavingDraft: isDraft, isSubmitting: !isDraft);

    try {
      final request = AddElementFormRequestMapper.toRequestDto(
        state: state,
        enterpriseId: enterpriseId,
        employeeId: employeeId,
        approvalStatusCode: approvalStatusCode,
      );

      await ref.read(elementEntriesRepositoryProvider).createElementEntry(request);
      return null;
    } on AppException catch (e) {
      return e.displayMessage;
    } on FormatException {
      return loc?.payrollAddElementValidationAmount ?? 'Invalid form data';
    } catch (e) {
      return e.toString();
    } finally {
      state = state.copyWith(isSavingDraft: false, isSubmitting: false);
    }
  }
}
