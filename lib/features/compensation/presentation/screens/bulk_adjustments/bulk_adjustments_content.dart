import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_list_providers.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_table_selection_provider.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_tab_config.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/bulk_adjustments_tab_config.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_filter_bar.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_filter_bar_mobile.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_list_mobile.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_table_card.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/widgets/bulk_adjustment_details_section.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/widgets/bulk_adjustments_components_empty_state.dart';
import 'package:grc/features/compensation/presentation/screens/bulk_adjustments/widgets/bulk_compensation_components_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class BulkAdjustmentsContent extends ConsumerWidget {
  const BulkAdjustmentsContent({
    required this.padding,
    required this.sectionSpacing,
    required this.header,
    required this.enterpriseSelector,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final double sectionSpacing;
  final Widget header;
  final Widget enterpriseSelector;

  static final _providers = bulkAdjustmentsListProviders;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final tabState = ref.watch(_providers.tabProvider);
    final notifier = ref.read(_providers.tabProvider.notifier);
    final isMobile = context.screenLayout.isMobile;

    ref.watch(_providers.dataPageProvider);
    final rows = ref.watch(_providers.rowsProvider);
    final totalItems = ref.watch(_providers.totalItemsProvider);
    final totalPages = ref.watch(_providers.totalPagesProvider);
    final isLoading = ref.watch(_providers.isLoadingProvider);
    final error = ref.watch(_providers.errorProvider);
    final hasSelection = ref.watch(bulkAdjustmentsTableSelectionProvider).isNotEmpty;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.background,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            Gap(sectionSpacing),
            enterpriseSelector,
            Gap(sectionSpacing),
            if (isMobile)
              AdjustmentsFilterBarMobile(providers: _providers)
            else
              AdjustmentsFilterBar(providers: _providers),
            Gap(sectionSpacing),
            if (error != null)
              Center(
                child: Column(
                  children: [
                    Text('Error: $error', style: const TextStyle(color: Colors.red)),
                    const Gap(16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(_providers.dataPageProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            else ...[
              if (isMobile)
                AdjustmentsListMobile(
                  providers: _providers,
                  enableRowSelection: true,
                  pageSize: BulkAdjustmentsTabConfig.pageSize,
                )
              else
                AdjustmentsTableCard(
                  isLoading: isLoading,
                  rows: isLoading
                      ? List.generate(BulkAdjustmentsTabConfig.pageSize, (index) => AdjustmentsTabConfig.rows.first)
                      : rows,
                  totalItems: totalItems,
                  currentPage: tabState.currentPage,
                  totalPages: totalPages,
                  pageSize: BulkAdjustmentsTabConfig.pageSize,
                  onPreviousPage: tabState.currentPage > 1 ? notifier.previousPage : null,
                  onNextPage: tabState.currentPage < totalPages
                      ? () => notifier.nextPage(totalPages: totalPages)
                      : null,
                  enableRowSelection: true,
                ),
              Gap(sectionSpacing),
              if (hasSelection) ...[
                const BulkAdjustmentDetailsSection(),
                Gap(sectionSpacing),
                const BulkCompensationComponentsSection(),
              ] else
                const BulkAdjustmentsComponentsEmptyState(),
            ],
          ],
        ),
      ),
    );
  }
}
