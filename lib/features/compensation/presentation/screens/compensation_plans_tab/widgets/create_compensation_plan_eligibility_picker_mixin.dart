import 'package:grc/core/widgets/forms/digify_multi_select_dialog.dart';
import 'package:grc/features/compensation/domain/models/lookups/comp_lookup_value.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_provider.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_scope_selection_providers.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/comp_lookups_provider.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/manage_salary_structure_lookups_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'create_compensation_plan_eligibility_step.dart';

mixin CreateCompensationPlanEligibilityPickerMixin on ConsumerState<CreateCompensationPlanEligibilityStep> {
  Future<void> pickContractTypes() async {
    final selectedIds = ref.read(createCompensationPlanProvider).eligibilityContractTypes;
    final selected = await _showEligibilityMultiSelectDialog(
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
            showSelectAllAction: true,
          );
        },
      ),
    );

    if (selected != null) {
      ref.read(createCompensationPlanProvider.notifier).setEligibilityContractTypes(selected);
    }
  }

  Future<void> pickPlanAttributes(AsyncValue<List<CompLookupValue>> planAttributesAsync) async {
    final state = ref.read(createCompensationPlanProvider);
    final values = planAttributesAsync.valueOrNull ?? const <CompLookupValue>[];

    final selected = await _showEligibilityMultiSelectDialog(
      Consumer(
        builder: (context, ref, _) {
          final asyncValues = ref.watch(compensationPlansLookupValuesProvider('COMP_PLAN_ATTRUBUTES'));
          final items = asyncValues.valueOrNull ?? const <CompLookupValue>[];

          return DigifyMultiSelectDialog<CompLookupValue>(
            title: 'Select Plan Attributes',
            subtitle: 'Choose one or more plan attributes',
            items: items,
            selectedIds: state.eligibilityPlanAttributes,
            idBuilder: (item) => item.valueCode,
            labelBuilder: (item) => item.valueName,
            isLoading: asyncValues.isLoading,
            errorMessage: asyncValues.hasError ? asyncValues.error.toString() : null,
            onRetry: () => ref.invalidate(compensationPlansLookupValuesProvider('COMP_PLAN_ATTRUBUTES')),
            searchHint: 'Search plan attributes...',
            emptyMessage: values.isEmpty ? 'No plan attributes available' : 'No matching plan attributes',
            headerIcon: Icons.rule_rounded,
            showSelectAllAction: true,
          );
        },
      ),
    );

    if (selected != null) {
      ref.read(createCompensationPlanProvider.notifier).setEligibilityPlanAttributes(selected);
    }
  }

  Future<void> pickJobFamilies() async {
    final state = ref.read(createCompensationPlanProvider);
    final selected = await _showEligibilityMultiSelectDialog(
      Consumer(
        builder: (context, ref, _) {
          final listState = ref.watch(compensationPlanJobFamilyNotifierProvider);
          return DigifyMultiSelectDialog<JobFamily>(
            title: 'Select Job Families',
            subtitle: 'Choose one or more job families',
            items: listState.items,
            selectedIds: state.eligibilityJobFamilies,
            idBuilder: (item) => item.id.toString(),
            labelBuilder: (item) => item.nameEnglish,
            isLoading: listState.isLoading,
            errorMessage: listState.errorMessage,
            onRetry: () => ref.read(compensationPlanJobFamilyNotifierProvider.notifier).loadFirstPage(),
            pagination: DigifyMultiSelectPagination(
              currentPage: listState.currentPage,
              totalPages: listState.totalPages,
              totalItems: listState.totalItems,
              pageSize: listState.pageSize,
              hasNext: listState.hasNextPage,
              hasPrevious: listState.hasPreviousPage,
            ),
            onPreviousPage: listState.hasPreviousPage
                ? () => ref.read(compensationPlanJobFamilyNotifierProvider.notifier).goToPage(listState.currentPage - 1)
                : null,
            onNextPage: listState.hasNextPage
                ? () => ref.read(compensationPlanJobFamilyNotifierProvider.notifier).goToPage(listState.currentPage + 1)
                : null,
            onPageTap: (page) => ref.read(compensationPlanJobFamilyNotifierProvider.notifier).goToPage(page),
            searchHint: 'Search job family...',
            emptyMessage: 'No job families found',
            headerIcon: Icons.family_restroom_rounded,
            showSelectAllAction: true,
          );
        },
      ),
    );

    if (selected != null) {
      ref.read(createCompensationPlanProvider.notifier).setEligibilityJobFamilies(selected);
    }
  }

  Future<void> pickPositions() async {
    final state = ref.read(createCompensationPlanProvider);
    final selected = await _showEligibilityMultiSelectDialog(
      Consumer(
        builder: (context, ref, _) {
          final listState = ref.watch(compensationPlanPositionNotifierProvider);
          return DigifyMultiSelectDialog<Position>(
            title: 'Select Positions',
            subtitle: 'Choose one or more positions',
            items: listState.items,
            selectedIds: state.eligibilityPositionIds,
            idBuilder: (item) => item.id,
            labelBuilder: (item) => '${item.titleEnglish} (${item.code})',
            isLoading: listState.isLoading,
            errorMessage: listState.errorMessage,
            onRetry: () => ref.read(compensationPlanPositionNotifierProvider.notifier).loadFirstPage(),
            pagination: DigifyMultiSelectPagination(
              currentPage: listState.currentPage,
              totalPages: listState.totalPages,
              totalItems: listState.totalItems,
              pageSize: listState.pageSize,
              hasNext: listState.hasNextPage,
              hasPrevious: listState.hasPreviousPage,
            ),
            onPreviousPage: listState.hasPreviousPage
                ? () => ref.read(compensationPlanPositionNotifierProvider.notifier).goToPage(listState.currentPage - 1)
                : null,
            onNextPage: listState.hasNextPage
                ? () => ref.read(compensationPlanPositionNotifierProvider.notifier).goToPage(listState.currentPage + 1)
                : null,
            onPageTap: (page) => ref.read(compensationPlanPositionNotifierProvider.notifier).goToPage(page),
            searchHint: 'Search position...',
            emptyMessage: 'No positions found',
            headerIcon: Icons.badge_rounded,
            showSelectAllAction: true,
          );
        },
      ),
    );

    if (selected != null) {
      ref.read(createCompensationPlanProvider.notifier).setEligibilityPositionIds(selected);
    }
  }

  Future<void> pickGrades() async {
    final state = ref.read(createCompensationPlanProvider);
    final selected = await _showEligibilityMultiSelectDialog(
      Consumer(
        builder: (context, ref, _) {
          final listState = ref.watch(compensationPlanGradeNotifierProvider);
          return DigifyMultiSelectDialog<Grade>(
            title: 'Select Grades',
            subtitle: 'Choose one or more grades',
            items: listState.items,
            selectedIds: state.eligibilityGradeIds,
            idBuilder: (item) => item.id.toString(),
            labelBuilder: (item) => item.gradeLabel,
            isLoading: listState.isLoading,
            errorMessage: listState.errorMessage,
            onRetry: () => ref.read(compensationPlanGradeNotifierProvider.notifier).loadFirstPage(),
            pagination: DigifyMultiSelectPagination(
              currentPage: listState.currentPage,
              totalPages: listState.totalPages,
              totalItems: listState.totalItems,
              pageSize: listState.pageSize,
              hasNext: listState.hasNextPage,
              hasPrevious: listState.hasPreviousPage,
            ),
            onPreviousPage: listState.hasPreviousPage
                ? () => ref.read(compensationPlanGradeNotifierProvider.notifier).goToPage(listState.currentPage - 1)
                : null,
            onNextPage: listState.hasNextPage
                ? () => ref.read(compensationPlanGradeNotifierProvider.notifier).goToPage(listState.currentPage + 1)
                : null,
            onPageTap: (page) => ref.read(compensationPlanGradeNotifierProvider.notifier).goToPage(page),
            searchHint: 'Search grade...',
            emptyMessage: 'No grades found',
            headerIcon: Icons.layers_rounded,
            showSelectAllAction: true,
          );
        },
      ),
    );

    if (selected != null) {
      ref.read(createCompensationPlanProvider.notifier).setEligibilityGradeIds(selected);
    }
  }

  CompLookupValue? findLookupByCode(List<CompLookupValue> values, String code) {
    for (final value in values) {
      if (value.valueCode == code) return value;
    }
    for (final value in values) {
      if (value.lookupValueId.toString() == code) return value;
    }
    return null;
  }

  Future<List<String>?> _showEligibilityMultiSelectDialog(Widget dialog) {
    return DigifyMultiSelectDialog.showAdaptive<List<String>>(
      context: context,
      child: dialog,
      barrierDismissible: false,
    );
  }
}
