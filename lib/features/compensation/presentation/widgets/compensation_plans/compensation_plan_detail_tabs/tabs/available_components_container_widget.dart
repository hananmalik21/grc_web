import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/domain/models/components/comp_components_page.dart';
import 'package:grc/features/compensation/presentation/models/component_table_row_data.dart';
import 'package:grc/features/compensation/presentation/providers/components_table_rows_provider.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/cards/compensation_plan_detail_component_display_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AvailableComponentsContainerWidget extends ConsumerWidget {
  const AvailableComponentsContainerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final rowsAsync = ref.watch(componentsTableRowsProvider);
    final pageAsync = ref.watch(componentsPageProvider);
    final currentPage = ref.watch(componentsCurrentPageProvider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.compensation.box.path,
                width: 20.w,
                height: 20.w,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
              Gap(8.w),
              Text(
                'Available Components',
                style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ],
          ),
          Gap(16.h),
          rowsAsync.when(
            loading: () => const _AvailableComponentsLoadingState(),
            error: (err, stack) => _AvailableComponentsErrorState(error: err.toString()),
            data: (rows) => _ProviderComponentsList(rows: rows),
          ),
          Gap(24.h),
          _AvailableComponentsPaginationControls(pageAsync: pageAsync, currentPage: currentPage),
        ],
      ),
    );
  }
}

class _AvailableComponentsPaginationControls extends ConsumerWidget {
  final AsyncValue<CompComponentsPage> pageAsync;
  final int currentPage;

  const _AvailableComponentsPaginationControls({required this.pageAsync, required this.currentPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = pageAsync.valueOrNull;
    final pagination = page?.pagination;

    if (pagination == null) {
      return const SizedBox.shrink();
    }

    return PaginationControls(
      currentPage: currentPage,
      totalPages: pagination.totalPages,
      totalItems: pagination.total,
      pageSize: pagination.pageSize,
      hasNext: pagination.hasNext,
      hasPrevious: pagination.hasPrevious,
      onPrevious: currentPage > 1
          ? () => ref.read(componentsCurrentPageProvider.notifier).state = currentPage - 1
          : null,
      onNext: pagination.hasNext
          ? () => ref.read(componentsCurrentPageProvider.notifier).state = currentPage + 1
          : null,
      showBorder: true,
      style: PaginationStyle.simple,
    );
  }
}

class _AvailableComponentsErrorState extends StatelessWidget {
  final String error;

  const _AvailableComponentsErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Failed to load components: $error', style: const TextStyle(color: Colors.red)),
    );
  }
}

class _ProviderComponentsList extends StatelessWidget {
  final List<ComponentTableRowData> rows;

  const _ProviderComponentsList({required this.rows});

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Text(
          'No components found.',
          style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: rows.length,
      separatorBuilder: (context, index) => Gap(12.h),
      itemBuilder: (context, index) {
        final row = rows[index];
        return CompensationPlanDetailComponentDisplayCard(
          name: row.name,
          code: row.code,
          type: row.calculation,
          category: row.category,
          status: row.status,
          description: row.description,
        );
      },
    );
  }
}

class _AvailableComponentsLoadingState extends StatelessWidget {
  const _AvailableComponentsLoadingState();

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 4,
        separatorBuilder: (context, index) => Gap(12.h),
        itemBuilder: (context, index) {
          return const CompensationPlanDetailComponentDisplayCard(
            name: 'Component Name',
            code: 'COMP-001',
            type: 'AMOUNT',
            category: 'EARNING',
            status: 'Active',
            description: 'Loading component...',
          );
        },
      ),
    );
  }
}
