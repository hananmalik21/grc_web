import 'dart:ui';
import 'dart:async';

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/services/debouncer.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_assignment_employees_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateCompensationPlanEmployeeSelection extends ConsumerWidget {
  final int enterpriseId;
  final List<Employee> selectedEmployees;
  final ValueChanged<List<Employee>> onChanged;

  const CreateCompensationPlanEmployeeSelection({
    super.key,
    required this.enterpriseId,
    required this.selectedEmployees,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasValue = selectedEmployees.isNotEmpty;

    return InkWell(
      onTap: () async {
        final selected = await showDialog<List<Employee>>(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return _CreateCompensationPlanEmployeeSelectionDialog(
              enterpriseId: enterpriseId,
              selectedEmployees: selectedEmployees,
            );
          },
        );

        if (selected != null) {
          onChanged(selected);
        }
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Row(
          children: [
            DigifyAsset(
              assetPath: Assets.icons.compensation.users.path,
              width: 20.w,
              height: 20.w,
              color: AppColors.primary,
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    hasValue ? 'Selected Employees (${selectedEmployees.length})' : 'Select employees...',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: hasValue ? AppColors.textPrimary : AppColors.textPlaceholder,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (hasValue) ...[
                    Gap(2.h),
                    Text(
                      'Tap to add or remove employees',
                      style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            DigifyAssetButton(
              assetPath: Assets.icons.workforce.chevronRight.path,
              width: 20.w,
              height: 20.w,
              color: AppColors.textSecondary,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateCompensationPlanEmployeeSelectionDialog extends ConsumerStatefulWidget {
  final int enterpriseId;
  final List<Employee> selectedEmployees;

  const _CreateCompensationPlanEmployeeSelectionDialog({required this.enterpriseId, required this.selectedEmployees});

  @override
  ConsumerState<_CreateCompensationPlanEmployeeSelectionDialog> createState() =>
      _CreateCompensationPlanEmployeeSelectionDialogState();
}

class _CreateCompensationPlanEmployeeSelectionDialogState
    extends ConsumerState<_CreateCompensationPlanEmployeeSelectionDialog> {
  late final Set<String> _selectedIds;
  final Debouncer _debouncer = Debouncer(delay: const Duration(milliseconds: 400));
  String _query = '';

  @override
  void initState() {
    super.initState();
    _selectedIds = widget.selectedEmployees.map((employee) => employee.id.toString()).toSet();
    Future.microtask(() {
      ref
          .read(createCompensationPlanAssignmentEmployeesNotifierProvider.notifier)
          .loadEmployees(enterpriseId: widget.enterpriseId);
    });
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createCompensationPlanAssignmentEmployeesNotifierProvider);
    final notifier = ref.read(createCompensationPlanAssignmentEmployeesNotifierProvider.notifier);

    final filteredItems = state.employees.where((employee) {
      if (_query.trim().isEmpty) return true;
      final normalizedQuery = _query.trim().toLowerCase();
      return employee.fullName.toLowerCase().contains(normalizedQuery) ||
          (employee.employeeNumber?.toLowerCase().contains(normalizedQuery) ?? false) ||
          employee.email.toLowerCase().contains(normalizedQuery);
    }).toList();

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        elevation: 8,
        child: Container(
          width: 620.w,
          constraints: BoxConstraints(maxHeight: 740.h),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: AppColors.cardBackground),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, notifier),
              const DigifyDivider.horizontal(),
              Expanded(child: _buildContent(context, filteredItems, state, notifier)),
              if (state.totalPages > 0) ...[const DigifyDivider.horizontal(), _buildPagination(state, notifier)],
              const DigifyDivider.horizontal(),
              _buildActions(context, state, notifier),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, CreateCompensationPlanAssignmentEmployeesNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.people_alt_rounded, color: AppColors.primary, size: 24.sp),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Employees',
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                    ),
                    Gap(2.h),
                    Text(
                      'Choose one or more employees to assign to this plan',
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              DigifyAssetButton(
                assetPath: Assets.icons.closeIcon.path,
                onTap: () => context.pop(),
                width: 18.w,
                height: 18.w,
                padding: 6.w,
                borderRadius: BorderRadius.circular(999.r),
                color: AppColors.textSecondary,
              ),
            ],
          ),
          Gap(16.h),
          TextField(
            onChanged: (value) {
              setState(() => _query = value);
              _debouncer.run(() {
                notifier.searchEmployees(
                  enterpriseId: widget.enterpriseId,
                  search: value.trim().isEmpty ? null : value.trim(),
                );
              });
            },
            decoration: InputDecoration(
              hintText: 'Search employees...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _query.isEmpty
                  ? null
                  : IconButton(onPressed: () => setState(() => _query = ''), icon: const Icon(Icons.close_rounded)),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.borderGrey.withValues(alpha: 0.8)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.borderGrey.withValues(alpha: 0.8)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.55)),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    List<Employee> items,
    CreateCompensationPlanAssignmentEmployeesState state,
    CreateCompensationPlanAssignmentEmployeesNotifier notifier,
  ) {
    if (state.isLoading && state.employees.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: AppLoadingIndicator(type: LoadingType.circle),
        ),
      );
    }

    if (state.hasError && state.employees.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                state.errorMessage ?? 'Failed to load employees',
                style: TextStyle(fontSize: 14.sp, color: AppColors.error),
                textAlign: TextAlign.center,
              ),
              Gap(10.h),
              TextButton(
                onPressed: () => notifier.loadEmployees(enterpriseId: widget.enterpriseId, search: state.searchQuery),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final Widget content = items.isEmpty
        ? Center(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Text(
                'No employees found',
                style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
              ),
            ),
          )
        : ListView.separated(
            padding: EdgeInsets.all(16.w),
            itemCount: items.length,
            separatorBuilder: (_, _) => Gap(8.h),
            itemBuilder: (context, index) {
              final employee = items[index];
              final id = employee.id.toString();
              final isSelected = _selectedIds.contains(id);

              return InkWell(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedIds.remove(id);
                    } else {
                      _selectedIds.add(id);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(12.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.borderGrey.withValues(alpha: 0.5),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      AppAvatar(
                        size: 32,
                        fallbackInitial: employee.fullName,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      ),
                      Gap(12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              employee.fullName,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                              ),
                            ),
                            if ((employee.employeeNumber ?? '').isNotEmpty) ...[
                              Gap(2.h),
                              Text(
                                employee.employeeNumber!,
                                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Icon(
                        isSelected ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
              );
            },
          );

    if (state.isLoading && state.employees.isNotEmpty) {
      return Stack(
        children: [
          IgnorePointer(child: content),
          Positioned.fill(
            child: Container(
              color: AppColors.cardBackground.withValues(alpha: 0.65),
              alignment: Alignment.center,
              child: const AppLoadingIndicator(type: LoadingType.circle),
            ),
          ),
        ],
      );
    }

    return content;
  }

  Widget _buildPagination(
    CreateCompensationPlanAssignmentEmployeesState state,
    CreateCompensationPlanAssignmentEmployeesNotifier notifier,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: PaginationControls(
        currentPage: state.currentPage,
        totalPages: state.totalPages,
        totalItems: state.totalItems,
        pageSize: state.pageSize,
        hasNext: state.hasNext,
        hasPrevious: state.hasPrevious,
        onPrevious: state.hasPrevious ? () => notifier.goToPage(state.currentPage - 1) : null,
        onNext: state.hasNext ? () => notifier.loadNextPage() : null,
        onPageTap: (page) => notifier.goToPage(page),
        showBorder: false,
        style: PaginationStyle.simple,
      ),
    );
  }

  Widget _buildActions(
    BuildContext context,
    CreateCompensationPlanAssignmentEmployeesState state,
    CreateCompensationPlanAssignmentEmployeesNotifier notifier,
  ) {
    return Padding(
      padding: EdgeInsets.all(14.w),
      child: Row(
        children: [
          TextButton(
            onPressed: _selectedIds.isEmpty ? null : () => setState(() => _selectedIds.clear()),
            child: const Text('Clear'),
          ),
          const Spacer(),
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          Gap(10.w),
          ElevatedButton(
            onPressed: _selectedIds.isEmpty
                ? null
                : () {
                    final selectedEmployees = notifier.resolveEmployeesByIds(_selectedIds);
                    context.pop(selectedEmployees);
                  },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}
