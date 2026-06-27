import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_item.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/create_compensation_plan/create_compensation_plan_salary_structures_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SalaryStructureSelection extends ConsumerWidget {
  final int? selectedId;
  final String? selectedValue;
  final ValueChanged<SalaryStructureItem?> onChanged;

  const SalaryStructureSelection({
    super.key,
    required this.selectedId,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageAsync = ref.watch(createCompensationPlanSalaryStructuresPageProvider);
    final items = pageAsync.valueOrNull?.items ?? const <SalaryStructureItem>[];
    final isLoading = pageAsync.isLoading && items.isEmpty;
    final errorMessage = pageAsync.hasError ? pageAsync.error.toString() : null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DigifyAsset(
                assetPath: Assets.icons.compensation.layers.path,
                width: 20.w,
                height: 20.w,
                color: AppColors.primary,
              ),
              Gap(12.w),
              Text(
                'Add Salary Structure',
                style: context.textTheme.labelLarge?.copyWith(fontSize: 14.sp, color: AppColors.textPrimary),
              ),
              Text(
                ' *',
                style: context.textTheme.labelLarge?.copyWith(fontSize: 14.sp, color: AppColors.error),
              ),
            ],
          ),
          Gap(10.h),
          Padding(
            padding: EdgeInsets.only(left: 32.w),
            child: Text(
              'Select a salary structure to auto-populate its components into this plan',
              style: context.textTheme.labelSmall?.copyWith(color: AppColors.grayText, fontSize: 12.sp),
            ),
          ),
          Gap(18.h),
          Padding(
            padding: EdgeInsets.only(left: 32.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 780.w),
              child: _SalaryStructureSelectField(
                value: selectedValue,
                isLoading: isLoading,
                errorMessage: errorMessage,
                onTap: () => _showSelectionDialog(context, ref),
                onClear: () => onChanged(null),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showSelectionDialog(BuildContext context, WidgetRef ref) async {
    final liveDialog = Consumer(
      builder: (context, ref, _) {
        final pageAsync = ref.watch(createCompensationPlanSalaryStructuresPageProvider);
        final page = pageAsync.valueOrNull;
        final items = page?.items ?? const <SalaryStructureItem>[];
        final pagination = page?.pagination;
        return DigifySingleSelectDialog<SalaryStructureItem>(
          title: 'Select Salary Structure',
          subtitle: pagination == null
              ? 'Choose one salary structure to load plan components'
              : '${pagination.total} available salary structures',
          items: items,
          selectedId: selectedId?.toString(),
          idBuilder: (item) => item.structureId.toString(),
          labelBuilder: (item) => item.structureName,
          descriptionBuilder: (item) => '${item.structureCode} • ${item.uiType} • ${item.uiLocation}',
          searchHint: 'Search salary structure...',
          emptyMessage: 'No salary structures found',
          headerIcon: Icons.account_tree_rounded,
          isLoading: pageAsync.isLoading,
          errorMessage: pageAsync.hasError ? pageAsync.error.toString() : null,
          onRetry: () => ref.invalidate(createCompensationPlanSalaryStructuresPageProvider),
          pagination: pagination == null
              ? null
              : DigifySingleSelectPagination(
                  currentPage: pagination.page,
                  totalPages: pagination.totalPages,
                  totalItems: pagination.total,
                  pageSize: pagination.pageSize,
                  hasNext: pagination.hasNext,
                  hasPrevious: pagination.hasPrevious,
                ),
          onPreviousPage: pagination != null && pagination.hasPrevious
              ? () {
                  ref.read(createCompensationPlanSalaryStructuresCurrentPageProvider.notifier).state =
                      pagination.page - 1;
                }
              : null,
          onNextPage: pagination != null && pagination.hasNext
              ? () {
                  ref.read(createCompensationPlanSalaryStructuresCurrentPageProvider.notifier).state =
                      pagination.page + 1;
                }
              : null,
          onPageTap: pagination != null
              ? (page) {
                  ref.read(createCompensationPlanSalaryStructuresCurrentPageProvider.notifier).state = page;
                }
              : null,
          onClearAndClose: () {
            onChanged(null);
            context.pop();
          },
        );
      },
    );

    final selected = await DigifySingleSelectDialog.showAdaptive<SalaryStructureItem>(
      context: context,
      child: liveDialog,
      barrierDismissible: false,
    );

    if (selected != null) {
      onChanged(selected);
    }
  }
}

class _SalaryStructureSelectField extends StatelessWidget {
  final String? value;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _SalaryStructureSelectField({
    required this.value,
    required this.isLoading,
    required this.errorMessage,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: errorMessage != null ? AppColors.error : AppColors.cardBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasValue ? value! : 'Select salary structure...',
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: hasValue ? AppColors.textPrimary : AppColors.textPlaceholder,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isLoading) ...[
                  Gap(4.w),
                  AppLoadingIndicator(size: 16.w),
                  Gap(4.w),
                ] else ...[
                  Gap(4.w),
                  DigifyAsset(
                    assetPath: Assets.icons.workforce.chevronRight.path,
                    width: 20.w,
                    height: 20.w,
                    color: AppColors.textSecondary,
                  ),
                ],
              ],
            ),
          ),
        ),
        if (errorMessage != null) ...[
          Gap(6.h),
          Text(
            'Failed to load salary structures. Tap to retry.',
            style: context.textTheme.labelSmall?.copyWith(color: AppColors.error),
          ),
        ],
      ],
    );
  }
}
