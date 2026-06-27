import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether the additional filter section is visible on the Manage Employees screen.
final manageEmployeesShowFiltersProvider = StateProvider<bool>((ref) => false);

enum EmployeeViewMode { grid, list }

final manageEmployeesViewModeProvider = StateProvider<EmployeeViewMode>((ref) => EmployeeViewMode.list);
