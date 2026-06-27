import 'package:grc/features/security_manager/data/config/roles_management/data_role_form_config.dart';
import 'package:grc/features/security_manager/domain/models/data_role.dart';
import 'package:grc/features/security_manager/domain/models/org_selection_node.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';

class CreateDataRoleCriterionRule {
  const CreateDataRoleCriterionRule({this.field = '', this.operatorValue = '', this.value = ''});

  final String field;
  final String operatorValue;
  final String value;

  CreateDataRoleCriterionRule copyWith({String? field, String? operatorValue, String? value}) {
    return CreateDataRoleCriterionRule(
      field: field ?? this.field,
      operatorValue: operatorValue ?? this.operatorValue,
      value: value ?? this.value,
    );
  }
}

class CreateDataRoleFormState {
  const CreateDataRoleFormState({
    this.currentStep = 0,
    this.totalSteps = 3,
    this.roleName = '',
    this.roleCode = '',
    this.description = '',
    this.selectedDataType,
    this.selectedStatus = DataRoleFormConfig.defaultStatus,
    this.scopeSearchQuery = '',
    this.selectedScopeItems = const <String>{},
    this.selectedPositions = const <Position>[],
    this.selectedJobFamilies = const <JobFamily>[],
    this.selectedGrades = const <Grade>[],
    this.selectedJobLevels = const <JobLevel>[],
    this.orgSelections = const <OrgSelectionNode>[],
    this.crossDepartmentAccess = DataRoleFormConfig.defaultCrossDepartmentAccess,
    this.accessLogic = DataRoleFormConfig.defaultAccessLogic,
    this.criteriaLogic = DataRoleFormConfig.defaultCriteriaLogic,
    this.criteriaRules = const [CreateDataRoleCriterionRule()],
  });

  final int currentStep;
  final int totalSteps;
  final String roleName;
  final String roleCode;
  final String description;
  final String? selectedDataType;
  final DataRoleStatus selectedStatus;
  final String scopeSearchQuery;
  final Set<String> selectedScopeItems;
  final List<Position> selectedPositions;
  final List<JobFamily> selectedJobFamilies;
  final List<Grade> selectedGrades;
  final List<JobLevel> selectedJobLevels;
  final List<OrgSelectionNode> orgSelections;
  final String crossDepartmentAccess;
  final String accessLogic;
  final String criteriaLogic;
  final List<CreateDataRoleCriterionRule> criteriaRules;

  bool get isLastStep => currentStep == totalSteps - 1;

  Position? get selectedPosition => selectedPositions.firstOrNull;
  JobFamily? get selectedJobFamily => selectedJobFamilies.firstOrNull;
  Grade? get selectedGrade => selectedGrades.firstOrNull;
  JobLevel? get selectedJobLevel => selectedJobLevels.firstOrNull;

  /// Returns [allOptions] filtered by [scopeSearchQuery].
  List<String> filteredScopeOptions(List<String> allOptions) {
    final query = scopeSearchQuery.trim().toLowerCase();
    if (query.isEmpty) return allOptions;
    return allOptions.where((item) => item.toLowerCase().contains(query)).toList();
  }

  CreateDataRoleFormState copyWith({
    int? currentStep,
    int? totalSteps,
    String? roleName,
    String? roleCode,
    String? description,
    String? selectedDataType,
    DataRoleStatus? selectedStatus,
    String? scopeSearchQuery,
    Set<String>? selectedScopeItems,
    List<Position>? selectedPositions,
    List<JobFamily>? selectedJobFamilies,
    List<Grade>? selectedGrades,
    List<JobLevel>? selectedJobLevels,
    List<OrgSelectionNode>? orgSelections,
    String? crossDepartmentAccess,
    String? accessLogic,
    String? criteriaLogic,
    List<CreateDataRoleCriterionRule>? criteriaRules,
  }) {
    return CreateDataRoleFormState(
      currentStep: currentStep ?? this.currentStep,
      totalSteps: totalSteps ?? this.totalSteps,
      roleName: roleName ?? this.roleName,
      roleCode: roleCode ?? this.roleCode,
      description: description ?? this.description,
      selectedDataType: selectedDataType ?? this.selectedDataType,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      scopeSearchQuery: scopeSearchQuery ?? this.scopeSearchQuery,
      selectedScopeItems: selectedScopeItems ?? this.selectedScopeItems,
      selectedPositions: selectedPositions ?? this.selectedPositions,
      selectedJobFamilies: selectedJobFamilies ?? this.selectedJobFamilies,
      selectedGrades: selectedGrades ?? this.selectedGrades,
      selectedJobLevels: selectedJobLevels ?? this.selectedJobLevels,
      orgSelections: orgSelections ?? this.orgSelections,
      crossDepartmentAccess: crossDepartmentAccess ?? this.crossDepartmentAccess,
      accessLogic: accessLogic ?? this.accessLogic,
      criteriaLogic: criteriaLogic ?? this.criteriaLogic,
      criteriaRules: criteriaRules ?? this.criteriaRules,
    );
  }
}
