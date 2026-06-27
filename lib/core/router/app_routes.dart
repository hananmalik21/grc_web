/// Centralized route paths for the entire application
class AppRoutes {
  AppRoutes._();

  static const String login = '/login';

  static const String dashboard = '/dashboard';
  static const String dashboardModuleSelection = '$dashboard/module-selection';
  static const String dashboardModuleSelectionParam = 'moduleId';
  static String dashboardModuleSelectionPath(String moduleId) =>
      '$dashboardModuleSelection/$moduleId';

  static const String enterpriseStructure = '/enterprise-structure';
  static const String securityManager = '/security-console';
  static const String grc = '/grc';
}
