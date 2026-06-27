import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/enterprise_stats_providers.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/manage_enterprise_structure_enterprise_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_level_providers.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_enterprise_structure/manage_enterprise_structure_desktop_layout.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_enterprise_structure/manage_enterprise_structure_mobile_layout.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_enterprise_structure/manage_enterprise_structure_permission_mixin.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_enterprise_structure/manage_enterprise_structure_tablet_layout.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/dialogs/enterprise_structure_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ManageEnterpriseStructureScreen extends ConsumerStatefulWidget {
  const ManageEnterpriseStructureScreen({super.key});

  @override
  ConsumerState<ManageEnterpriseStructureScreen> createState() => _ManageEnterpriseStructureScreenState();
}

class _ManageEnterpriseStructureScreenState extends ConsumerState<ManageEnterpriseStructureScreen>
    with ManageEnterpriseStructurePermissionMixin {
  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(manageEnterpriseStructureSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  Future<void> _onCreateStructurePressed() async {
    final localizations = AppLocalizations.of(context)!;
    final enterpriseId = ref.read(manageEnterpriseStructureEnterpriseIdProvider);
    if (enterpriseId == null) {
      ToastService.warning(context, localizations.selectEnterpriseFirst);
      return;
    }
    final bool created;
    if (context.isMobileLayout) {
      created = await EnterpriseStructureDialog.showCreateMobile(
        context,
        provider: manageEnterpriseStructureStructureListProvider,
      );
    } else {
      created =
          await EnterpriseStructureDialog.showCreate(
            context,
            provider: manageEnterpriseStructureStructureListProvider,
          ) ==
          true;
    }
    if (created) {
      ref.read(manageEnterpriseStructureStructureListProvider.notifier).refresh();
      ref.read(enterpriseStatsNotifierProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewStructure) return AppUnauthorizedState();

    final selectedEnterpriseId = ref.watch(manageEnterpriseStructureEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return ManageEnterpriseStructureMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreateStructurePressed: _onCreateStructurePressed,
      );
    }

    if (layout.isTablet) {
      return ManageEnterpriseStructureTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreateStructurePressed: _onCreateStructurePressed,
      );
    }

    return ManageEnterpriseStructureDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onCreateStructurePressed: _onCreateStructurePressed,
    );
  }
}
