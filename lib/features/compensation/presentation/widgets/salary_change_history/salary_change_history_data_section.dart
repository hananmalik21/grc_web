import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/compensation/presentation/providers/salary_change_history_filter_provider.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_config.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_desktop_table.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_filter_bar.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_filter_bar_mobile.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_mobile_table.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_stats_cards.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class SalaryChangeHistoryDataSection extends ConsumerWidget {
  const SalaryChangeHistoryDataSection({
    required this.onSearchChanged,
    required this.sectionSpacing,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final ValueChanged<String> onSearchChanged;
  final double sectionSpacing;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = context.screenLayout;
    final filter = ref.watch(salaryChangeHistoryFilterProvider);
    final notifier = ref.read(salaryChangeHistoryFilterProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SalaryChangeHistoryStatsCards(cards: SalaryChangeHistoryConfig.mockStats),
        Gap(sectionSpacing),
        if (layout.isMobile) ...[
          SalaryChangeHistoryFilterBarMobile(
            onSearchChanged: onSearchChanged,
            selectedStatus: filter.status,
            onStatusChanged: notifier.setStatus,
            selectedType: filter.type,
            onTypeChanged: notifier.setType,
            effectiveFrom: filter.pendingEffectiveFrom,
            effectiveTo: filter.pendingEffectiveTo,
            onEffectiveFromChanged: notifier.setPendingEffectiveFrom,
            onEffectiveToChanged: notifier.setPendingEffectiveTo,
            onApplyFilter: notifier.applyDateFilter,
            onRemoveFilter: notifier.removeDateFilter,
            onExportPressed: onExport ?? () {},
            isExporting: isExporting,
          ),
        ] else ...[
          SalaryChangeHistoryFilterBar(
            onSearchChanged: onSearchChanged,
            selectedStatus: filter.status,
            onStatusChanged: notifier.setStatus,
            selectedType: filter.type,
            onTypeChanged: notifier.setType,
            effectiveFrom: filter.pendingEffectiveFrom,
            effectiveTo: filter.pendingEffectiveTo,
            onEffectiveFromChanged: notifier.setPendingEffectiveFrom,
            onEffectiveToChanged: notifier.setPendingEffectiveTo,
            onApplyFilter: notifier.applyDateFilter,
            onRemoveFilter: notifier.removeDateFilter,
            onExportPressed: onExport ?? () {},
            isExporting: isExporting,
          ),
        ],
        Gap(sectionSpacing),
        if (layout.isMobile)
          const SalaryChangeHistoryMobileTable()
        else
          SalaryChangeHistoryDesktopTable(sectionSpacing: sectionSpacing),
      ],
    );
  }
}
