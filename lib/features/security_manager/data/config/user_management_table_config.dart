import 'package:grc/features/security_manager/presentation/widgets/user_management/user_management_table_types.dart';

class UserManagementTableConfig {
  UserManagementTableConfig._();

  static const bool showActions = true;

  static const double actionsWidth = 200;
  static const double userWidth = 300;
  static const double departmentWidth = 180;
  static const double rolesWidth = 450;
  static const double statusWidth = 140;
  static const double securityWidth = 180;

  static const double cellPaddingHorizontal = 24;
  static const int pageSize = 10;

  static double widthFor(UserManagementTableColumn column) {
    return switch (column) {
      UserManagementTableColumn.user => userWidth,
      UserManagementTableColumn.department => departmentWidth,
      UserManagementTableColumn.roles => rolesWidth,
      UserManagementTableColumn.status => statusWidth,
      UserManagementTableColumn.security => securityWidth,
    };
  }
}
