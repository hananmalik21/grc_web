import 'package:grc/gen/assets.gen.dart';

class DutyRoleFormConfig {
  static const String dialogTitle = 'Create New Duty Role';
  static const double dialogMaxWidth = 980;
  static const double dialogMaxHeightFactor = 0.76;
  static const String createButtonLabel = 'Create Duty Role';
  static const String continueButtonLabel = 'Continue';
  static const String backButtonLabel = 'Back';
  static const String cancelButtonLabel = 'Cancel';
  static const String successTitle = 'Created Role';
  static const String successMessage = 'Duty role created successfully';
  static const String activeStatus = 'Active';
  static const String inactiveStatus = 'Inactive';
  static const String roleNameLabel = 'Duty Role Name';
  static const String roleNameHint = 'e.g., HR Operations Duty';
  static const String roleCodeLabel = 'Role Code';
  static const String roleCodeHint = 'e.g., DUTY_HR_OPERATIONS';
  static const String statusLabel = 'Status';
  static const String categoryLabel = 'Category';
  static const String categoryHint = 'Select Category';
  static const String descriptionLabel = 'Description';
  static const String descriptionHint = 'Describe the purpose and scope of this duty role...';
  static const String advancedSettingsTitle = 'Advanced Settings';
  static const String effectiveDateLabel = 'Effective Date';
  static const String expirationDateLabel = 'Expiration Date';
  static const String effectiveDateHint = 'dd/mm/yyyy';
  static const String approvalRequiredLabel = 'Requires manager approval for assignment';
  static const String functionRolesSelectedTitle = 'Selected Function Roles';
  static const String functionRolesSearchHint = 'Search function roles...';
  static const String functionRolesEmptyMessage = 'No function roles found.';
  static const String noFunctionRolesTitle = 'No Function Roles Available';
  static const String noFunctionRolesBody = 'Please create or seed function roles before assigning them here.';

  static final String basicInfoIconPath = Assets.icons.focusAreaIcon.path;
  static final String functionRolesIconPath = Assets.icons.leaveManagement.shield.path;
  static final String inheritedRolesIconPath = Assets.icons.securityManager.hierarchy.path;
  static final String searchIconPath = Assets.icons.searchIcon.path;
  static final String submitIconPath = Assets.icons.saveConfigIcon.path;
  static final String closeIconPath = Assets.icons.closeIcon.path;
  static final String effectiveDateIconPath = Assets.icons.calendarIcon.path;

  static const List<String> stepLabels = ['Basic Information', 'Function Roles', 'Inherited Roles'];

  static const List<String> statusOptions = [activeStatus, inactiveStatus];

  static final RegExp roleCodePattern = RegExp(r'^[A-Z0-9_]+$');
}
