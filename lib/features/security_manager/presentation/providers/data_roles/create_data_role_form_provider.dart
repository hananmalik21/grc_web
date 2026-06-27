import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/domain/models/data_role.dart';
import 'package:grc/features/security_manager/domain/models/org_selection_node.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/create_data_role_form_state.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/security_manager_org_structure_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit_hierarchy_item.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'create_data_role_form_state.dart';

class CreateDataRoleFormNotifier extends StateNotifier<CreateDataRoleFormState> {
  CreateDataRoleFormNotifier(this._ref) : super(const CreateDataRoleFormState());

  final Ref _ref;

  void updateCurrentStep(int step) {
    state = state.copyWith(currentStep: step.clamp(0, state.totalSteps - 1).toInt());
  }

  void initializeFromRole(DataRoleItem role) {
    state = state.copyWith(
      currentStep: 0,
      roleName: role.name,
      roleCode: role.code,
      description: role.description,
      selectedDataType: role.dataType.isEmpty ? null : role.dataType,
      selectedStatus: role.isActive ? DataRoleStatus.active : DataRoleStatus.inactive,
      scopeSearchQuery: '',
      selectedScopeItems: const <String>{},
      selectedPositions: [
        for (var i = 0; i < role.positionIds.length; i++)
          if (i < role.positions.length)
            _positionFromRole(positionId: role.positionIds[i], positionName: role.positions[i]),
      ].whereType<Position>().toList(),
      selectedJobFamilies: [
        for (var i = 0; i < role.jobFamilyIds.length; i++)
          if (i < role.jobFamilies.length)
            _jobFamilyFromRole(jobFamilyId: role.jobFamilyIds[i], jobFamilyName: role.jobFamilies[i]),
      ].whereType<JobFamily>().toList(),
      selectedGrades: [
        for (var i = 0; i < role.gradeIds.length; i++)
          if (i < role.grades.length) _gradeFromRole(gradeId: role.gradeIds[i], gradeName: role.grades[i]),
      ].whereType<Grade>().toList(),
      selectedJobLevels: [
        for (var i = 0; i < role.jobLevelIds.length; i++)
          if (i < role.jobLevels.length)
            _jobLevelFromRole(jobLevelId: role.jobLevelIds[i], jobLevelName: role.jobLevels[i]),
      ].whereType<JobLevel>().toList(),
      orgSelections: const <OrgSelectionNode>[],
    );
  }

  Future<void> initializeForEditingRole(DataRoleItem role) async {
    initializeFromRole(role);
    if (role.orgUnitIds.isEmpty) return;
    await _preloadOrgSelections(role.orgUnitIds);
  }

  Position? _positionFromRole({required String? positionId, required String? positionName}) {
    if (positionId == null || positionName == null) return null;
    return Position(
      id: positionId,
      code: '',
      titleEnglish: positionName,
      titleArabic: positionName,
      department: '',
      jobFamily: '',
      level: '',
      grade: '',
      step: '',
      division: '',
      costCenter: '',
      location: '',
      budgetedMin: '',
      budgetedMax: '',
      actualAverage: '',
      headcount: 0,
      filled: 0,
      vacant: 0,
      isActive: true,
    );
  }

  JobFamily? _jobFamilyFromRole({required int? jobFamilyId, required String? jobFamilyName}) {
    if (jobFamilyId == null || jobFamilyName == null) return null;
    return JobFamily(
      id: jobFamilyId,
      code: '',
      nameEnglish: jobFamilyName,
      nameArabic: jobFamilyName,
      description: '',
      totalPositions: 0,
      filledPositions: 0,
      fillRate: 0,
      isActive: true,
    );
  }

  Grade? _gradeFromRole({required int? gradeId, required String? gradeName}) {
    if (gradeId == null || gradeName == null) return null;
    final now = DateTime.now();
    return Grade(
      id: gradeId,
      gradeNumber: gradeName,
      gradeNumberMeaningEn: gradeName,
      gradeNumberMeaningAr: gradeName,
      gradeCategory: '',
      gradeCategoryMeaningEn: '',
      gradeCategoryMeaningAr: '',
      currencyCode: '',
      step1Salary: 0,
      step2Salary: 0,
      step3Salary: 0,
      step4Salary: 0,
      step5Salary: 0,
      description: '',
      status: 'ACTIVE',
      createdBy: '',
      createdDate: now,
      lastUpdatedBy: '',
      lastUpdatedDate: now,
      lastUpdateLogin: '',
    );
  }

  JobLevel? _jobLevelFromRole({required int? jobLevelId, required String? jobLevelName}) {
    if (jobLevelId == null || jobLevelName == null) return null;
    return JobLevel(
      id: jobLevelId,
      nameEn: jobLevelName,
      code: '',
      description: '',
      minGradeId: 0,
      maxGradeId: 0,
      status: 'ACTIVE',
    );
  }

  void nextStep() {
    updateCurrentStep(state.currentStep + 1);
  }

  void previousStep() {
    updateCurrentStep(state.currentStep - 1);
  }

  void updateRoleName(String value) {
    state = state.copyWith(roleName: value);
  }

  void updateRoleCode(String value) {
    state = state.copyWith(roleCode: value);
  }

  void updateDescription(String value) {
    state = state.copyWith(description: value);
  }

  void updateDataType(String? value) {
    state = state.copyWith(selectedDataType: value, selectedScopeItems: const <String>{}, scopeSearchQuery: '');
  }

  void updateStatus(DataRoleStatus? value) {
    if (value == null) return;
    state = state.copyWith(selectedStatus: value);
  }

  void updateScopeSearchQuery(String value) {
    state = state.copyWith(scopeSearchQuery: value);
  }

  void toggleScopeItem(String item) {
    final updatedItems = Set<String>.from(state.selectedScopeItems);
    if (updatedItems.contains(item)) {
      updatedItems.remove(item);
    } else {
      updatedItems.add(item);
    }
    state = state.copyWith(selectedScopeItems: updatedItems);
  }

  void updatePositions(List<Position> values) {
    state = state.copyWith(selectedPositions: values);
  }

  void updateJobFamilies(List<JobFamily> values) {
    state = state.copyWith(selectedJobFamilies: values);
  }

  void updateGrades(List<Grade> values) {
    state = state.copyWith(selectedGrades: values);
  }

  void updateJobLevels(List<JobLevel> values) {
    state = state.copyWith(selectedJobLevels: values);
  }

  void setOrgSelections(List<OrgSelectionNode> selections) {
    state = state.copyWith(orgSelections: selections);
  }

  Future<void> _preloadOrgSelections(List<String> orgUnitIds) async {
    final enterpriseId = _ref.read(securityManagerEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) return;

    final repository = _ref.read(orgUnitRepositoryProvider);
    final results = await Future.wait(
      orgUnitIds.map(
        (id) => repository
            .getOrgUnitHierarchy(enterpriseId: enterpriseId, orgUnitId: id)
            .catchError((_) => <OrgUnitHierarchyItem>[]),
      ),
    );

    final levelCodeToName = <String, String>{
      for (final level in _ref.read(securityManagerOrgStructureNotifierProvider).orgStructure?.activeLevels ?? [])
        level.levelCode: level.levelName,
    };

    setOrgSelections(_buildOrgSelectionTree(results, levelCodeToName));
  }

  List<OrgSelectionNode> _buildOrgSelectionTree(
    List<List<OrgUnitHierarchyItem>> hierarchies,
    Map<String, String> levelCodeToName,
  ) {
    final rootNodes = <OrgSelectionNode>[];
    for (final path in hierarchies) {
      if (path.isEmpty) continue;
      _mergePath(rootNodes, path, 0, levelCodeToName);
    }
    return rootNodes;
  }

  void _mergePath(
    List<OrgSelectionNode> nodes,
    List<OrgUnitHierarchyItem> path,
    int depth,
    Map<String, String> levelCodeToName,
  ) {
    if (depth >= path.length) return;
    final item = path[depth];
    final existingIndex = nodes.indexWhere((n) => n.unitId == item.orgUnitId);

    if (existingIndex >= 0) {
      if (depth < path.length - 1) {
        final existing = nodes[existingIndex];
        final children = List<OrgSelectionNode>.from(existing.children);
        _mergePath(children, path, depth + 1, levelCodeToName);
        nodes[existingIndex] = existing.copyWith(children: children);
      }
      return;
    }

    final levelName = levelCodeToName[item.levelCode] ?? item.levelCode;
    var node = OrgSelectionNode(
      unitId: item.orgUnitId,
      unitName: item.orgUnitNameEn,
      levelCode: item.levelCode,
      levelName: levelName,
    );
    if (depth < path.length - 1) {
      final children = <OrgSelectionNode>[];
      _mergePath(children, path, depth + 1, levelCodeToName);
      node = node.copyWith(children: children);
    }
    nodes.add(node);
  }

  /// Updates selections for a given parent (null = root/company level).
  ///
  /// Preserves existing children of nodes that remain selected.
  /// Clears children of nodes that are deselected.
  void updateOrgSelections({required String? parentUnitId, required List<OrgSelectionNode> newSelections}) {
    if (parentUnitId == null) {
      final existingById = {for (final n in state.orgSelections) n.unitId: n};
      final updated = newSelections.map((n) => existingById[n.unitId] ?? n).toList();
      state = state.copyWith(orgSelections: updated);
    } else {
      state = state.copyWith(orgSelections: _updateChildrenInTree(state.orgSelections, parentUnitId, newSelections));
    }
  }

  List<OrgSelectionNode> _updateChildrenInTree(
    List<OrgSelectionNode> nodes,
    String parentUnitId,
    List<OrgSelectionNode> newChildren,
  ) {
    return nodes.map((node) {
      if (node.unitId == parentUnitId) {
        final existingById = {for (final c in node.children) c.unitId: c};
        final updated = newChildren.map((c) => existingById[c.unitId] ?? c).toList();
        return node.copyWith(children: updated);
      }
      return node.copyWith(children: _updateChildrenInTree(node.children, parentUnitId, newChildren));
    }).toList();
  }

  void updateCrossDepartmentAccess(String? value) {
    if (value == null) return;
    state = state.copyWith(crossDepartmentAccess: value);
  }

  void updateAccessLogic(String? value) {
    if (value == null) return;
    state = state.copyWith(accessLogic: value);
  }

  void updateCriteriaLogic(String value) {
    state = state.copyWith(criteriaLogic: value);
  }

  void addCriterion() {
    state = state.copyWith(criteriaRules: [...state.criteriaRules, const CreateDataRoleCriterionRule()]);
  }

  void removeCriterion(int index) {
    if (state.criteriaRules.length == 1) return;
    final updatedRules = [...state.criteriaRules]..removeAt(index);
    state = state.copyWith(criteriaRules: updatedRules);
  }

  void updateCriterionField(int index, CreateDataRoleCriterionField field, String? value) {
    final updatedRules = [...state.criteriaRules];
    final rule = updatedRules[index];

    updatedRules[index] = switch (field) {
      CreateDataRoleCriterionField.field => rule.copyWith(field: value ?? ''),
      CreateDataRoleCriterionField.operator => rule.copyWith(operatorValue: value ?? ''),
      CreateDataRoleCriterionField.value => rule.copyWith(value: value ?? ''),
    };

    state = state.copyWith(criteriaRules: updatedRules);
  }

  String? validateAndAdvance({required List<String> availableDataTypes, bool widgetFormValid = true}) {
    if (!widgetFormValid) return null;

    final error = validateStep(step: state.currentStep, availableDataTypes: availableDataTypes);
    if (error != null) return error;

    if (!state.isLastStep) {
      nextStep();
    }
    return null;
  }

  String? validateStep({required int step, required List<String> availableDataTypes}) {
    switch (step) {
      case 0:
        if (state.roleName.trim().isEmpty) {
          return 'Role name is required';
        }
        if (state.roleCode.trim().isEmpty) {
          return 'Role code is required';
        }
        if (state.selectedDataType == null || !availableDataTypes.contains(state.selectedDataType)) {
          return 'Data type is required';
        }
        return null;
      case 1:
        return null;
      case 2:
        return _validateEnterpriseStructureStep();
      default:
        return null;
    }
  }

  String? _validateEnterpriseStructureStep() {
    if (state.orgSelections.isEmpty) {
      return 'Please select at least one organizational unit';
    }
    return null;
  }

  Future<CreateDataRoleSubmissionResult> submit({
    required List<String> availableDataTypes,
    String? editingRoleId,
  }) async {
    final wasLastStep = state.isLastStep;
    final validationError = validateAndAdvance(availableDataTypes: availableDataTypes);
    if (validationError != null) {
      return CreateDataRoleSubmissionResult.validationError(validationError);
    }

    if (!wasLastStep) {
      return const CreateDataRoleSubmissionResult.stepAdvanced();
    }

    try {
      final dataRolesNotifier = _ref.read(dataRolesProvider.notifier);
      if (editingRoleId == null) {
        await dataRolesNotifier.createDataRole(state);
        return const CreateDataRoleSubmissionResult.success(
          title: 'Role Created',
          message: 'Data role created successfully',
        );
      }

      await dataRolesNotifier.updateDataRole(dataRoleGuid: editingRoleId, formState: state);
      return const CreateDataRoleSubmissionResult.success(
        title: 'Updated Role',
        message: 'Data role updated successfully',
      );
    } on AppException catch (e) {
      return CreateDataRoleSubmissionResult.validationError(e.message);
    } catch (_) {
      return CreateDataRoleSubmissionResult.validationError(
        editingRoleId == null
            ? 'Failed to create data role. Please try again.'
            : 'Failed to update data role. Please try again.',
      );
    }
  }
}

enum CreateDataRoleCriterionField { field, operator, value }

class CreateDataRoleSubmissionResult {
  const CreateDataRoleSubmissionResult._({
    required this.didAdvanceStep,
    this.errorMessage,
    this.successTitle,
    this.successMessage,
  });

  const CreateDataRoleSubmissionResult.stepAdvanced() : this._(didAdvanceStep: true);

  const CreateDataRoleSubmissionResult.success({required String title, required String message})
    : this._(didAdvanceStep: false, successTitle: title, successMessage: message);

  const CreateDataRoleSubmissionResult.validationError(String message)
    : this._(didAdvanceStep: false, errorMessage: message);

  final bool didAdvanceStep;
  final String? errorMessage;
  final String? successTitle;
  final String? successMessage;

  bool get hasError => errorMessage != null;
  bool get shouldShowSuccess => successMessage != null;
}

final createDataRoleFormProvider =
    StateNotifierProvider.autoDispose<CreateDataRoleFormNotifier, CreateDataRoleFormState>(
      (ref) => CreateDataRoleFormNotifier(ref),
    );
