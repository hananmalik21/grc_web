import 'package:grc/core/widgets/forms/digify_multi_select_dialog.dart';
import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_structure_providers.dart';
import 'package:grc/features/security_manager/data/config/roles_management/data_role_form_config.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_data_role_dialog/widgets/create_data_role_shared_widgets.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/create_data_role_form_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateDataRoleWorkforceStructureStep extends ConsumerStatefulWidget {
  const CreateDataRoleWorkforceStructureStep({super.key});

  @override
  ConsumerState<CreateDataRoleWorkforceStructureStep> createState() => _CreateDataRoleWorkforceStructureStepState();
}

class _CreateDataRoleWorkforceStructureStepState extends ConsumerState<CreateDataRoleWorkforceStructureStep> {
  int get _enterpriseId => ref.read(securityManagerEnterpriseIdProvider) ?? 0;

  Future<void> _pickPositions() async {
    final current = ref.read(createDataRoleFormProvider).selectedPositions;
    final selectedIds = current.map((p) => p.id).toList();

    final result = await showDialog<List<String>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(employeePositionNotifierProvider(_enterpriseId));
          return DigifyMultiSelectDialog<Position>(
            title: 'Select Positions',
            subtitle: 'Choose one or more positions',
            items: state.items,
            selectedIds: selectedIds,
            showSelectAllAction: true,
            idBuilder: (p) => p.id,
            labelBuilder: (p) => p.titleEnglish,
            isLoading: state.isLoading && state.items.isEmpty,
            errorMessage: state.hasError && state.items.isEmpty ? state.errorMessage : null,
            onRetry: () => ref.read(employeePositionNotifierProvider(_enterpriseId).notifier).loadFirstPage(),
            pagination: DigifyMultiSelectPagination(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              totalItems: state.totalItems,
              pageSize: state.pageSize,
              hasNext: state.hasNextPage,
              hasPrevious: state.hasPreviousPage,
            ),
            onPreviousPage: state.hasPreviousPage
                ? () =>
                      ref.read(employeePositionNotifierProvider(_enterpriseId).notifier).goToPage(state.currentPage - 1)
                : null,
            onNextPage: state.hasNextPage
                ? () =>
                      ref.read(employeePositionNotifierProvider(_enterpriseId).notifier).goToPage(state.currentPage + 1)
                : null,
            onPageTap: (page) => ref.read(employeePositionNotifierProvider(_enterpriseId).notifier).goToPage(page),
            searchHint: 'Search position...',
            emptyMessage: 'No positions found',
            headerIcon: Icons.badge_rounded,
          );
        },
      ),
    );

    if (result != null && mounted) {
      final allItems = ref.read(employeePositionNotifierProvider(_enterpriseId)).items;
      final fromPage = allItems.where((p) => result.contains(p.id)).toList();
      final preserved = current.where((p) => !allItems.any((i) => i.id == p.id)).toList();
      ref.read(createDataRoleFormProvider.notifier).updatePositions([...preserved, ...fromPage]);
    }
  }

  Future<void> _pickJobFamilies() async {
    final current = ref.read(createDataRoleFormProvider).selectedJobFamilies;
    final selectedIds = current.map((jf) => jf.id.toString()).toList();

    final result = await showDialog<List<String>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(employeeJobFamilyNotifierProvider(_enterpriseId));
          return DigifyMultiSelectDialog<JobFamily>(
            title: 'Select Job Families',
            subtitle: 'Choose one or more job families',
            items: state.items,
            showSelectAllAction: true,
            selectedIds: selectedIds,
            idBuilder: (jf) => jf.id.toString(),
            labelBuilder: (jf) => jf.nameEnglish,
            isLoading: state.isLoading && state.items.isEmpty,
            errorMessage: state.hasError && state.items.isEmpty ? state.errorMessage : null,
            onRetry: () => ref.read(employeeJobFamilyNotifierProvider(_enterpriseId).notifier).loadFirstPage(),
            pagination: DigifyMultiSelectPagination(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              totalItems: state.totalItems,
              pageSize: state.pageSize,
              hasNext: state.hasNextPage,
              hasPrevious: state.hasPreviousPage,
            ),
            onPreviousPage: state.hasPreviousPage
                ? () => ref
                      .read(employeeJobFamilyNotifierProvider(_enterpriseId).notifier)
                      .goToPage(state.currentPage - 1)
                : null,
            onNextPage: state.hasNextPage
                ? () => ref
                      .read(employeeJobFamilyNotifierProvider(_enterpriseId).notifier)
                      .goToPage(state.currentPage + 1)
                : null,
            onPageTap: (page) => ref.read(employeeJobFamilyNotifierProvider(_enterpriseId).notifier).goToPage(page),
            searchHint: 'Search job family...',
            emptyMessage: 'No job families found',
            headerIcon: Icons.family_restroom_rounded,
          );
        },
      ),
    );

    if (result != null && mounted) {
      final allItems = ref.read(employeeJobFamilyNotifierProvider(_enterpriseId)).items;
      final fromPage = allItems.where((jf) => result.contains(jf.id.toString())).toList();
      final preserved = current.where((jf) => !allItems.any((i) => i.id == jf.id)).toList();
      ref.read(createDataRoleFormProvider.notifier).updateJobFamilies([...preserved, ...fromPage]);
    }
  }

  Future<void> _pickGrades() async {
    final current = ref.read(createDataRoleFormProvider).selectedGrades;
    final selectedIds = current.map((g) => g.id.toString()).toList();

    final result = await showDialog<List<String>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(employeeGradeNotifierProvider(_enterpriseId));
          return DigifyMultiSelectDialog<Grade>(
            title: 'Select Grades',
            subtitle: 'Choose one or more grades',
            items: state.items,
            selectedIds: selectedIds,
            showSelectAllAction: true,
            idBuilder: (g) => g.id.toString(),
            labelBuilder: (g) => g.gradeLabel,
            isLoading: state.isLoading && state.items.isEmpty,
            errorMessage: state.hasError && state.items.isEmpty ? state.errorMessage : null,
            onRetry: () => ref.read(employeeGradeNotifierProvider(_enterpriseId).notifier).loadFirstPage(),
            pagination: DigifyMultiSelectPagination(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              totalItems: state.totalItems,
              pageSize: state.pageSize,
              hasNext: state.hasNextPage,
              hasPrevious: state.hasPreviousPage,
            ),
            onPreviousPage: state.hasPreviousPage
                ? () => ref.read(employeeGradeNotifierProvider(_enterpriseId).notifier).goToPage(state.currentPage - 1)
                : null,
            onNextPage: state.hasNextPage
                ? () => ref.read(employeeGradeNotifierProvider(_enterpriseId).notifier).goToPage(state.currentPage + 1)
                : null,
            onPageTap: (page) => ref.read(employeeGradeNotifierProvider(_enterpriseId).notifier).goToPage(page),
            searchHint: 'Search grade...',
            emptyMessage: 'No grades found',
            headerIcon: Icons.layers_rounded,
          );
        },
      ),
    );

    if (result != null && mounted) {
      final allItems = ref.read(employeeGradeNotifierProvider(_enterpriseId)).items;
      final fromPage = allItems.where((g) => result.contains(g.id.toString())).toList();
      final preserved = current.where((g) => !allItems.any((i) => i.id == g.id)).toList();
      ref.read(createDataRoleFormProvider.notifier).updateGrades([...preserved, ...fromPage]);
    }
  }

  Future<void> _pickJobLevels() async {
    final current = ref.read(createDataRoleFormProvider).selectedJobLevels;
    final selectedIds = current.map((jl) => jl.id.toString()).toList();

    final result = await showDialog<List<String>>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(employeeJobLevelNotifierProvider(_enterpriseId));
          return DigifyMultiSelectDialog<JobLevel>(
            title: 'Select Job Levels',
            subtitle: 'Choose one or more job levels',
            items: state.items,
            selectedIds: selectedIds,
            showSelectAllAction: true,
            idBuilder: (jl) => jl.id.toString(),
            labelBuilder: (jl) => jl.nameEn,
            isLoading: state.isLoading && state.items.isEmpty,
            errorMessage: state.hasError && state.items.isEmpty ? state.errorMessage : null,
            onRetry: () => ref.read(employeeJobLevelNotifierProvider(_enterpriseId).notifier).loadFirstPage(),
            pagination: DigifyMultiSelectPagination(
              currentPage: state.currentPage,
              totalPages: state.totalPages,
              totalItems: state.totalItems,
              pageSize: state.pageSize,
              hasNext: state.hasNextPage,
              hasPrevious: state.hasPreviousPage,
            ),
            onPreviousPage: state.hasPreviousPage
                ? () =>
                      ref.read(employeeJobLevelNotifierProvider(_enterpriseId).notifier).goToPage(state.currentPage - 1)
                : null,
            onNextPage: state.hasNextPage
                ? () =>
                      ref.read(employeeJobLevelNotifierProvider(_enterpriseId).notifier).goToPage(state.currentPage + 1)
                : null,
            onPageTap: (page) => ref.read(employeeJobLevelNotifierProvider(_enterpriseId).notifier).goToPage(page),
            searchHint: 'Search job level...',
            emptyMessage: 'No job levels found',
            headerIcon: Icons.trending_up_rounded,
          );
        },
      ),
    );

    if (result != null && mounted) {
      final allItems = ref.read(employeeJobLevelNotifierProvider(_enterpriseId)).items;
      final fromPage = allItems.where((jl) => result.contains(jl.id.toString())).toList();
      final preserved = current.where((jl) => !allItems.any((i) => i.id == jl.id)).toList();
      ref.read(createDataRoleFormProvider.notifier).updateJobLevels([...preserved, ...fromPage]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(createDataRoleFormProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CreateDataRoleStepHeader(title: DataRoleFormConfig.workforceSectionTitle),
        Gap(16.h),
        _WorkforcePickerGrid(
          selectedPositionCount: formState.selectedPositions.length,
          selectedJobFamilyCount: formState.selectedJobFamilies.length,
          selectedGradeCount: formState.selectedGrades.length,
          selectedJobLevelCount: formState.selectedJobLevels.length,
          onPickPositions: _pickPositions,
          onPickJobFamilies: _pickJobFamilies,
          onPickGrades: _pickGrades,
          onPickJobLevels: _pickJobLevels,
        ),
        Gap(8.h),
        CreateDataRoleHelperText(text: DataRoleFormConfig.workforceHelper),
      ],
    );
  }
}

class _WorkforcePickerGrid extends StatelessWidget {
  const _WorkforcePickerGrid({
    required this.selectedPositionCount,
    required this.selectedJobFamilyCount,
    required this.selectedGradeCount,
    required this.selectedJobLevelCount,
    required this.onPickPositions,
    required this.onPickJobFamilies,
    required this.onPickGrades,
    required this.onPickJobLevels,
  });

  final int selectedPositionCount;
  final int selectedJobFamilyCount;
  final int selectedGradeCount;
  final int selectedJobLevelCount;
  final VoidCallback onPickPositions;
  final VoidCallback onPickJobFamilies;
  final VoidCallback onPickGrades;
  final VoidCallback onPickJobLevels;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;

        final positionField = DigifyMultiSelectFieldWithLabel(
          label: DataRoleFormConfig.positionLabel,
          hint: DataRoleFormConfig.positionHint,
          selectedCount: selectedPositionCount,
          isRequired: false,
          onTap: onPickPositions,
        );

        final jobFamilyField = DigifyMultiSelectFieldWithLabel(
          label: DataRoleFormConfig.jobFamilyLabel,
          hint: DataRoleFormConfig.jobFamilyHint,
          selectedCount: selectedJobFamilyCount,
          isRequired: false,
          onTap: onPickJobFamilies,
        );

        final gradeField = DigifyMultiSelectFieldWithLabel(
          label: DataRoleFormConfig.gradeLabel,
          hint: DataRoleFormConfig.gradeHint,
          selectedCount: selectedGradeCount,
          isRequired: false,
          onTap: onPickGrades,
        );

        final jobLevelField = DigifyMultiSelectFieldWithLabel(
          label: DataRoleFormConfig.jobLevelLabel,
          hint: DataRoleFormConfig.jobLevelHint,
          selectedCount: selectedJobLevelCount,
          isRequired: false,
          onTap: onPickJobLevels,
        );

        if (!isWide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [positionField, Gap(16.h), jobFamilyField, Gap(16.h), gradeField, Gap(16.h), jobLevelField],
          );
        }

        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: positionField),
                Gap(16.w),
                Expanded(child: jobFamilyField),
              ],
            ),
            Gap(16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: gradeField),
                Gap(16.w),
                Expanded(child: jobLevelField),
              ],
            ),
          ],
        );
      },
    );
  }
}
