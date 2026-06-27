import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/empty_state_widget.dart';
import 'package:grc/core/router/app_routes.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_list_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_provider.dart';
import 'package:grc/features/employee_management/presentation/screens/mixins/manage_employees_permission_mixin.dart';
import 'package:grc/features/employee_management/presentation/screens/manage_employees/manage_employees_screen_state.dart';
import 'package:grc/features/employee_management/presentation/widgets/common/employees_grid_view.dart';
import 'package:grc/features/employee_management/presentation/widgets/common/manage_employees_table.dart';
import 'package:grc/features/employee_management/presentation/widgets/edit_employee_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ManageEmployeesContentArea extends StatelessWidget {
  const ManageEmployeesContentArea({super.key, required this.s, required this.ref, required this.forceGrid});

  final ManageEmployeesScreenState s;
  final WidgetRef ref;
  final bool forceGrid;

  @override
  Widget build(BuildContext context) {
    if (s.listState.error != null) {
      return DigifyErrorState(
        message: s.localizations.somethingWentWrong,
        retryLabel: s.localizations.retry,
        onRetry: () => ref.read(manageEmployeesListProvider.notifier).refresh(),
      );
    }

    if (s.listState.items.isEmpty && !s.listState.isLoading) {
      return SizedBox(
        height: 320.h,
        child: EmptyStateWidget(icon: Icons.person_search_rounded, title: s.localizations.noResultsFound),
      );
    }

    final useGrid = forceGrid || s.viewMode == EmployeeViewMode.grid;

    if (useGrid) {
      return _GridContent(s: s, ref: ref);
    }

    return _TableContent(s: s, ref: ref);
  }
}

class _GridContent extends StatelessWidget {
  const _GridContent({required this.s, required this.ref});

  final ManageEmployeesScreenState s;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EmployeesGridView(
          employees: s.listState.isLoading ? [] : s.listState.items,
          localizations: s.localizations,
          isDark: s.isDark,
          isLoading: s.listState.isLoading,
          onView: (employee) => context.push(AppRoutes.employeeDetail, extra: employee),
          onMore: () {},
        ),
        if (s.listState.pagination != null) ...[
          Gap(16.h),
          PaginationControls.fromPaginationInfo(
            paginationInfo: s.listState.pagination!,
            currentPage: s.listState.currentPage,
            pageSize: s.listState.pagination!.pageSize,
            onPrevious: s.listState.pagination!.hasPrevious
                ? () => ref.read(manageEmployeesListProvider.notifier).goToPage(s.listState.currentPage - 1)
                : null,
            onNext: s.listState.pagination!.hasNext
                ? () => ref.read(manageEmployeesListProvider.notifier).goToPage(s.listState.currentPage + 1)
                : null,
            isLoading: false,
            style: PaginationStyle.simple,
          ),
        ],
      ],
    );
  }
}

class _TableContent extends StatelessWidget with ManageEmployeesPermissionMixin {
  const _TableContent({required this.s, required this.ref});

  final ManageEmployeesScreenState s;
  final WidgetRef ref;

  AppLocalizations get _l => s.localizations;

  @override
  Widget build(BuildContext context) {
    return ManageEmployeesTable(
      localizations: _l,
      employees: s.listState.items,
      isDark: s.isDark,
      isLoading: s.listState.isLoading,
      paginationInfo: s.listState.pagination,
      currentPage: s.listState.currentPage,
      pageSize: s.listState.pagination?.pageSize ?? 10,
      onPrevious: s.listState.pagination != null && s.listState.pagination!.hasPrevious
          ? () => ref.read(manageEmployeesListProvider.notifier).goToPage(s.listState.currentPage - 1)
          : null,
      onNext: s.listState.pagination != null && s.listState.pagination!.hasNext
          ? () => ref.read(manageEmployeesListProvider.notifier).goToPage(s.listState.currentPage + 1)
          : null,
      onView: (employee) => context.push(AppRoutes.employeeDetail, extra: employee),
      onEdit: canUpdateEmployee ? (employee) => EditEmployeeDialog.show(context, employee.id) : null,
      onMore: canDeleteEmployee ? () {} : null,
      paginationIsLoading: false,
    );
  }
}
