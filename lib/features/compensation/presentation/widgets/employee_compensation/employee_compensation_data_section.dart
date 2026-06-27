import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_error_banner.dart';
import 'package:grc/features/compensation/presentation/providers/employees/employee_compensation_list_provider.dart';
import 'package:grc/features/compensation/presentation/widgets/mobile/employee_compensation_filter_bar_mobile.dart';
import 'package:grc/features/compensation/presentation/widgets/mobile/employee_compensation_list_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import 'employee_compensation_filter_bar.dart';
import 'employee_compensation_skeleton.dart';
import 'employee_compensation_stat_grid.dart';
import 'employee_compensation_table.dart';

class EmployeeCompensationDataSection extends ConsumerWidget {
  const EmployeeCompensationDataSection({
    required this.searchController,
    required this.sectionSpacing,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final TextEditingController searchController;
  final double sectionSpacing;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return _MobileLayout(
        searchController: searchController,
        sectionSpacing: sectionSpacing,
        onExport: onExport,
        isExporting: isExporting,
      );
    }

    return _DesktopLayout(
      searchController: searchController,
      sectionSpacing: sectionSpacing,
      onExport: onExport,
      isExporting: isExporting,
    );
  }
}

class _MobileLayout extends ConsumerWidget {
  const _MobileLayout({
    required this.searchController,
    required this.sectionSpacing,
    this.onExport,
    this.isExporting = false,
  });

  final TextEditingController searchController;
  final double sectionSpacing;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalItems = ref.watch(employeeCompensationTotalItemsProvider);
    final errorMessage = ref.watch(employeeCompensationErrorProvider);
    final actions = ref.read(employeeCompensationListActionsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmployeeCompensationStatGrid(totalEmployees: totalItems),
        Gap(sectionSpacing),
        EmployeeCompensationFilterBarMobile(
          searchController: searchController,
          onSearchChanged: actions.updateSearch,
          selectedDepartment: 'All',
          selectedRegion: 'All',
          departmentOptions: const ['All'],
          regionOptions: const ['All'],
          onDepartmentChanged: (_) {},
          onRegionChanged: (_) {},
          onExportPressed: onExport ?? () {},
          isExporting: isExporting,
        ),
        Gap(sectionSpacing),
        if (errorMessage != null) ...[
          AppErrorBanner(message: errorMessage, onRetry: actions.refresh),
          Gap(sectionSpacing),
        ],
        const EmployeeCompensationListMobile(),
      ],
    );
  }
}

class _DesktopLayout extends ConsumerWidget {
  const _DesktopLayout({
    required this.searchController,
    required this.sectionSpacing,
    this.onExport,
    this.isExporting = false,
  });

  final TextEditingController searchController;
  final double sectionSpacing;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalItems = ref.watch(employeeCompensationTotalItemsProvider);
    final errorMessage = ref.watch(employeeCompensationErrorProvider);
    final isLoading = ref.watch(employeeCompensationIsLoadingProvider);
    final currentPage = ref.watch(employeeCompensationListCurrentPageProvider);
    final totalPages = ref.watch(employeeCompensationTotalPagesProvider);
    final hasNext = ref.watch(employeeCompensationHasNextProvider);
    final hasPrevious = ref.watch(employeeCompensationHasPreviousProvider);
    final items = ref.watch(employeeCompensationListItemsProvider);
    final rows = items.map((item) => item.toTableRowData()).toList();
    final actions = ref.read(employeeCompensationListActionsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmployeeCompensationStatGrid(totalEmployees: totalItems),
        Gap(sectionSpacing),
        EmployeeCompensationFilterBar(
          searchController: searchController,
          onSearchChanged: actions.updateSearch,
          selectedDepartment: 'All',
          selectedRegion: 'All',
          departmentOptions: const ['All'],
          regionOptions: const ['All'],
          onDepartmentChanged: (_) {},
          onRegionChanged: (_) {},
          onExportPressed: onExport ?? () {},
          isExporting: isExporting,
        ),
        Gap(sectionSpacing),
        if (errorMessage != null) ...[
          AppErrorBanner(message: errorMessage, onRetry: actions.refresh),
          Gap(sectionSpacing),
        ],
        EmployeeCompensationTable(
          rows: isLoading ? EmployeeCompensationSkeleton.rows : rows,
          isLoading: isLoading,
          currentPage: currentPage,
          totalPages: totalPages,
          totalItems: totalItems,
          pageSize: 10,
          onPreviousPage: hasPrevious ? actions.previousPage : null,
          onNextPage: hasNext ? actions.nextPage : null,
        ),
      ],
    );
  }
}
