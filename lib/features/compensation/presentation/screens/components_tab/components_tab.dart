import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/enums/compensation_enums.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/compensation/presentation/providers/components/components_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/components_table_rows_provider.dart';
import 'package:grc/features/compensation/presentation/providers/components_table_selection_provider.dart';
import 'package:grc/features/compensation/presentation/providers/lookups/comp_lookups_provider.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/components_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'component_creation.dart';
import 'components_desktop_layout.dart';
import 'components_mobile_layout.dart';
import 'components_tablet_layout.dart';
import 'create_new_component_mobile_sheet.dart';

class ComponentsTab extends ConsumerStatefulWidget {
  const ComponentsTab({super.key});

  @override
  ConsumerState<ComponentsTab> createState() => _ComponentsTabState();
}

class _ComponentsTabState extends ConsumerState<ComponentsTab> with ComponentsPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(componentsTableSelectionProvider.notifier).clear();
      ref.read(componentsTabRefreshTickProvider.notifier).state++;
      ref.read(compGraphCountsProvider(CompensationLookupType.category.value));
      ref.read(compGraphCountsProvider(CompensationLookupType.calculationMethod.value));
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(componentsTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
    ref.read(componentsTableSelectionProvider.notifier).clear();
    ref.read(componentsTabRefreshTickProvider.notifier).state++;
    ref.read(compGraphCountsProvider(CompensationLookupType.category.value));
    ref.read(compGraphCountsProvider(CompensationLookupType.calculationMethod.value));
  }

  Future<void> _onCreateComponentPressed() async {
    final bool created;
    if (context.isMobileLayout) {
      created = await CreateNewComponentMobileSheet.show(context);
    } else {
      created = await context.pushNamed<bool>(ComponentCreationScreen.routeName) == true;
    }
    if (!created) return;

    ref.invalidate(componentsPageProvider);
  }

  void _onExport(AppLocalizations localizations) {
    final enterpriseId = ref.read(componentsTabEnterpriseIdProvider);
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(context, enterpriseId: enterpriseId, config: SpreadsheetExportConfigs.compComponents(localizations));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final selectedEnterpriseId = ref.watch(componentsTabEnterpriseIdProvider);
    final isExporting = ref.watch(spreadsheetExportProvider);
    final layout = context.screenLayout;
    if (!canViewComponent) {
      return AppUnauthorizedState();
    }
    if (layout.isMobile) {
      return ComponentsMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreateComponentPressed: _onCreateComponentPressed,
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    if (layout.isTablet) {
      return ComponentsTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreateComponentPressed: _onCreateComponentPressed,
        onExport: () => _onExport(localizations),
        isExporting: isExporting,
      );
    }

    return ComponentsDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onCreateComponentPressed: _onCreateComponentPressed,
      onExport: () => _onExport(localizations),
      isExporting: isExporting,
    );
  }
}
