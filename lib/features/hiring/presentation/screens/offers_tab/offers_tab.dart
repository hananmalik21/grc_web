import 'package:grc/core/config/spreadsheet_export_configs.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/providers/spreadsheet_export_provider.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/hiring/presentation/providers/offers/offers_filter_provider.dart';
import 'package:grc/features/hiring/presentation/providers/offers/offers_list_provider.dart';
import 'package:grc/features/hiring/presentation/providers/offers/offers_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/screens/mixins/offers_permission_mixin.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/offers_desktop_layout.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/offers_mobile_layout.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/offers_tablet_layout.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/create_offer_mobile_sheet.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/create_offer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OffersTab extends ConsumerStatefulWidget {
  const OffersTab({super.key});

  @override
  ConsumerState<OffersTab> createState() => _OffersTabState();
}

class _OffersTabState extends ConsumerState<OffersTab> with OffersPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(offersTabRefreshTickProvider.notifier).state++;
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(offersTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
    ref.read(offersFilterProvider.notifier).reset();
    ref.read(offersShowFiltersProvider.notifier).state = false;
    ref.read(offersTabRefreshTickProvider.notifier).state++;
  }

  void _onCreateOfferPressed() {
    if (context.screenLayout.isMobile) {
      CreateOfferMobileSheet.show(context);
      return;
    }
    context.pushNamed(CreateOfferScreen.routeName);
  }

  void _onExportPressed(AppLocalizations localizations) {
    final enterpriseId = ref.read(offersTabEnterpriseIdProvider);
    ref
        .read(spreadsheetExportProvider.notifier)
        .export(context, enterpriseId: enterpriseId, config: SpreadsheetExportConfigs.jobOffers(localizations));
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewOffers) {
      return const AppUnauthorizedState();
    }

    ref.watch(offersPageProvider);

    final localizations = AppLocalizations.of(context)!;
    final selectedEnterpriseId = ref.watch(offersTabEnterpriseIdProvider);
    final isExporting = ref.watch(spreadsheetExportProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return OffersMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreateOfferPressed: _onCreateOfferPressed,
        onExportPressed: () => _onExportPressed(localizations),
        isExporting: isExporting,
      );
    }

    if (layout.isTablet) {
      return OffersTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreateOfferPressed: _onCreateOfferPressed,
        onExportPressed: () => _onExportPressed(localizations),
        isExporting: isExporting,
      );
    }

    return OffersDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onCreateOfferPressed: _onCreateOfferPressed,
      onExportPressed: () => _onExportPressed(localizations),
      isExporting: isExporting,
    );
  }
}
