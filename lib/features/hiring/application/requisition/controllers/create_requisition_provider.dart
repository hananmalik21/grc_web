import 'package:grc/core/localization/locale_provider.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/core/services/pagination_service.dart';
import 'package:grc/features/hiring/data/mappers/create_requisition_edit_mapper.dart';
import 'package:grc/features/hiring/data/mappers/create_requisition_request_mapper.dart';
import 'package:grc/features/hiring/application/requisition/providers/requisitions_api_providers.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/employee_management/presentation/providers/empl_lookups_provider.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_type.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/application/requisition/providers/rec_lookups_provider.dart';
import 'package:grc/features/hiring/application/requisition/providers/requisitions_tab_enterprise_provider.dart';
import 'package:grc/features/leave_management/domain/models/document.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/domain/usecases/create_job_family_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/create_position_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/delete_position_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_positions_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/update_position_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/create_job_level_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/delete_job_level_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_job_families_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/create_grade_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/delete_grade_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_grades_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/get_job_levels_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/update_grade_usecase.dart';
import 'package:grc/features/workforce_structure/domain/usecases/update_job_level_usecase.dart';
import 'package:grc/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_notifier.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/features/hiring/application/requisition/states/create_requisition_state.dart';

enum CreateRequisitionOrgSelectionScope { basicInfo, justification }

class CreateRequisitionNotifier extends AutoDisposeNotifier<CreateRequisitionState> {
  @override
  CreateRequisitionState build() => const CreateRequisitionState();

  void setStep(int step) {
    state = state.copyWith(currentStep: step);
  }

  void nextStep() {
    if (state.currentStep < 5) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  String? tryGoNext() {
    final error = validateStep(state.currentStep);
    if (error != null) return error;

    nextStep();
    return null;
  }

  String? validateStep(int step) {
    switch (step) {
      case 0:
        if (state.selectedPosition == null) return 'Job Title is required';
        if (state.selectedDepartmentOrgUnit == null) {
          return 'Organization unit is required';
        }
        if (state.selectedJobFamily == null) return 'Job Family is required';
        if (state.selectedJobLevel == null) return 'Job Level is required';
        if (state.selectedGrade == null) return 'Grade/Level is required';
        if (state.selectedContractType == null) return 'Contract Type is required';
        if (state.numberOfOpenings < 1) return 'Number of Openings must be at least 1';
        if (state.priority == null) return 'Priority is required';
        if (_isBlank(state.primaryLocation)) return 'Primary Location is required';
        if (_isBlank(state.workMode)) return 'Work Mode is required';
        if (state.targetStartDate == null) return 'Target Start Date is required';
        if (state.expectedEndDate != null && state.targetStartDate != null) {
          final end = _dateOnly(state.expectedEndDate!);
          final start = _dateOnly(state.targetStartDate!);
          if (end.isBefore(start)) {
            return 'Expected End Date must be on or after Target Start Date';
          }
        }
        return null;
      case 1:
        if (state.positionType == null) return 'Position Type is required';
        if (_isBlank(state.businessJustification)) return 'Business Justification is required';
        if (_isBlank(state.impactIfNotFilled)) return 'Impact if Not Filled is required';
        if (state.reportsToPosition == null) return 'Reports To is required';
        if (state.selectedJustificationOrgUnit == null) {
          return 'Organization unit is required';
        }
        if (_isBlank(state.costCenter)) return 'Cost Center is required';
        return null;
      case 2:
        if (_isBlank(state.positionSummary)) return 'Position Summary is required';
        if (_isBlank(state.keyResponsibilities)) return 'Key Responsibilities are required';
        if (_isBlank(state.minimumQualifications)) return 'Minimum Qualifications are required';
        return null;
      case 3:
        if (state.requiredSkills.isEmpty) return 'At least one required skill is needed';
        if (state.minimumEducationLevel == null) return 'Minimum Education Level is required';
        if (state.yearsOfExperience == null) return 'Years of Experience Required is required';
        return null;
      case 4:
        if (state.hiringManagerEmployee == null) return 'Hiring Manager is required';
        if (state.recruiterEmployee == null) return 'Recruiter is required';
        return null;
      case 5:
        if (state.currency == null) return 'Currency is required';
        if (state.compensationType == null) return 'Compensation Type is required';
        if (_isBlank(state.salaryRangeMin)) return 'Minimum Salary is required';
        if (_isBlank(state.salaryRangeMax)) return 'Maximum Salary is required';
        if (_isBlank(state.budgetCode)) return 'Budget Code is required';

        final min = double.tryParse(state.salaryRangeMin!) ?? 0;
        final max = double.tryParse(state.salaryRangeMax!) ?? 0;
        if (max < min) return 'Maximum Salary cannot be less than Minimum Salary';
        return null;
      default:
        return null;
    }
  }

  bool _isBlank(String? value) => value == null || value.trim().isEmpty;

  String _reportsToPositionLabel(Position position) {
    final title = position.titleEnglish.trim();
    if (title.isNotEmpty) return title;
    return position.code.isNotEmpty ? position.code : 'Position #${position.id}';
  }

  DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

  void setSelectedPosition(Position position) {
    state = state.copyWith(selectedPosition: position, jobTitle: position.titleEnglish);
  }

  void setSelectedJobFamily(JobFamily jobFamily) {
    state = state.copyWith(selectedJobFamily: jobFamily);
  }

  void setSelectedJobLevel(JobLevel jobLevel) {
    state = state.copyWith(selectedJobLevel: jobLevel);
  }

  void setSelectedGrade(Grade? grade) {
    state = state.copyWith(selectedGrade: grade, clearSelectedGrade: grade == null);
  }

  void setOrgLevelSelections(CreateRequisitionOrgSelectionScope scope, Map<String, OrgUnit> selections) {
    switch (scope) {
      case CreateRequisitionOrgSelectionScope.basicInfo:
        state = state.copyWith(
          basicInfoOrgLevelSelections: selections,
          clearBasicInfoOrgLevelSelections: selections.isEmpty,
        );
      case CreateRequisitionOrgSelectionScope.justification:
        state = state.copyWith(
          justificationOrgLevelSelections: selections,
          clearJustificationOrgLevelSelections: selections.isEmpty,
        );
    }
  }

  void setSelectedDepartmentOrgUnit(OrgUnit? unit) {
    if (unit == null) {
      state = state.copyWith(
        clearSelectedDepartmentOrgUnit: true,
        clearDepartment: true,
        clearBasicInfoOrgLevelSelections: true,
      );
      return;
    }
    final nameEn = unit.orgUnitNameEn.trim();
    final nameAr = unit.orgUnitNameAr.trim();
    final label = nameEn.isNotEmpty ? nameEn : (nameAr.isNotEmpty ? nameAr : unit.orgUnitCode);
    state = state.copyWith(selectedDepartmentOrgUnit: unit, department: label);
  }

  void setSelectedJustificationOrgUnit(OrgUnit? unit) {
    if (unit == null) {
      state = state.copyWith(clearSelectedJustificationOrgUnit: true, clearJustificationOrgLevelSelections: true);
      return;
    }
    state = state.copyWith(selectedJustificationOrgUnit: unit);
  }

  void setSelectedContractType(EmplLookupValue contractType) {
    state = state.copyWith(selectedContractType: contractType);
  }

  void updateBasicInfo({
    String? department,
    int? numberOfOpenings,
    String? priority,
    String? primaryLocation,
    String? workMode,
    DateTime? targetStartDate,
    DateTime? expectedEndDate,
  }) {
    final start = targetStartDate ?? state.targetStartDate;
    var end = expectedEndDate ?? state.expectedEndDate;

    if (start != null && end != null && _dateOnly(end).isBefore(_dateOnly(start))) {
      end = null;
    }

    state = state.copyWith(
      department: department ?? state.department,
      numberOfOpenings: numberOfOpenings ?? state.numberOfOpenings,
      priority: priority ?? state.priority,
      primaryLocation: primaryLocation ?? state.primaryLocation,
      workMode: workMode ?? state.workMode,
      targetStartDate: targetStartDate ?? state.targetStartDate,
      expectedEndDate: end,
    );
  }

  void updateJustification({
    String? positionType,
    String? businessJustification,
    String? impactIfNotFilled,
    Position? reportsToPosition,
    String? organizationalUnit,
    String? costCenter,
  }) {
    final nextReportsToPosition = reportsToPosition ?? state.reportsToPosition;
    final nextReportsTo = reportsToPosition != null ? _reportsToPositionLabel(reportsToPosition) : state.reportsTo;

    state = state.copyWith(
      positionType: positionType ?? state.positionType,
      businessJustification: businessJustification ?? state.businessJustification,
      impactIfNotFilled: impactIfNotFilled ?? state.impactIfNotFilled,
      reportsToPosition: nextReportsToPosition,
      reportsTo: nextReportsTo,
      organizationalUnit: organizationalUnit ?? state.organizationalUnit,
      costCenter: costCenter ?? state.costCenter,
    );
  }

  void updatePositionDetails({
    String? positionSummary,
    String? keyResponsibilities,
    String? minimumQualifications,
    String? preferredQualifications,
    String? travelRequirement,
    String? requiredCertifications,
    String? physicalRequirements,
  }) {
    state = state.copyWith(
      positionSummary: positionSummary ?? state.positionSummary,
      keyResponsibilities: keyResponsibilities ?? state.keyResponsibilities,
      minimumQualifications: minimumQualifications ?? state.minimumQualifications,
      preferredQualifications: preferredQualifications ?? state.preferredQualifications,
      travelRequirement: travelRequirement ?? state.travelRequirement,
      requiredCertifications: requiredCertifications ?? state.requiredCertifications,
      physicalRequirements: physicalRequirements ?? state.physicalRequirements,
    );
  }

  void addRequiredSkill(String skill) {
    if (skill.trim().isEmpty) return;
    if (state.requiredSkills.contains(skill.trim())) return;
    state = state.copyWith(requiredSkills: [...state.requiredSkills, skill.trim()]);
  }

  void removeRequiredSkill(String skill) {
    state = state.copyWith(requiredSkills: state.requiredSkills.where((s) => s != skill).toList());
  }

  void updateSkillsAndQuals({
    String? minimumEducationLevel,
    String? yearsOfExperience,
    String? preferredFieldOfStudy,
    String? managementExperience,
  }) {
    state = state.copyWith(
      minimumEducationLevel: minimumEducationLevel ?? state.minimumEducationLevel,
      yearsOfExperience: yearsOfExperience ?? state.yearsOfExperience,
      preferredFieldOfStudy: preferredFieldOfStudy ?? state.preferredFieldOfStudy,
      managementExperience: managementExperience ?? state.managementExperience,
    );
  }

  String _employeeDisplayLabel(Employee employee) {
    final name = employee.fullName.trim();
    if (name.isNotEmpty) return name;
    if (employee.email.isNotEmpty) return employee.email;
    return 'Employee #${employee.id}';
  }

  void setHiringManagerEmployee(Employee employee) {
    state = state.copyWith(hiringManagerEmployee: employee, hiringManager: _employeeDisplayLabel(employee));
  }

  void setRecruiterEmployee(Employee employee) {
    state = state.copyWith(recruiterEmployee: employee, recruiter: _employeeDisplayLabel(employee));
  }

  void setHrBusinessPartnerEmployee(Employee employee) {
    state = state.copyWith(hrBusinessPartnerEmployee: employee, hrBusinessPartner: _employeeDisplayLabel(employee));
  }

  void addInterviewPanelSlot() {
    state = state.copyWith(interviewPanelMembers: [...state.interviewPanelMembers, null]);
  }

  void removeInterviewPanelSlot(int index) {
    if (state.interviewPanelMembers.length <= 1) {
      state = state.copyWith(interviewPanelMembers: const <Employee?>[null]);
      return;
    }
    final next = List<Employee?>.from(state.interviewPanelMembers)..removeAt(index);
    state = state.copyWith(interviewPanelMembers: next);
  }

  void setInterviewPanelMember(int index, Employee employee) {
    final next = List<Employee?>.from(state.interviewPanelMembers);
    if (index >= 0 && index < next.length) {
      next[index] = employee;
      state = state.copyWith(interviewPanelMembers: next);
    }
  }

  void updateBudgetAndComp({
    String? currency,
    String? compensationType,
    String? salaryRangeMin,
    String? salaryRangeMax,
    bool? bonusEligible,
    bool? equityEligible,
    String? additionalBenefits,
    String? budgetCode,
    String? approvedBudgetAmount,
  }) {
    state = state.copyWith(
      currency: currency ?? state.currency,
      compensationType: compensationType ?? state.compensationType,
      salaryRangeMin: salaryRangeMin ?? state.salaryRangeMin,
      salaryRangeMax: salaryRangeMax ?? state.salaryRangeMax,
      bonusEligible: bonusEligible ?? state.bonusEligible,
      equityEligible: equityEligible ?? state.equityEligible,
      additionalBenefits: additionalBenefits ?? state.additionalBenefits,
      budgetCode: budgetCode ?? state.budgetCode,
      approvedBudgetAmount: approvedBudgetAmount ?? state.approvedBudgetAmount,
    );
  }

  Future<String?> loadRequisitionForEdit(RequisitionTableRowData row) async {
    return _loadRequisitionFromRow(row, forDuplicate: false);
  }

  Future<String?> loadRequisitionForDuplicate(RequisitionTableRowData row) async {
    return _loadRequisitionFromRow(row, forDuplicate: true);
  }

  Future<String?> _loadRequisitionFromRow(RequisitionTableRowData row, {required bool forDuplicate}) async {
    final guid = row.id.trim();
    if (state.isEditLoadStarted) return null;
    if (state.isEditHydrated && state.editingRequisitionGuid == guid && !forDuplicate) {
      return null;
    }

    final enterpriseId = ref.read(requisitionsTabEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      return 'Select an enterprise first';
    }

    if (guid.isEmpty) {
      return 'Requisition id is required';
    }

    state = state.copyWith(isEditLoadStarted: true, isLoadingEdit: true);

    try {
      final dto = await ref.read(getRequisitionByGuidUseCaseProvider)(
        requisitionGuid: guid,
        enterpriseId: enterpriseId,
      );
      final contractTypes = await ref.read(createRequisitionContractTypeLookupValuesProvider.future);

      final result = CreateRequisitionEditMapper.fromFullDto(
        dto: dto,
        contractTypes: contractTypes,
        enterpriseId: enterpriseId,
      );

      state = result.state.copyWith(
        isLoadingEdit: false,
        isEditHydrated: true,
        editingRequisitionGuid: forDuplicate ? null : guid,
        attachments: forDuplicate ? const [] : result.state.attachments,
        basicInfoOrgPrefillPath: result.basicInfoOrgPath,
        justificationOrgPrefillPath: result.justificationOrgPath,
      );
      return null;
    } on AppException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      if (state.isLoadingEdit) {
        state = state.copyWith(isLoadingEdit: false);
      }
    }
  }

  void clearOrgPrefillPaths({CreateRequisitionOrgSelectionScope? scope}) {
    switch (scope) {
      case CreateRequisitionOrgSelectionScope.basicInfo:
        state = state.copyWith(clearBasicInfoOrgPrefillPath: true);
      case CreateRequisitionOrgSelectionScope.justification:
        state = state.copyWith(clearJustificationOrgPrefillPath: true);
      case null:
        state = state.copyWith(clearBasicInfoOrgPrefillPath: true, clearJustificationOrgPrefillPath: true);
    }
  }

  void addAttachment(Document document) {
    state = state.copyWith(attachments: [...state.attachments, document]);
  }

  void removeAttachment(Document document) {
    state = state.copyWith(attachments: state.attachments.where((d) => d.id != document.id).toList());
  }

  void reset() {
    state = const CreateRequisitionState();
  }

  String? validateDraftForSave() {
    if (state.selectedPosition == null) {
      return 'Job Title is required to save a draft';
    }
    return null;
  }

  Future<String?> saveDraftRequisition() async {
    if (state.isSavingDraft || state.isSubmitting) return null;

    final validationError = validateDraftForSave();
    if (validationError != null) return validationError;

    final enterpriseId = ref.read(requisitionsTabEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      return 'Select an enterprise first';
    }

    final editingGuid = state.editingRequisitionGuid?.trim();
    if (editingGuid != null && editingGuid.isEmpty) {
      return 'Requisition id is required';
    }

    try {
      final createdBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'admin.user';

      final request = CreateRequisitionRequestMapper.fromStateAsDraft(
        state: state,
        enterpriseId: enterpriseId,
        createdBy: createdBy,
        lastUpdatedBy: createdBy,
      );

      state = state.copyWith(isSavingDraft: true);
      if (editingGuid != null) {
        await ref.read(updateRequisitionUseCaseProvider)(
          requisitionGuid: editingGuid,
          enterpriseId: enterpriseId,
          request: request,
        );
      } else {
        await ref.read(createRequisitionUseCaseProvider)(request);
      }
      return null;
    } on AppException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      state = state.copyWith(isSavingDraft: false);
    }
  }

  Future<String?> submitRequisition() async {
    if (state.isSubmitting || state.isSavingDraft) return null;

    for (var step = 0; step <= 5; step++) {
      final error = validateStep(step);
      if (error != null) return error;
    }

    final enterpriseId = ref.read(requisitionsTabEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      return 'Select an enterprise first';
    }

    try {
      final createdBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'admin.user';

      final request = CreateRequisitionRequestMapper.fromState(
        state: state,
        enterpriseId: enterpriseId,
        createdBy: createdBy,
      );

      state = state.copyWith(isSubmitting: true);
      await ref.read(createRequisitionUseCaseProvider)(request);
      return null;
    } on AppException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    } finally {
      state = state.copyWith(isSubmitting: false);
    }
  }
}

final createRequisitionProvider = AutoDisposeNotifierProvider<CreateRequisitionNotifier, CreateRequisitionState>(
  CreateRequisitionNotifier.new,
);

final createRequisitionOrgStructureNotifierProvider = StateNotifierProvider<OrgStructureNotifier, OrgStructureState>((
  ref,
) {
  final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
  return OrgStructureNotifier(
    getActiveOrgStructureLevelsUseCase: ref.read(getActiveOrgStructureLevelsUseCaseProvider),
    tenantId: tenantId,
  );
});

final createRequisitionEnterpriseSelectionProvider =
    StateNotifierProvider.family<
      EnterpriseSelectionNotifier,
      EnterpriseSelectionState,
      ({CreateRequisitionOrgSelectionScope scope, List<OrgStructureLevel> levels, String structureId})
    >((ref, params) {
      switch (params.scope) {
        case CreateRequisitionOrgSelectionScope.basicInfo:
        case CreateRequisitionOrgSelectionScope.justification:
          break;
      }
      final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
      return EnterpriseSelectionNotifier(
        getOrgUnitsByLevelUseCase: ref.read(getOrgUnitsByLevelUseCaseProvider),
        levels: params.levels,
        structureId: params.structureId,
        tenantId: tenantId,
      );
    });

// Lookup providers for position / job family / job level / grade / contract type selection on the create flow.

final createRequisitionGetPositionsUseCaseProvider = Provider<GetPositionsUseCase>((ref) {
  return ref.watch(getPositionsUseCaseProvider);
});

final createRequisitionCreatePositionUseCaseProvider = Provider<CreatePositionUseCase>((ref) {
  return ref.watch(createPositionUseCaseProvider);
});

final createRequisitionUpdatePositionUseCaseProvider = Provider<UpdatePositionUseCase>((ref) {
  return ref.watch(updatePositionUseCaseProvider);
});

final createRequisitionDeletePositionUseCaseProvider = Provider<DeletePositionUseCase>((ref) {
  return ref.watch(deletePositionUseCaseProvider);
});

final createRequisitionPositionNotifierProvider = StateNotifierProvider<PositionNotifier, PaginationState<Position>>((
  ref,
) {
  final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
  final notifier = PositionNotifier(
    ref.watch(createRequisitionGetPositionsUseCaseProvider),
    ref.watch(createRequisitionCreatePositionUseCaseProvider),
    ref.watch(createRequisitionUpdatePositionUseCaseProvider),
    ref.watch(createRequisitionDeletePositionUseCaseProvider),
    tenantId,
  );
  Future.microtask(() => notifier.loadFirstPage());
  return notifier;
});

final createRequisitionWorkModeLookupValuesProvider = FutureProvider<List<RecLookupValue>>((ref) async {
  final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
  if (tenantId == null || tenantId <= 0) return const <RecLookupValue>[];

  final list = await ref.watch(
    recLookupValuesForTypeProvider((
      enterpriseId: tenantId,
      typeCode: RecLookupTypeCodes.workMode,
      page: 1,
      pageSize: 100,
    )).future,
  );

  final sorted = List<RecLookupValue>.of(list)..sort((a, b) => a.displaySequence.compareTo(b.displaySequence));
  return sorted;
});

final createRequisitionWorkModeSelectItemsProvider = FutureProvider<List<String>>((ref) async {
  final locale = ref.watch(localeProvider);
  final isRtl = locale.languageCode == 'ar';
  final lookups = await ref.watch(createRequisitionWorkModeLookupValuesProvider.future);
  return lookups.map((v) => v.labelForLocale(isRtl: isRtl)).toList();
});

final createRequisitionPriorityLookupValuesProvider = FutureProvider<List<RecLookupValue>>((ref) async {
  final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
  if (tenantId == null || tenantId <= 0) return const <RecLookupValue>[];

  final list = await ref.watch(
    recLookupValuesForTypeProvider((
      enterpriseId: tenantId,
      typeCode: RecLookupTypeCodes.priority,
      page: 1,
      pageSize: 100,
    )).future,
  );

  final sorted = List<RecLookupValue>.of(list)..sort((a, b) => a.displaySequence.compareTo(b.displaySequence));
  return sorted;
});

final createRequisitionPrioritySelectItemsProvider = FutureProvider<List<String>>((ref) async {
  final locale = ref.watch(localeProvider);
  final isRtl = locale.languageCode == 'ar';
  final lookups = await ref.watch(createRequisitionPriorityLookupValuesProvider.future);
  return lookups.map((v) => v.labelForLocale(isRtl: isRtl)).toList();
});

final createRequisitionPrimaryLocationLookupValuesProvider = FutureProvider<List<RecLookupValue>>((ref) async {
  final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
  if (tenantId == null || tenantId <= 0) return const <RecLookupValue>[];

  final list = await ref.watch(
    recLookupValuesForTypeProvider((
      enterpriseId: tenantId,
      typeCode: RecLookupTypeCodes.location,
      page: 1,
      pageSize: 100,
    )).future,
  );

  final sorted = List<RecLookupValue>.of(list)..sort((a, b) => a.displaySequence.compareTo(b.displaySequence));
  return sorted;
});

final createRequisitionPrimaryLocationSelectItemsProvider = FutureProvider<List<String>>((ref) async {
  final locale = ref.watch(localeProvider);
  final isRtl = locale.languageCode == 'ar';
  final lookups = await ref.watch(createRequisitionPrimaryLocationLookupValuesProvider.future);
  return lookups.map((v) => v.labelForLocale(isRtl: isRtl)).toList();
});

final createRequisitionPositionTypeLookupValuesProvider = FutureProvider<List<RecLookupValue>>((ref) async {
  final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
  if (tenantId == null || tenantId <= 0) return const <RecLookupValue>[];

  final list = await ref.watch(
    recLookupValuesForTypeProvider((
      enterpriseId: tenantId,
      typeCode: RecLookupTypeCodes.positionType,
      page: 1,
      pageSize: 100,
    )).future,
  );

  final sorted = List<RecLookupValue>.of(list)..sort((a, b) => a.displaySequence.compareTo(b.displaySequence));
  return sorted;
});

final createRequisitionPositionTypeSelectItemsProvider = FutureProvider<List<String>>((ref) async {
  final locale = ref.watch(localeProvider);
  final isRtl = locale.languageCode == 'ar';
  final lookups = await ref.watch(createRequisitionPositionTypeLookupValuesProvider.future);
  return lookups.map((v) => v.labelForLocale(isRtl: isRtl)).toList();
});

final createRequisitionTravelRequirementLookupValuesProvider = FutureProvider<List<RecLookupValue>>((ref) async {
  final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
  if (tenantId == null || tenantId <= 0) return const <RecLookupValue>[];

  final list = await ref.watch(
    recLookupValuesForTypeProvider((
      enterpriseId: tenantId,
      typeCode: RecLookupTypeCodes.travelReq,
      page: 1,
      pageSize: 100,
    )).future,
  );

  final sorted = List<RecLookupValue>.of(list)..sort((a, b) => a.displaySequence.compareTo(b.displaySequence));
  return sorted;
});

final createRequisitionTravelRequirementSelectItemsProvider = FutureProvider<List<String>>((ref) async {
  final locale = ref.watch(localeProvider);
  final isRtl = locale.languageCode == 'ar';
  final lookups = await ref.watch(createRequisitionTravelRequirementLookupValuesProvider.future);
  return lookups.map((v) => v.labelForLocale(isRtl: isRtl)).toList();
});

final createRequisitionRequiredCertificationsLookupValuesProvider = FutureProvider<List<RecLookupValue>>((ref) async {
  final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
  if (tenantId == null || tenantId <= 0) return const <RecLookupValue>[];

  final list = await ref.watch(
    recLookupValuesForTypeProvider((
      enterpriseId: tenantId,
      typeCode: RecLookupTypeCodes.reqCert,
      page: 1,
      pageSize: 100,
    )).future,
  );

  final sorted = List<RecLookupValue>.of(list)..sort((a, b) => a.displaySequence.compareTo(b.displaySequence));
  return sorted;
});

final createRequisitionRequiredCertificationsSelectItemsProvider = FutureProvider<List<String>>((ref) async {
  final locale = ref.watch(localeProvider);
  final isRtl = locale.languageCode == 'ar';
  final lookups = await ref.watch(createRequisitionRequiredCertificationsLookupValuesProvider.future);
  return lookups.map((v) => v.labelForLocale(isRtl: isRtl)).toList();
});

final createRequisitionPhysicalRequirementsLookupValuesProvider = FutureProvider<List<RecLookupValue>>((ref) async {
  final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
  if (tenantId == null || tenantId <= 0) return const <RecLookupValue>[];

  final list = await ref.watch(
    recLookupValuesForTypeProvider((
      enterpriseId: tenantId,
      typeCode: RecLookupTypeCodes.physicalReq,
      page: 1,
      pageSize: 100,
    )).future,
  );

  final sorted = List<RecLookupValue>.of(list)..sort((a, b) => a.displaySequence.compareTo(b.displaySequence));
  return sorted;
});

final createRequisitionPhysicalRequirementsSelectItemsProvider = FutureProvider<List<String>>((ref) async {
  final locale = ref.watch(localeProvider);
  final isRtl = locale.languageCode == 'ar';
  final lookups = await ref.watch(createRequisitionPhysicalRequirementsLookupValuesProvider.future);
  return lookups.map((v) => v.labelForLocale(isRtl: isRtl)).toList();
});

FutureProvider<List<RecLookupValue>> _createRequisitionRecLookupValues(String typeCode) {
  return FutureProvider<List<RecLookupValue>>((ref) async {
    final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
    if (tenantId == null || tenantId <= 0) return const <RecLookupValue>[];

    final list = await ref.watch(
      recLookupValuesForTypeProvider((enterpriseId: tenantId, typeCode: typeCode, page: 1, pageSize: 100)).future,
    );

    final sorted = List<RecLookupValue>.of(list)..sort((a, b) => a.displaySequence.compareTo(b.displaySequence));
    return sorted;
  });
}

FutureProvider<List<String>> _createRequisitionRecLookupSelectItems(
  FutureProvider<List<RecLookupValue>> lookupValuesRef,
) {
  return FutureProvider<List<String>>((ref) async {
    final locale = ref.watch(localeProvider);
    final isRtl = locale.languageCode == 'ar';
    final lookups = await ref.watch(lookupValuesRef.future);
    return lookups.map((v) => v.labelForLocale(isRtl: isRtl)).toList();
  });
}

final createRequisitionSkillsLookupValuesProvider = _createRequisitionRecLookupValues(RecLookupTypeCodes.skills);

final createRequisitionSkillsSelectItemsProvider = _createRequisitionRecLookupSelectItems(
  createRequisitionSkillsLookupValuesProvider,
);

final createRequisitionMinEduLevelLookupValuesProvider = _createRequisitionRecLookupValues(
  RecLookupTypeCodes.minEduLevel,
);

final createRequisitionMinEduLevelSelectItemsProvider = _createRequisitionRecLookupSelectItems(
  createRequisitionMinEduLevelLookupValuesProvider,
);

final createRequisitionExpYearLookupValuesProvider = _createRequisitionRecLookupValues(RecLookupTypeCodes.expYear);

final createRequisitionExpYearSelectItemsProvider = _createRequisitionRecLookupSelectItems(
  createRequisitionExpYearLookupValuesProvider,
);

final createRequisitionPrefFieldLookupValuesProvider = _createRequisitionRecLookupValues(RecLookupTypeCodes.prefField);

final createRequisitionPrefFieldSelectItemsProvider = _createRequisitionRecLookupSelectItems(
  createRequisitionPrefFieldLookupValuesProvider,
);

final createRequisitionManagExpLookupValuesProvider = _createRequisitionRecLookupValues(RecLookupTypeCodes.managExp);

final createRequisitionManagExpSelectItemsProvider = _createRequisitionRecLookupSelectItems(
  createRequisitionManagExpLookupValuesProvider,
);

final createRequisitionCurrencyLookupValuesProvider = _createRequisitionRecLookupValues(RecLookupTypeCodes.currency);

final createRequisitionCurrencySelectItemsProvider = _createRequisitionRecLookupSelectItems(
  createRequisitionCurrencyLookupValuesProvider,
);

final createRequisitionCompTypeLookupValuesProvider = _createRequisitionRecLookupValues(RecLookupTypeCodes.compType);

final createRequisitionCompTypeSelectItemsProvider = _createRequisitionRecLookupSelectItems(
  createRequisitionCompTypeLookupValuesProvider,
);

final createRequisitionContractTypeLookupValuesProvider = FutureProvider<List<EmplLookupValue>>((ref) async {
  final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
  if (tenantId == null || tenantId <= 0) return const <EmplLookupValue>[];

  return ref.watch(emplLookupValuesForTypeProvider((enterpriseId: tenantId, typeCode: 'CONTRACT_TYPE')).future);
});

final createRequisitionGetJobFamiliesUseCaseProvider = Provider<GetJobFamiliesUseCase>((ref) {
  return ref.watch(getJobFamiliesUseCaseProvider);
});

final createRequisitionCreateJobFamilyUseCaseProvider = Provider<CreateJobFamilyUseCase>((ref) {
  return ref.watch(createJobFamilyUseCaseProvider);
});

final createRequisitionGetJobLevelsUseCaseProvider = Provider<GetJobLevelsUseCase>((ref) {
  return ref.watch(getJobLevelsUseCaseProvider);
});

final createRequisitionCreateJobLevelUseCaseProvider = Provider<CreateJobLevelUseCase>((ref) {
  return ref.watch(createJobLevelUseCaseProvider);
});

final createRequisitionUpdateJobLevelUseCaseProvider = Provider<UpdateJobLevelUseCase>((ref) {
  return ref.watch(updateJobLevelUseCaseProvider);
});

final createRequisitionDeleteJobLevelUseCaseProvider = Provider<DeleteJobLevelUseCase>((ref) {
  return ref.watch(deleteJobLevelUseCaseProvider);
});

final createRequisitionGetGradesUseCaseProvider = Provider<GetGradesUseCase>((ref) {
  return ref.watch(getGradesUseCaseProvider);
});

final createRequisitionCreateGradeUseCaseProvider = Provider<CreateGradeUseCase>((ref) {
  return ref.watch(createGradeUseCaseProvider);
});

final createRequisitionDeleteGradeUseCaseProvider = Provider<DeleteGradeUseCase>((ref) {
  return ref.watch(deleteGradeUseCaseProvider);
});

final createRequisitionUpdateGradeUseCaseProvider = Provider<UpdateGradeUseCase>((ref) {
  return ref.watch(updateGradeUseCaseProvider);
});

final createRequisitionJobFamilyNotifierProvider = StateNotifierProvider<JobFamilyNotifier, PaginationState<JobFamily>>(
  (ref) {
    final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
    final notifier = JobFamilyNotifier(
      ref.watch(createRequisitionGetJobFamiliesUseCaseProvider),
      ref.watch(createRequisitionCreateJobFamilyUseCaseProvider),
      tenantId,
    );
    Future.microtask(() => notifier.loadFirstPage());
    return notifier;
  },
);

final createRequisitionJobLevelNotifierProvider = StateNotifierProvider<JobLevelNotifier, PaginationState<JobLevel>>((
  ref,
) {
  final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
  final notifier = JobLevelNotifier(
    ref.watch(createRequisitionGetJobLevelsUseCaseProvider),
    ref.watch(createRequisitionCreateJobLevelUseCaseProvider),
    ref.watch(createRequisitionUpdateJobLevelUseCaseProvider),
    ref.watch(createRequisitionDeleteJobLevelUseCaseProvider),
    tenantId,
  );
  Future.microtask(() => notifier.loadFirstPage());
  return notifier;
});

final createRequisitionGradeNotifierProvider = StateNotifierProvider<GradeNotifier, GradeState>((ref) {
  final tenantId = ref.watch(requisitionsTabEnterpriseIdProvider);
  final notifier = GradeNotifier(
    ref.watch(createRequisitionGetGradesUseCaseProvider),
    ref.watch(createRequisitionCreateGradeUseCaseProvider),
    ref.watch(createRequisitionDeleteGradeUseCaseProvider),
    ref.watch(createRequisitionUpdateGradeUseCaseProvider),
    tenantId,
  );
  Future.microtask(() => notifier.loadFirstPage());
  return notifier;
});
