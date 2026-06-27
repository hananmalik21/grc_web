import 'package:grc/features/security_manager/domain/models/job_role.dart';
import 'package:grc/gen/assets.gen.dart';

class JobRoleFormConfig {
  static const String dialogTitle = 'Create New Job Role';
  static const double dialogMaxWidth = 980;
  static const double dialogMaxHeightFactor = 0.78;
  static const String createButtonLabel = 'Create Job Role';
  static const String continueButtonLabel = 'Continue';
  static const String backButtonLabel = 'Back';
  static const String cancelButtonLabel = 'Cancel';
  static const String successTitle = 'Created Role';
  static const String successMessage = 'Job role created successfully';
  static const JobRoleStatus defaultStatus = JobRoleStatus.active;
  static const String roleNameLabel = 'Role Name';
  static const String roleNameHint = 'e.g., HR Specialist Job Role';
  static const String roleCodeLabel = 'Role Code';
  static const String roleCodeHint = 'e.g., JOB_HR_SPECIALIST';
  static const String statusLabel = 'Status';
  static const String jobTitleLabel = 'Job Title';
  static const String jobTitleHint = 'e.g., HR Specialist';
  static const String departmentLabel = 'Department';
  static const String departmentHint = 'Select Department';
  static const String descriptionLabel = 'Description';
  static const String descriptionHint = 'Describe the purpose and scope of this job role...';
  static const String advancedSettingsTitle = 'Advanced Settings';
  static const String effectiveDateLabel = 'Effective Date';
  static const String expirationDateLabel = 'Expiration Date';
  static const String effectiveDateHint = 'dd/mm/yyyy';
  static const String autoAssignLabel = 'Auto-assign to new employees with this job title';
  static const String approvalRequiredLabel = 'Requires manager approval for assignment';
  static const String dutyRolesSelectedTitle = 'Selected Duty Roles';
  static const String functionRolesSelectedTitle = 'Selected Function Roles';
  static const String dataRolesSelectedTitle = 'Selected Data Roles';
  static const String dutyRolesSearchHint = 'Search duty roles...';
  static const String functionRolesSearchHint = 'Search function roles...';
  static const String dataRolesSearchHint = 'Search data roles...';
  static const String dutyRolesEmptyMessage = 'No duty roles found.';
  static const String functionRolesEmptyMessage = 'No function roles found.';
  static const String dataRolesEmptyMessage = 'No data roles found.';

  static final String basicInfoIconPath = Assets.icons.leadershipIcon.path;
  static final String dutyRolesIconPath = Assets.icons.industryIcon.path;
  static final String functionRolesIconPath = Assets.icons.securityManager.functionalRoles.path;
  static final String dataRolesIconPath = Assets.icons.securityManager.database.path;
  static final String inheritedRolesIconPath = Assets.icons.securityManager.hierarchy.path;
  static final String searchIconPath = Assets.icons.searchIcon.path;
  static final String submitIconPath = Assets.icons.saveConfigIcon.path;
  static final String closeIconPath = Assets.icons.closeIcon.path;
  static final String effectiveDateIconPath = Assets.icons.calendarIcon.path;

  static const List<JobRoleStatus> statusOptions = JobRoleStatus.values;

  static final RegExp roleCodePattern = RegExp(r'^[A-Z0-9_]+$');
}
