import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_controller_provider.dart';
import 'package:grc/features/hiring/presentation/providers/candidates/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/screens/mixins/candidates_permission_mixin.dart';
import 'package:grc/features/hiring/presentation/screens/candidates_tab/candidates_desktop_layout.dart';
import 'package:grc/features/hiring/presentation/screens/candidates_tab/candidates_mobile_layout.dart';
import 'package:grc/features/hiring/presentation/screens/candidates_tab/candidates_tablet_layout.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/add_candidate_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CandidatesTab extends ConsumerStatefulWidget {
  const CandidatesTab({super.key});

  @override
  ConsumerState<CandidatesTab> createState() => _CandidatesTabState();
}

class _CandidatesTabState extends ConsumerState<CandidatesTab> with CandidatesPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(candidatesControllerProvider).refreshCandidates();
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(candidatesControllerProvider).changeEnterprise(enterpriseId);
  }

  void _onExportPressed(AppLocalizations localizations) {
    final enterpriseId = ref.read(candidatesTabEnterpriseIdProvider);
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(context, enterpriseId: enterpriseId, config: SpreadsheetExportConfigs.candidates(localizations));
  }

  void _onNewCandidatePressed() {
    AddCandidateDialog.show(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewCandidates) {
      return const AppUnauthorizedState();
    }

    final localizations = AppLocalizations.of(context)!;
    final selectedEnterpriseId = ref.watch(candidatesTabEnterpriseIdProvider);
    final isExporting = ref.watch(spreadsheetExportProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return CandidatesMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onExportPressed: () => _onExportPressed(localizations),
        isExporting: isExporting,
        onNewCandidatePressed: _onNewCandidatePressed,
      );
    }

    if (layout.isTablet) {
      return CandidatesTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onExportPressed: () => _onExportPressed(localizations),
        isExporting: isExporting,
        onNewCandidatePressed: _onNewCandidatePressed,
      );
    }

    return CandidatesDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onExportPressed: () => _onExportPressed(localizations),
      isExporting: isExporting,
      onNewCandidatePressed: _onNewCandidatePressed,
    );
  }
}
