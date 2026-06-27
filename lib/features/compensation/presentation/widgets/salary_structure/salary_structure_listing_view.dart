import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/empty_state_widget.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_item.dart';
import 'package:grc/features/compensation/presentation/screens/manage_salary_structure_tab/edit_salary_structure.dart';
import 'package:grc/features/compensation/presentation/screens/manage_salary_structure_tab/edit_salary_structure_mobile_sheet.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../providers/salary_structure_listing_provider.dart';
import 'salary_structure_grid.dart';
import 'salary_structure_listing_skeleton.dart';

class SalaryStructureListingView extends ConsumerWidget {
  const SalaryStructureListingView({super.key});

  void _handleView(BuildContext context, SalaryStructureItem item) {
    ToastService.info(context, 'Viewing ${item.uiName}', title: 'View');
  }

  Future<void> _handleEdit(BuildContext context, WidgetRef ref, SalaryStructureItem item) async {
    if (context.isMobileLayout) {
      final saved = await EditSalaryStructureMobileSheet.show(context, structureGuid: item.structureGuid);
      if (saved && context.mounted) {
        ref.read(salaryStructuresCurrentPageProvider.notifier).state = salaryStructuresDefaultPage;
        ref.read(salaryStructuresRefreshTickProvider.notifier).state += 1;
      }
    } else {
      context.pushNamed(SalaryStructureEditScreen.routeName, pathParameters: {'structureGuid': item.structureGuid});
    }
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref, SalaryStructureItem item) async {
    final confirmed = await DeleteConfirmationDialog.show(
      context,
      title: 'Delete Salary Structure',
      message: 'Are you sure you want to delete this salary structure? This action cannot be undone.',
      itemName: item.uiName,
    );

    if (confirmed != true) return;

    final deletingNotifier = ref.read(salaryStructureDeletingGuidProvider.notifier);
    deletingNotifier.state = item.structureGuid;

    try {
      final repository = ref.read(salaryStructureRepositoryProvider);
      await repository.deleteSalaryStructure(structureGuid: item.structureGuid);

      if (context.mounted) {
        ToastService.success(context, '${item.uiName} deleted successfully', title: 'Deleted');
      }
      ref.read(salaryStructuresRefreshTickProvider.notifier).state += 1;
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, 'Failed to delete ${item.uiName}', title: 'Error');
      }
    } finally {
      deletingNotifier.state = null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageAsync = ref.watch(salaryStructuresPageProvider);
    final items = ref.watch(salaryStructuresItemsProvider);
    final deletingGuid = ref.watch(salaryStructureDeletingGuidProvider);

    return pageAsync.when(
      loading: () => const SalaryStructureListingSkeleton(),
      error: (error, stackTrace) => _SalaryStructureListingError(
        message: error.toString(),
        onRetry: () => ref.read(salaryStructuresRefreshTickProvider.notifier).state += 1,
      ),
      data: (page) {
        final pagination = page.pagination;
        final currentPage = pagination?.page ?? salaryStructuresDefaultPage;
        final pageSize = pagination?.pageSize ?? salaryStructuresDefaultPageSize;
        final totalItems = pagination?.total ?? items.length;
        final totalPages = pagination?.totalPages ?? 1;

        if (items.isEmpty) {
          final isMobile = context.screenLayout.isMobile;
          final isDark = context.isDark;

          if (isMobile) {
            return MobileStateCard(
              isDark: isDark,
              borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
              iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
              iconPath: Assets.icons.compensation.layers.path,
              title: 'No Salary Structures Found',
              subtitle: 'There are no salary structures matching your criteria.',
            );
          }

          return EmptyStateWidget(
            iconPath: Assets.icons.compensation.layers.path,
            title: 'No Salary Structures Found',
            message: 'There are no salary structures matching your criteria.',
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SalaryStructureGrid(
              items: items,
              onView: (item) => _handleView(context, item),
              onEdit: (item) => _handleEdit(context, ref, item),
              onDelete: (item) => _handleDelete(context, ref, item),
              deletingGuid: deletingGuid,
            ),
            Gap(24.h),
            PaginationControls(
              currentPage: currentPage,
              totalPages: totalPages,
              totalItems: totalItems,
              pageSize: pageSize,
              hasNext: pagination?.hasNext ?? false,
              hasPrevious: pagination?.hasPrevious ?? false,
              onPrevious: (pagination?.hasPrevious ?? false)
                  ? () => ref.read(salaryStructuresCurrentPageProvider.notifier).state = currentPage - 1
                  : null,
              onNext: (pagination?.hasNext ?? false)
                  ? () => ref.read(salaryStructuresCurrentPageProvider.notifier).state = currentPage + 1
                  : null,
              style: PaginationStyle.simple,
            ),
          ],
        );
      },
    );
  }
}

class _SalaryStructureListingError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _SalaryStructureListingError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Failed to load salary structures.'),
          Gap(8.h),
          Text(message, maxLines: 2, overflow: TextOverflow.ellipsis),
          Gap(12.h),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
