import 'package:grc/features/security_manager/domain/models/data_role.dart';
import 'package:grc/gen/assets.gen.dart';

class DataRoleFormConfig {
  static const String dialogTitle = 'Create New Data Role';
  static const double dialogMaxWidth = 980;
  static const double dialogMaxHeightFactor = 0.82;
  static const String createButtonLabel = 'Create Data Role';
  static const String continueButtonLabel = 'Continue';
  static const String backButtonLabel = 'Back';
  static const String cancelButtonLabel = 'Cancel';
  static const String successTitle = 'Created Role';
  static const String successMessage = 'Data role created successfully';
  static const String allDataTypesOption = 'All Data Types';
  static const DataRoleStatus defaultStatus = DataRoleStatus.active;
  static const String defaultHierarchyLevel = '1';
  static const String defaultIncludeSubordinates = 'No - Direct reports only';
  static const String defaultCrossDepartmentAccess = 'No - Same department only';
  static const String defaultAccessLogic = 'Include - Grant access';
  static const String defaultCriteriaLogic = 'AND';
  static const String noDataTypeTitle = 'No Data Type Selected';
  static const String noDataTypeBody =
      'Please select a Data Type in the Basic Information tab first before configuring data scope';
  static const String noScopeTitle = 'No scope items available for this data type.';
  static const String scopeSearchHint = 'Search available scope items...';
  static const String roleNameLabel = 'Role Name';
  static const String roleNameHint = 'Enter data role name';
  static const String roleCodeLabel = 'Role Code';
  static const String roleCodeHint = 'DATA_HR_ONLY';
  static const String descriptionLabel = 'Description';
  static const String descriptionHint = 'Describe the purpose of this data role';
  static const String dataTypeLabel = 'Data Type';
  static const String statusLabel = 'Status';
  static const String dataScopeTitle = 'Data Scope Selection';
  static const String dataScopeDescription = 'Select the specific data items that this role can access';
  static const String workforceSectionTitle = 'Workforce Structure';
  static const String positionLabel = 'Position';
  static const String positionHint = 'Select a position';
  static const String jobFamilyLabel = 'Job Family';
  static const String jobFamilyHint = 'Select a job family';
  static const String gradeLabel = 'Grade';
  static const String gradeHint = 'Select a grade';
  static const String jobLevelLabel = 'Job Level';
  static const String jobLevelHint = 'Select a job level';
  static const String workforceHelper = 'All fields are optional';

  static const String hierarchySectionTitle = 'Hierarchy Configuration';
  static const String crossOrgSectionTitle = 'Cross-Organizational Access';
  static const String effectiveDatesTitle = 'Effective Dates';
  static const String criteriaLogicTitle = 'Criteria Logic';
  static const String criteriaRulesTitle = 'Criteria Rules';
  static const String setupGuidanceTitle = 'Setup Guidance';
  static const String setupGuidanceBody =
      'Keep the role focused on a single module and select only the functions this role truly needs.';
  static const String effectiveFromLabel = 'Effective From';
  static const String expirationDateLabel = 'Expiration Date';
  static const String effectiveDateHint = 'dd/mm/yyyy';
  static const String effectiveDateHelper = 'Both dates are required';
  static const String addCriterionLabel = 'Add Criterion';
  static const String criterionFieldLabel = 'Field';
  static const String criterionOperatorLabel = 'Operator';
  static const String criterionValueLabel = 'Value';
  static const String criterionValueHint = 'Enter value...';
  static const String hierarchyLevelLabel = 'Hierarchy Level';
  static const String hierarchyLevelHelper = 'Number of levels down the hierarchy (1-10)';
  static const String includeSubordinatesLabel = 'Include Subordinates';
  static const String crossDepartmentAccessLabel = 'Cross Department Access';
  static const String accessLogicLabel = 'Access Logic';
  static const String criteriaLogicAndLabel = 'AND (All conditions must match)';
  static const String criteriaLogicOrLabel = 'OR (Any condition can match)';

  static final String submitIconPath = Assets.icons.saveConfigIcon.path;
  static final String tabsSettingsIconPath = Assets.icons.manageEnterpriseIcon.path;
  static final String tabsDepartmentIconPath = Assets.icons.securityManager.database.path;
  static final String tabsCompanyIconPath = Assets.icons.hierarchyIconDepartment.path;
  static final String tabsBusinessUnitIconPath = Assets.icons.levelsIcon.path;
  static final String infoIconPath = Assets.icons.infoCircleBlue.path;
  static final String workforceIconPath = Assets.icons.levelsIcon.path;
  static final String hierarchyIconPath = Assets.icons.securityManager.hierarchy.path;
  static final String crossOrgIconPath = Assets.icons.companyIcon.path;
  static final String datesIconPath = Assets.icons.employeesAssignedIcon.path;
  static final String addIconPath = Assets.icons.addDivisionIcon.path;
  static final String deleteIconPath = Assets.icons.deleteIconRed.path;
  static final String searchIconPath = Assets.icons.searchIcon.path;
  static final String noDataTypeIconPath = Assets.icons.departmentIcon.path;

  static const List<String> stepLabels = ['Basic Information', 'Workforce Structure', 'Enterprise Structure'];

  static const List<DataRoleStatus> statusOptions = DataRoleStatus.values;

  static const List<String> hierarchyLevelOptions = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];

  static const List<String> includeSubordinatesOptions = [defaultIncludeSubordinates, 'Yes - Include all subordinates'];

  static const List<String> crossDepartmentAccessOptions = [
    defaultCrossDepartmentAccess,
    'Yes - Allow cross department access',
  ];

  static const List<String> accessLogicOptions = [defaultAccessLogic, 'Exclude - Restrict access'];

  static const List<String> criteriaLogicOptions = ['AND', 'OR'];

  static const List<String> criterionFieldOptions = [
    'Department',
    'Legal Entity',
    'Location',
    'Division',
    'Business Unit',
  ];

  static const List<String> criterionOperatorOptions = ['Equals', 'Contains', 'Starts With', 'Ends With'];

  static final RegExp roleCodePattern = RegExp(r'^[A-Z0-9_]+$');
}
