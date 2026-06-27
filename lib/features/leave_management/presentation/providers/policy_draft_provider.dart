import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/leave_management/data/dto/abs_policies_dto.dart';
import 'package:grc/features/leave_management/domain/models/policy_detail.dart';
import 'package:grc/features/leave_management/presentation/providers/abs_policies_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_configuration_tab_enterprise_provider.dart';

class PolicyDraftNotifier extends StateNotifier<PolicyDetail?> {
  PolicyDraftNotifier() : super(null);

  PolicyDetail? get currentDraft => state;

  void setDraft(PolicyDetail detail) {
    state = detail;
  }

  void clear() {
    state = null;
  }

  void updatePolicyName(String? name) {
    state = state?.copyWith(policyName: name);
  }

  void updateLeaveType(int leaveTypeId, String leaveTypeEn, String leaveTypeAr) {
    state = state?.copyWith(leaveTypeId: leaveTypeId, leaveTypeEn: leaveTypeEn, leaveTypeAr: leaveTypeAr);
  }

  void updateEntitlementDays(int value) {
    state = state?.copyWith(entitlementDays: value);
  }

  void toggleEmployeeCategoryCode(String code, bool checked) {
    if (state == null) return;
    final codes = state!.employeeCategoryCodes.toList();
    if (checked) {
      if (!codes.contains(code)) codes.add(code);
    } else {
      codes.remove(code);
    }
    state = state!.copyWith(employeeCategoryCodes: codes);
  }

  void updateEmployeeCategoryCodes(List<String> codes) {
    state = state?.copyWith(employeeCategoryCodes: codes);
  }

  void toggleEmploymentTypeCode(String code, bool checked) {
    if (state == null) return;
    final codes = state!.employmentTypeCodes.toList();
    if (checked) {
      if (!codes.contains(code)) codes.add(code);
    } else {
      codes.remove(code);
    }
    state = state!.copyWith(employmentTypeCodes: codes);
  }

  void updateEmploymentTypeCodes(List<String> codes) {
    state = state?.copyWith(employmentTypeCodes: codes);
  }

  void toggleContractTypeCode(String code, bool checked) {
    if (state == null) return;
    final codes = state!.contractTypeCodes.toList();
    if (checked) {
      if (!codes.contains(code)) codes.add(code);
    } else {
      codes.remove(code);
    }
    state = state!.copyWith(contractTypeCodes: codes);
  }

  void updateContractTypeCodes(List<String> codes) {
    state = state?.copyWith(contractTypeCodes: codes);
  }

  void toggleGenderCode(String code, bool checked) {
    if (state == null) return;
    final codes = state!.genderCodes.toList();
    if (checked) {
      if (!codes.contains(code)) codes.add(code);
    } else {
      codes.remove(code);
    }
    state = state!.copyWith(genderCodes: codes);
  }

  void updateGenderCodes(List<String> codes) {
    state = state?.copyWith(genderCodes: codes);
  }

  void toggleReligionCode(String code, bool checked) {
    if (state == null) return;
    final codes = state!.religionCodes.toList();
    if (checked) {
      if (!codes.contains(code)) codes.add(code);
    } else {
      codes.remove(code);
    }
    state = state!.copyWith(religionCodes: codes);
  }

  void updateReligionCodes(List<String> codes) {
    state = state?.copyWith(religionCodes: codes);
  }

  void toggleMaritalStatusCode(String code, bool checked) {
    if (state == null) return;
    final codes = state!.maritalStatusCodes.toList();
    if (checked) {
      if (!codes.contains(code)) codes.add(code);
    } else {
      codes.remove(code);
    }
    state = state!.copyWith(maritalStatusCodes: codes);
  }

  void updateMaritalStatusCodes(List<String> codes) {
    state = state?.copyWith(maritalStatusCodes: codes);
  }

  void updateProbationAllowed(bool value) {
    state = state?.copyWith(probationAllowed: value);
  }

  void updateMinServiceYears(int? value) {
    state = state?.copyWith(minServiceYears: value);
  }

  void updateMaxServiceYears(int? value) {
    state = state?.copyWith(maxServiceYears: value);
  }

  void updateGradeRowAt(int index, GradeEntitlement grade) {
    final List<GradeEntitlement> list = state?.gradeRows.toList() ?? <GradeEntitlement>[];
    if (index < 0 || index >= list.length) return;
    list[index] = grade;
    state = state?.copyWith(gradeRows: list);
  }

  void addGradeRow() {
    final policyCode = state?.accrualMethod.code;
    final newRow = GradeEntitlement(
      entitlementId: 0,
      gradeFrom: 1,
      gradeTo: null,
      entitlementDays: 0,
      accrualRate: null,
      isActive: true,
      accrualMethodCode: policyCode,
    );
    final List<GradeEntitlement> list = [...(state?.gradeRows ?? <GradeEntitlement>[]), newRow];
    state = state?.copyWith(gradeRows: list);
  }

  void removeGradeRowAt(int index) {
    final List<GradeEntitlement> list = state?.gradeRows.toList() ?? <GradeEntitlement>[];
    if (index < 0 || index >= list.length) return;
    list.removeAt(index);
    state = state?.copyWith(gradeRows: list);
  }

  void updateEnableProRata(bool value) {
    state = state?.copyWith(enableProRata: value);
  }

  void updateEffectiveStartDate(DateTime? value) {
    state = state?.copyWith(effectiveStartDate: value);
  }

  void updateEffectiveEndDate(DateTime? value) {
    state = state?.copyWith(effectiveEndDate: value);
  }

  void updateMinNoticeDays(int? value) {
    state = state?.copyWith(minNoticeDays: value);
  }

  void updateMaxConsecutiveDays(int? value) {
    state = state?.copyWith(maxConsecutiveDays: value);
  }

  void updateRequiresDocument(bool value) {
    state = state?.copyWith(requiresDocument: value);
  }

  void updateCountWeekendsAsLeave(bool value) {
    state = state?.copyWith(countWeekendsAsLeave: value);
  }

  void updateAllowCarryForward(bool value) {
    state = state?.copyWith(allowCarryForward: value);
  }

  void updateCarryForwardLimitDays(int? value) {
    state = state?.copyWith(carryForwardLimitDays: value);
  }

  void updateGracePeriodDays(int? value) {
    state = state?.copyWith(gracePeriodDays: value);
  }

  void updateAutoForfeit(bool value) {
    state = state?.copyWith(autoForfeit: value);
  }

  void updateAllowEncashment(bool value) {
    state = state?.copyWith(allowEncashment: value);
  }

  void updateEncashmentLimitDays(int? value) {
    state = state?.copyWith(encashmentLimitDays: value);
  }

  void updateEncashmentRatePct(int? value) {
    state = state?.copyWith(encashmentRatePct: value);
  }
}

final policyDraftProvider = StateNotifierProvider<PolicyDraftNotifier, PolicyDetail?>((ref) {
  return PolicyDraftNotifier();
});

final addPolicyDialogDraftProvider = StateNotifierProvider<PolicyDraftNotifier, PolicyDetail?>((ref) {
  return PolicyDraftNotifier();
});

class AddPolicyDialogUiState {
  final bool isLoading;

  const AddPolicyDialogUiState({this.isLoading = false});

  AddPolicyDialogUiState copyWith({bool? isLoading}) {
    return AddPolicyDialogUiState(isLoading: isLoading ?? this.isLoading);
  }
}

class AddPolicyDialogUiNotifier extends StateNotifier<AddPolicyDialogUiState> {
  AddPolicyDialogUiNotifier() : super(const AddPolicyDialogUiState());

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void reset() {
    state = const AddPolicyDialogUiState();
  }
}

final addPolicyDialogUiStateProvider = StateNotifierProvider<AddPolicyDialogUiNotifier, AddPolicyDialogUiState>((ref) {
  return AddPolicyDialogUiNotifier();
});

const String _kAddPolicyCreatedBy = 'ADMIN';

class AddPolicyCreateNotifier {
  AddPolicyCreateNotifier(this._ref);

  final Ref _ref;

  Future<bool> create(PolicyDetail? draft, BuildContext context) async {
    final tenantId = _ref.read(policyConfigurationTabEnterpriseIdProvider);
    if (tenantId == null) {
      ToastService.warning(context, 'Select an enterprise first');
      return false;
    }
    if (draft == null) {
      ToastService.error(context, 'Form data is missing');
      return false;
    }
    final policyName = (draft.policyName ?? draft.leaveTypeEn).trim();
    if (policyName.isEmpty) {
      ToastService.warning(context, 'Enter policy name');
      return false;
    }
    if (draft.leaveTypeId == 0) {
      ToastService.warning(context, 'Select a leave type');
      return false;
    }

    _ref.read(addPolicyDialogUiStateProvider.notifier).setLoading(true);
    try {
      final repo = _ref.read(absPoliciesRepositoryProvider);
      final request = CreatePolicyRequestDto.fromDetail(draft, tenantId: tenantId, createdBy: _kAddPolicyCreatedBy);
      final created = await repo.createPolicy(request);
      if (created != null) {
        _ref.read(policyConfigurationTabAbsPoliciesNotifierProvider.notifier).addPolicy(created);
        _ref.read(policyConfigurationTabSelectedPolicyGuidProvider.notifier).setSelectedPolicyGuid(created.policyGuid);
        if (context.mounted) {
          ToastService.success(context, 'Policy created successfully');
        }
        _ref.read(addPolicyDialogUiStateProvider.notifier).reset();
        return true;
      }
      if (context.mounted) {
        ToastService.error(context, 'Failed to create policy');
      }
      return false;
    } on AppException catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.message.isNotEmpty ? e.message : 'Failed to create policy');
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, 'Failed to create policy');
      }
      return false;
    } finally {
      _ref.read(addPolicyDialogUiStateProvider.notifier).setLoading(false);
    }
  }
}

final addPolicyCreateProvider = Provider<AddPolicyCreateNotifier>((ref) {
  return AddPolicyCreateNotifier(ref);
});
