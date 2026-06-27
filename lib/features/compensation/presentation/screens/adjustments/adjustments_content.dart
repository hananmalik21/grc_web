import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_tab_provider.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_tab_config.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_filter_bar.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_filter_bar_mobile.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_list_mobile.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_stats_section.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_table_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class AdjustmentsContent extends ConsumerWidget {
  const AdjustmentsContent({
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final tabState = ref.watch(adjustmentsTabProvider);
    final notifier = ref.read(adjustmentsTabProvider.notifier);
    final isMobile = context.screenLayout.isMobile;

    ref.watch(adjustmentsDataPageProvider);
    final rows = ref.watch(adjustmentsRowsProvider);
    final totalItems = ref.watch(adjustmentsTotalItemsProvider);
    final totalPages = ref.watch(adjustmentsTotalPagesProvider);
    final isLoading = ref.watch(adjustmentsIsLoadingProvider);
    final error = ref.watch(adjustmentsErrorProvider);

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
            AdjustmentsStatsSection(),
            Gap(sectionSpacing),
            if (isMobile) AdjustmentsFilterBarMobile() else AdjustmentsFilterBar(),
            Gap(sectionSpacing),
            if (error != null)
              Center(
                child: Column(
                  children: [
                    Text('Error: $error', style: const TextStyle(color: Colors.red)),
                    const Gap(16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(adjustmentsDataPageProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            else if (isMobile)
              AdjustmentsListMobile()
            else
              AdjustmentsTableCard(
                isLoading: isLoading,
                rows: isLoading
                    ? List.generate(AdjustmentsTabConfig.pageSize, (index) => AdjustmentsTabConfig.rows.first)
                    : rows,
                totalItems: totalItems,
                currentPage: tabState.currentPage,
                totalPages: totalPages,
                pageSize: AdjustmentsTabConfig.pageSize,
                onPreviousPage: tabState.currentPage > 1 ? notifier.previousPage : null,
                onNextPage: tabState.currentPage < totalPages ? () => notifier.nextPage(totalPages: totalPages) : null,
              ),
          ],
        ),
      ),
    );
  }
}
