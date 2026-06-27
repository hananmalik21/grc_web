import 'package:grc/features/security_manager/domain/models/security_function.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/function_role_form_dialog/included_functions_section.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/security_functions/security_functions_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class FunctionsStep extends StatelessWidget {
  const FunctionsStep({
    super.key,
    required this.functionsSearchController,
    required this.state,
    required this.notifier,
    required this.functionsState,
    required this.fnNotifier,
    required this.filteredFunctions,
  });

  final TextEditingController functionsSearchController;
  final FunctionRolesState state;
  final FunctionRolesNotifier notifier;
  final SecurityFunctionsState functionsState;
  final SecurityFunctionsNotifier fnNotifier;
  final List<SecurityFunction> filteredFunctions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IncludedFunctionsSection(
          isLoading: functionsState.isLoading,
          selectedCount: state.formSelectedFunctions.length,
          searchController: functionsSearchController,
          functions: filteredFunctions,
          selectedGuids: state.formSelectedFunctions,
          inheritedFunctionGuids: state.formInheritedFunctions,
          onSearchChanged: fnNotifier.search,
          onFunctionToggle: notifier.toggleFormFunction,
          currentPage: functionsState.currentPage,
          totalPages: functionsState.totalPages,
          totalItems: functionsState.totalItems,
          pageSize: functionsState.pageSize,
          hasNext: functionsState.hasNext,
          hasPrevious: functionsState.hasPrevious,
          onPreviousPage: fnNotifier.previousPage,
          onNextPage: fnNotifier.nextPage,
        ),
        Gap(18.h),
        const SetupGuidanceBanner(),
      ],
    );
  }
}
