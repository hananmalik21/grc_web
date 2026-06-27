import 'package:grc/features/employee_management/data/config/manage_employees_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ManageEmployeesColumn {
  rowNumber,
  employee,
  position,
  department,
  email,
  phone,
  status,
  actions,
}

class ManageEmployeesTableColumnWidths {
  final double? indexOverride;
  final double? employeeOverride;
  final double? positionOverride;
  final double? departmentOverride;
  final double? emailOverride;
  final double? phoneOverride;
  final double? statusOverride;
  final double? actionsOverride;

  const ManageEmployeesTableColumnWidths({
    this.indexOverride,
    this.employeeOverride,
    this.positionOverride,
    this.departmentOverride,
    this.emailOverride,
    this.phoneOverride,
    this.statusOverride,
    this.actionsOverride,
  });

  double get index => indexOverride ?? ManageEmployeesTableConfig.indexWidth.w;
  double get employee => employeeOverride ?? ManageEmployeesTableConfig.employeeWidth.w;
  double get position => positionOverride ?? ManageEmployeesTableConfig.positionWidth.w;
  double get department => departmentOverride ?? ManageEmployeesTableConfig.departmentWidth.w;
  double get email => emailOverride ?? ManageEmployeesTableConfig.emailWidth.w;
  double get phone => phoneOverride ?? ManageEmployeesTableConfig.phoneWidth.w;
  double get status => statusOverride ?? ManageEmployeesTableConfig.statusWidth.w;
  double get actions => actionsOverride ?? ManageEmployeesTableConfig.actionsWidth.w;

  ManageEmployeesTableColumnWidths copyWith({
    double? indexOverride,
    double? employeeOverride,
    double? positionOverride,
    double? departmentOverride,
    double? emailOverride,
    double? phoneOverride,
    double? statusOverride,
    double? actionsOverride,
  }) {
    return ManageEmployeesTableColumnWidths(
      indexOverride: indexOverride ?? this.indexOverride,
      employeeOverride: employeeOverride ?? this.employeeOverride,
      positionOverride: positionOverride ?? this.positionOverride,
      departmentOverride: departmentOverride ?? this.departmentOverride,
      emailOverride: emailOverride ?? this.emailOverride,
      phoneOverride: phoneOverride ?? this.phoneOverride,
      statusOverride: statusOverride ?? this.statusOverride,
      actionsOverride: actionsOverride ?? this.actionsOverride,
    );
  }
}

final manageEmployeesTableWidthsProvider =
    StateNotifierProvider<ManageEmployeesTableWidthsNotifier, ManageEmployeesTableColumnWidths>((ref) {
      return ManageEmployeesTableWidthsNotifier();
    });

class ManageEmployeesTableWidthsNotifier extends StateNotifier<ManageEmployeesTableColumnWidths> {
  ManageEmployeesTableWidthsNotifier() : super(const ManageEmployeesTableColumnWidths());

  void updateWidth(ManageEmployeesColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(60.0, 600.0);

    switch (column) {
      case ManageEmployeesColumn.rowNumber:
        state = state.copyWith(indexOverride: clampWidth(state.index));
        break;
      case ManageEmployeesColumn.employee:
        state = state.copyWith(employeeOverride: clampWidth(state.employee));
        break;
      case ManageEmployeesColumn.position:
        state = state.copyWith(positionOverride: clampWidth(state.position));
        break;
      case ManageEmployeesColumn.department:
        state = state.copyWith(departmentOverride: clampWidth(state.department));
        break;
      case ManageEmployeesColumn.email:
        state = state.copyWith(emailOverride: clampWidth(state.email));
        break;
      case ManageEmployeesColumn.phone:
        state = state.copyWith(phoneOverride: clampWidth(state.phone));
        break;
      case ManageEmployeesColumn.status:
        state = state.copyWith(statusOverride: clampWidth(state.status));
        break;
      case ManageEmployeesColumn.actions:
        state = state.copyWith(actionsOverride: clampWidth(state.actions));
        break;
    }
  }
}
