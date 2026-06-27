import 'package:grc/features/security_manager/presentation/dialogs/roles_management/function_role_form_dialog/inherited_function_roles_section.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_role_form_inherited_picker_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_role_form_inherited_picker_state.dart';
import 'package:flutter/material.dart';

class InheritedRolesStep extends StatelessWidget {
  const InheritedRolesStep({
    super.key,
    required this.inheritedState,
    required this.inheritedNotifier,
    required this.searchController,
  });

  final FunctionRoleFormInheritedPickerState inheritedState;
  final FunctionRoleFormInheritedPickerNotifier inheritedNotifier;
  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return InheritedFunctionRolesSection(
      isLoading: inheritedState.isLoading,
      selectedCount: inheritedState.selectedGuids.length,
      searchController: searchController,
      roles: inheritedState.paginatedRoles,
      selectedGuids: inheritedState.selectedGuids,
      onSearchChanged: inheritedNotifier.updateSearch,
      onRoleToggle: inheritedNotifier.toggleSelection,
      currentPage: inheritedState.safePage,
      totalPages: inheritedState.totalPages,
      totalItems: inheritedState.filteredRoles.length,
      pageSize: FunctionRoleFormInheritedPickerState.pageSize,
      hasNext: inheritedState.safePage < inheritedState.totalPages,
      hasPrevious: inheritedState.safePage > 1,
      onPreviousPage: inheritedNotifier.previousPage,
      onNextPage: inheritedNotifier.nextPage,
    );
  }
}
