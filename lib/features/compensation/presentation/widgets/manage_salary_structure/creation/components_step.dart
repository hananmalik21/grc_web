import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/theme/theme_extensions.dart';
import '../../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../../core/widgets/common/pagination_controls.dart';
import '../../../../../../gen/assets.gen.dart';
import '../../../../domain/models/components/comp_components_page.dart';
import '../../../models/component_table_row_data.dart';
import '../../../providers/components_table_rows_provider.dart';
import '../../../providers/salary_structure_creation_provider.dart';
import '../../../providers/salary_structure_creation_state.dart';
import 'creation_common_widgets.dart';

class ComponentsStep extends ConsumerWidget {
  const ComponentsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(salaryStructureCreationProvider);
    final notifier = ref.read(salaryStructureCreationProvider.notifier);
    final rowsAsync = ref.watch(componentsTableRowsProvider);
    final pageAsync = ref.watch(componentsPageProvider);
    final currentPage = ref.watch(componentsCurrentPageProvider);

    return Container(
      constraints: BoxConstraints(minHeight: 600.h),
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
          Gap(24.h),
          rowsAsync.when(
            loading: () => const ComponentsLoadingState(),
            error: (err, stack) => _buildErrorState(isDark, err.toString()),
            data: (rows) => _buildComponentsList(isDark, state, notifier, rows),
          ),
          Gap(24.h),
          _buildPaginationControls(ref, pageAsync, currentPage),
        ],
      ),
    );
  }

  Widget _buildPaginationControls(WidgetRef ref, AsyncValue<CompComponentsPage> pageAsync, int currentPage) {
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

  Widget _buildErrorState(bool isDark, String error) {
    return Center(
      child: Text('Failed to load components: $error', style: TextStyle(color: Colors.red)),
    );
  }

  Widget _buildComponentsList(
    bool isDark,
    SalaryStructureCreationState state,
    dynamic notifier,
    List<ComponentTableRowData> rows,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rows.length,
      separatorBuilder: (context, index) => Gap(12.h),
      itemBuilder: (context, index) {
        final row = rows[index];
        return CreationComponentCard(
          name: row.name,
          code: row.code,
          type: row.calculation,
          category: row.category,
          status: row.status,
          description: row.description,
          isSelected: state.selectedComponentCodes.contains(row.code),
          onChanged: (val) => notifier.toggleComponent(row.code, component: row.component),
        );
      },
    );
  }
}

class ComponentsLoadingState extends StatelessWidget {
  const ComponentsLoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (context, index) => Gap(12.h),
        itemBuilder: (context, index) {
          return CreationComponentCard(
            name: 'Component Name',
            code: 'COMP-001',
            type: 'AMOUNT',
            category: 'EARNING',
            status: 'Active',
            description: 'Loading component...',
            isSelected: false,
            onChanged: (val) {},
          );
        },
      ),
    );
  }
}
