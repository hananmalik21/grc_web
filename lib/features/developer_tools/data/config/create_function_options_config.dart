class CreateFunctionOptionsConfig {
  CreateFunctionOptionsConfig._();

  static const List<String> moduleOptions = <String>['Core HR', 'Time Management', 'Compensation', 'Security Manager'];

  static const Map<String, List<String>> submoduleOptionsByModule = <String, List<String>>{
    'Core HR': <String>['Employee Profile', 'Org Chart', 'Contracts'],
    'Time Management': <String>['Shifts', 'Work Schedules', 'Calendar'],
    'Compensation': <String>['Salary Structure', 'Adjustments', 'Benefits'],
    'Security Manager': <String>['User Access', 'Roles & Permissions', 'Security Policies'],
  };

  static const List<String> actionOptions = <String>['View', 'Create', 'Update', 'Delete', 'Export', 'Approve'];
}
