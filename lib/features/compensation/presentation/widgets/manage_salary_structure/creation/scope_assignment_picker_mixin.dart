import 'package:grc/core/widgets/forms/digify_multi_select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/lookups/manage_salary_structure_lookups_provider.dart';
import '../../../providers/salary_structure_creation_provider.dart';
import '../../../providers/salary_structure_scope_selection_providers.dart';
import '../../../../../workforce_structure/domain/models/grade.dart';
import '../../../../../workforce_structure/domain/models/job_family.dart';
import '../../../../../workforce_structure/domain/models/position.dart';

mixin ScopeAssignmentPickerMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Future<void> pickJobFamily() async {
    final selectedIds = ref.read(salaryStructureCreationProvider).jobFamilyIds.map((id) => id.toString()).toList();
    final selected = await _showScopeMultiSelectDialog(
      Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(salaryStructureJobFamilyNotifierProvider);
          return DigifyMultiSelectDialog<JobFamily>(
            title: 'Select Job Families',
            subtitle: 'Choose one or more job families',
            items: state.items,
            selectedIds: selectedIds,
            idBuilder: (item) => item.id.toString(),
            labelBuilder: (item) => item.nameEnglish,
            isLoading: state.isLoading,
            errorMessage: state.errorMessage,
            onRetry: () => ref.read(salaryStructureJobFamilyNotifierProvider.notifier).loadFirstPage(),
            pagination: DigifyMultiSelectPagination(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              totalItems: state.totalItems,
              pageSize: state.pageSize,
              hasNext: state.hasNextPage,
              hasPrevious: state.hasPreviousPage,
            ),
            onPreviousPage: state.hasPreviousPage
                ? () => ref.read(salaryStructureJobFamilyNotifierProvider.notifier).goToPage(state.currentPage - 1)
                : null,
            onNextPage: state.hasNextPage
                ? () => ref.read(salaryStructureJobFamilyNotifierProvider.notifier).goToPage(state.currentPage + 1)
                : null,
            onPageTap: (page) => ref.read(salaryStructureJobFamilyNotifierProvider.notifier).goToPage(page),
            searchHint: 'Search job family...',
            emptyMessage: 'No job families found',
            headerIcon: Icons.family_restroom_rounded,
            showSelectAllAction: true,
          );
        },
      ),
    );
    if (selected != null) {
      ref.read(salaryStructureCreationProvider.notifier).setJobFamilyIds(selected.map(int.parse).toList());
    }
  }

  Future<void> pickPosition() async {
    final selectedIds = ref.read(salaryStructureCreationProvider).positionIds;
    final selected = await _showScopeMultiSelectDialog(
      Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(salaryStructurePositionNotifierProvider);
          return DigifyMultiSelectDialog<Position>(
            title: 'Select Positions',
            subtitle: 'Choose one or more positions',
            items: state.items,
            selectedIds: selectedIds,
            idBuilder: (item) => item.id,
            labelBuilder: (item) => '${item.titleEnglish} (${item.code})',
            isLoading: state.isLoading,
            errorMessage: state.errorMessage,
            onRetry: () => ref.read(salaryStructurePositionNotifierProvider.notifier).loadFirstPage(),
            pagination: DigifyMultiSelectPagination(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              totalItems: state.totalItems,
              pageSize: state.pageSize,
              hasNext: state.hasNextPage,
              hasPrevious: state.hasPreviousPage,
            ),
            onPreviousPage: state.hasPreviousPage
                ? () => ref.read(salaryStructurePositionNotifierProvider.notifier).goToPage(state.currentPage - 1)
                : null,
            onNextPage: state.hasNextPage
                ? () => ref.read(salaryStructurePositionNotifierProvider.notifier).goToPage(state.currentPage + 1)
                : null,
            onPageTap: (page) => ref.read(salaryStructurePositionNotifierProvider.notifier).goToPage(page),
            searchHint: 'Search position...',
            emptyMessage: 'No positions found',
            headerIcon: Icons.badge_rounded,
            showSelectAllAction: true,
          );
        },
      ),
    );
    if (selected != null) {
      ref.read(salaryStructureCreationProvider.notifier).setPositionIds(selected);
    }
  }

  Future<void> pickGrade() async {
    final selectedIds = ref.read(salaryStructureCreationProvider).gradeIds.map((id) => id.toString()).toList();
    final selected = await _showScopeMultiSelectDialog(
      Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(salaryStructureGradeNotifierProvider);
          return DigifyMultiSelectDialog<Grade>(
            title: 'Select Grades',
            subtitle: 'Choose one or more grades',
            items: state.items,
            selectedIds: selectedIds,
            idBuilder: (item) => item.id.toString(),
            labelBuilder: (item) => item.gradeLabel,
            isLoading: state.isLoading,
            errorMessage: state.errorMessage,
            onRetry: () => ref.read(salaryStructureGradeNotifierProvider.notifier).loadFirstPage(),
            pagination: DigifyMultiSelectPagination(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              totalItems: state.totalItems,
              pageSize: state.pageSize,
              hasNext: state.hasNextPage,
              hasPrevious: state.hasPreviousPage,
            ),
            onPreviousPage: state.hasPreviousPage
                ? () => ref.read(salaryStructureGradeNotifierProvider.notifier).goToPage(state.currentPage - 1)
                : null,
            onNextPage: state.hasNextPage
                ? () => ref.read(salaryStructureGradeNotifierProvider.notifier).goToPage(state.currentPage + 1)
                : null,
            onPageTap: (page) => ref.read(salaryStructureGradeNotifierProvider.notifier).goToPage(page),
            searchHint: 'Search grade...',
            emptyMessage: 'No grades found',
            headerIcon: Icons.layers_rounded,
            showSelectAllAction: true,
          );
        },
      ),
    );
    if (selected != null) {
      ref.read(salaryStructureCreationProvider.notifier).setGradeIds(selected.map(int.parse).toList());
    }
  }

  Future<void> pickEmployeeCategories() async {
    final selectedIds = ref.read(salaryStructureCreationProvider).employeeCategories;
    final selected = await _showScopeMultiSelectDialog(
      Consumer(
        builder: (context, ref, _) {
          final asyncValues = ref.watch(manageSalaryStructureEmployeeCategoryLookupValuesProvider);
          final values = asyncValues.valueOrNull ?? const [];
          final items = values.map((e) => e.valueCode).toList();
          final labels = {for (final item in values) item.valueCode: item.valueName};

          return DigifyMultiSelectDialog<String>(
            title: 'Select Employee Categories',
            subtitle: 'Choose one or more employee categories',
            items: items,
            selectedIds: selectedIds,
            idBuilder: (value) => value,
            labelBuilder: (value) => labels[value] ?? value,
            isLoading: asyncValues.isLoading,
            errorMessage: asyncValues.hasError ? asyncValues.error.toString() : null,
            onRetry: () => ref.invalidate(manageSalaryStructureEmployeeCategoryLookupValuesProvider),
            searchHint: 'Search employee category...',
            emptyMessage: 'No employee categories available',
            headerIcon: Icons.people_rounded,
            showSelectAllAction: true,
          );
        },
      ),
    );
    if (selected != null) {
      ref.read(salaryStructureCreationProvider.notifier).setEmployeeCategories(selected);
    }
  }

  Future<void> pickContractTypes() async {
    final selectedIds = ref.read(salaryStructureCreationProvider).contractTypes;
    final selected = await _showScopeMultiSelectDialog(
      Consumer(
        builder: (context, ref, _) {
          final asyncValues = ref.watch(manageSalaryStructureContractTypeLookupValuesProvider);
          final values = asyncValues.valueOrNull ?? const [];
          final items = values.map((e) => e.lookupCode).toList();
          final labels = {for (final item in values) item.lookupCode: item.meaningEn};

          return DigifyMultiSelectDialog<String>(
            title: 'Select Contract Types',
            subtitle: 'Choose one or more contract types',
            items: items,
            selectedIds: selectedIds,
            idBuilder: (value) => value,
            labelBuilder: (value) => labels[value] ?? value,
            isLoading: asyncValues.isLoading,
            errorMessage: asyncValues.hasError ? asyncValues.error.toString() : null,
            onRetry: () => ref.invalidate(manageSalaryStructureContractTypeLookupValuesProvider),
            searchHint: 'Search contract type...',
            emptyMessage: 'No contract types available',
            headerIcon: Icons.description_rounded,
            showSelectAllAction: true,
          );
        },
      ),
    );
    if (selected != null) {
      ref.read(salaryStructureCreationProvider.notifier).setContractTypes(selected);
    }
  }

  Future<List<String>?> _showScopeMultiSelectDialog(Widget dialog) {
    return DigifyMultiSelectDialog.showAdaptive<List<String>>(
      context: context,
      child: dialog,
      barrierDismissible: false,
    );
  }
}
