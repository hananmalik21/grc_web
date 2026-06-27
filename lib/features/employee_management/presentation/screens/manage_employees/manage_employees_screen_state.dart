import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_filters_state.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_state.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageEmployeesScreenState {
  const ManageEmployeesScreenState({
    required this.localizations,
    required this.isDark,
    required this.effectiveEnterpriseId,
    required this.listState,
    required this.filters,
    required this.viewMode,
  });

  final AppLocalizations localizations;
  final bool isDark;
  final int? effectiveEnterpriseId;
  final ManageEmployeesListState listState;
  final ManageEmployeesFiltersState filters;
  final EmployeeViewMode viewMode;
}

ManageEmployeesScreenState readManageEmployeesState(BuildContext context, WidgetRef ref) => ManageEmployeesScreenState(
  localizations: AppLocalizations.of(context)!,
  isDark: Theme.of(context).brightness == Brightness.dark,
  effectiveEnterpriseId: ref.watch(manageEmployeesEnterpriseIdProvider),
  listState: ref.watch(manageEmployeesListProvider),
  filters: ref.watch(manageEmployeesFiltersProvider),
  viewMode: ref.watch(manageEmployeesViewModeProvider),
);
