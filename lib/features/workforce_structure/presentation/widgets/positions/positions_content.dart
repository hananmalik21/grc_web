import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/workforce_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/common/workforce_stats_cards.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/positions_actions_mixin.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/positions_filter_bar_mobile.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/positions_list_mobile.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/workforce_positions_table.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/workforce_search_and_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class PositionsContent extends ConsumerStatefulWidget {
  const PositionsContent({
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
  ConsumerState<PositionsContent> createState() => _PositionsContentState();
}

class _PositionsContentState extends ConsumerState<PositionsContent> with PositionsActionsMixin {
  void _onExport(AppLocalizations localizations) {
    final enterpriseId = ref.read(positionsEnterpriseIdProvider);
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(context, enterpriseId: enterpriseId, config: SpreadsheetExportConfigs.positions(localizations));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = context.screenLayout.isMobile;
    final positionState = ref.watch(positionNotifierProvider);
    final isExporting = ref.watch(spreadsheetExportProvider);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.background,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: widget.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.header,
            Gap(widget.sectionSpacing),
            widget.enterpriseSelector,
            Gap(widget.sectionSpacing),
            WorkforceStatsCards(localizations: localizations, isDark: isDark),
            Gap(widget.sectionSpacing),
            if (isMobile)
              WorkforcePositionsFilterBarMobile(
                localizations: localizations,
                isDark: isDark,
                onExport: () => _onExport(localizations),
                isExporting: isExporting,
              )
            else
              WorkforceSearchAndActions(
                localizations: localizations,
                isDark: isDark,
                onExport: () => _onExport(localizations),
                isExporting: isExporting,
              ),
            Gap(widget.sectionSpacing),
            if (positionState.hasError && positionState.items.isEmpty && !positionState.isLoading)
              DigifyErrorState(
                message: positionState.errorMessage ?? localizations.somethingWentWrong,
                retryLabel: localizations.retry,
                onRetry: () => ref.read(positionNotifierProvider.notifier).refresh(),
              )
            else
              isMobile
                  ? WorkforcePositionsListMobile(
                      localizations: localizations,
                      positions: positionState.items,
                      isDark: isDark,
                      isLoading: positionState.isLoading,
                      onView: (position) => showPositionDetailsDialog(context, position),
                      onEdit: (position) => showPositionFormDialog(context, position, true),
                      onDelete: (position) => showDeleteConfirmation(position),
                    )
                  : WorkforcePositionsTable(
                      localizations: localizations,
                      positions: positionState.items,
                      isDark: isDark,
                      isLoading: positionState.isLoading,
                      onView: (position) => showPositionDetailsDialog(context, position),
                      onEdit: (position) => showPositionFormDialog(context, position, true),
                      onDelete: (position) => showDeleteConfirmation(position),
                    ),
          ],
        ),
      ),
    );
  }
}
