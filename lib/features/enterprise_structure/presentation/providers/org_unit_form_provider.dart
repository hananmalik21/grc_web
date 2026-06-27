import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_unit_form_data.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/active_structure_stats_providers.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/org_units_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/org_units_tree_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrgUnitFormState {
  final bool isLoading;
  final String? error;
  final bool success;

  final String selectedStatus;
  final String? parentId;
  final String? parentName;
  final Employee? selectedManagerEmployee;

  const OrgUnitFormState({
    this.isLoading = false,
    this.error,
    this.success = false,
    this.selectedStatus = 'Active',
    this.parentId,
    this.parentName,
    this.selectedManagerEmployee,
  });

  OrgUnitFormState copyWith({
    bool? isLoading,
    String? error,
    bool? success,
    String? selectedStatus,
    String? parentId,
    String? parentName,
    Employee? selectedManagerEmployee,
    bool clearParent = false,
    bool clearManager = false,
  }) {
    return OrgUnitFormState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success ?? this.success,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      parentId: clearParent ? null : (parentId ?? this.parentId),
      parentName: clearParent ? null : (parentName ?? this.parentName),
      selectedManagerEmployee: clearManager ? null : (selectedManagerEmployee ?? this.selectedManagerEmployee),
    );
  }
}

class OrgUnitFormNotifier extends StateNotifier<OrgUnitFormState> {
  final Ref ref;

  final Map<String, TextEditingController> _controllers = {
    'orgUnitCode': TextEditingController(),
    'nameEn': TextEditingController(),
    'nameAr': TextEditingController(),
    'city': TextEditingController(),
    'address': TextEditingController(),
    'managerName': TextEditingController(),
    'managerEmail': TextEditingController(),
    'managerPhone': TextEditingController(),
    'location': TextEditingController(),
    'description': TextEditingController(),
  };

  OrgUnitFormNotifier(this.ref) : super(const OrgUnitFormState()) {
    ref.onDispose(() {
      for (final controller in _controllers.values) {
        controller.dispose();
      }
    });
  }

  TextEditingController getController(String name) => _controllers[name]!;

  void initialize(OrgStructureLevel? initialValue) {
    if (initialValue != null) {
      _controllers['orgUnitCode']!.text = initialValue.orgUnitCode;
      _controllers['nameEn']!.text = initialValue.orgUnitNameEn;
      _controllers['nameAr']!.text = initialValue.orgUnitNameAr;
      _controllers['city']!.text = initialValue.city;
      _controllers['address']!.text = initialValue.address;
      _controllers['managerName']!.text = initialValue.managerName;
      _controllers['managerEmail']!.text = initialValue.managerEmail;
      _controllers['managerPhone']!.text = initialValue.managerPhone;
      _controllers['location']!.text = initialValue.location;
      _controllers['description']!.text = initialValue.description;

      state = state.copyWith(
        selectedStatus: initialValue.isActive ? 'Active' : 'Inactive',
        parentId: initialValue.parentOrgUnitId,
        parentName:
            initialValue.parentUnit?.name ?? (initialValue.parentName.isNotEmpty ? initialValue.parentName : null),
        selectedManagerEmployee: null,
      );
    } else {
      for (final controller in _controllers.values) {
        controller.clear();
      }
      state = const OrgUnitFormState();
    }
  }

  void updateStatus(String status) {
    state = state.copyWith(selectedStatus: status);
  }

  void updateParent(OrgStructureLevel? parent) {
    if (parent == null) {
      state = state.copyWith(clearParent: true);
    } else {
      state = state.copyWith(parentId: parent.orgUnitId, parentName: parent.orgUnitNameEn);
    }
  }

  void updateManagerFromEmployee(Employee? employee) {
    if (employee == null) {
      _controllers['managerName']!.clear();
      _controllers['managerEmail']!.clear();
      _controllers['managerPhone']!.clear();
      state = state.copyWith(clearManager: true);
    } else {
      _controllers['managerName']!.text = employee.fullName;
      _controllers['managerEmail']!.text = employee.email;
      _controllers['managerPhone']!.text = employee.phoneNumber ?? employee.mobileNumber ?? '';
      state = state.copyWith(selectedManagerEmployee: employee);
    }
  }

  Future<void> submit({required String structureId, String? orgUnitId, required String levelCode}) async {
    if (_controllers['orgUnitCode']!.text.trim().isEmpty || _controllers['nameEn']!.text.trim().isEmpty) {
      state = state.copyWith(error: 'Please fill in all required fields.');
      return;
    }

    if (levelCode.toUpperCase() != 'COMPANY' && state.parentId == null) {
      state = state.copyWith(error: 'Parent Org Unit is required.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final isEdit = orgUnitId != null;
      final formData = OrgUnitFormData(
        orgUnitCode: _controllers['orgUnitCode']!.text,
        orgUnitNameEn: _controllers['nameEn']!.text,
        orgUnitNameAr: _controllers['nameAr']!.text,
        parentOrgUnitId: levelCode.toUpperCase() == 'COMPANY' ? null : state.parentId,
        isActive: state.selectedStatus == 'Active',
        managerName: _controllers['managerName']!.text,
        managerEmail: _controllers['managerEmail']!.text,
        managerPhone: _controllers['managerPhone']!.text,
        location: _controllers['location']!.text,
        city: _controllers['city']!.text,
        address: _controllers['address']!.text,
        description: _controllers['description']!.text,
        levelCode: isEdit ? null : levelCode,
      );

      final requestData = formData.toJson(isEdit: isEdit);

      late final OrgStructureLevel result;
      if (isEdit) {
        final updateUseCase = ref.read(updateOrgUnitUseCaseProvider);
        result = await updateUseCase.call(structureId, orgUnitId, requestData);
      } else {
        final createUseCase = ref.read(createOrgUnitUseCaseProvider);
        result = await createUseCase.call(structureId, requestData);
      }

      state = state.copyWith(isLoading: false, success: true);

      if (isEdit) {
        ref.read(orgUnitsProvider(levelCode).notifier).updateUnitLocal(result);
      } else {
        ref.read(orgUnitsProvider(levelCode).notifier).refresh();
      }
      ref.read(activeStructureStatsNotifierProvider.notifier).refresh();
      ref.read(orgUnitsTreeProvider.notifier).refresh();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final orgUnitFormProvider = StateNotifierProvider.autoDispose<OrgUnitFormNotifier, OrgUnitFormState>((ref) {
  return OrgUnitFormNotifier(ref);
});
