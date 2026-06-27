import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/positions_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/screens/positions/positions_desktop_layout.dart';
import 'package:grc/features/workforce_structure/presentation/screens/positions/positions_mobile_layout.dart';
import 'package:grc/features/workforce_structure/presentation/screens/positions/positions_permission_mixin.dart';
import 'package:grc/features/workforce_structure/presentation/screens/positions/positions_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PositionsTab extends ConsumerStatefulWidget {
  const PositionsTab({super.key});

  @override
  ConsumerState<PositionsTab> createState() => _PositionsTabState();
}

class _PositionsTabState extends ConsumerState<PositionsTab> with PositionsPermissionMixin {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(positionNotifierProvider.notifier).refresh());
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(positionsSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  @override
  Widget build(BuildContext context) {
    final selectedEnterpriseId = ref.watch(positionsEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (!canViewPosition) return const AppUnauthorizedState();

    if (layout.isMobile) {
      return PositionsMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    if (layout.isTablet) {
      return PositionsTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    return PositionsDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
    );
  }
}
