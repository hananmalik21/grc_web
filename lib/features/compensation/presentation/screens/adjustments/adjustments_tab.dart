import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_tab_provider.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_permission_mixin.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/create_salary_adjustment_mobile_sheet.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/create_salary_adjustment_page.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_desktop_layout.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_mobile_layout.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdjustmentsTab extends ConsumerStatefulWidget {
  const AdjustmentsTab({super.key});

  @override
  ConsumerState<AdjustmentsTab> createState() => _AdjustmentsTabState();
}

class _AdjustmentsTabState extends ConsumerState<AdjustmentsTab> with AdjustmentsPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.invalidate(adjustmentsDataPageProvider);
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(adjustmentsTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  Future<void> _onCreatePressed() async {
    final layout = context.screenLayout;
    if (layout.isMobile || layout.isTabletSmall) {
      await CreateSalaryAdjustmentMobileSheet.show(context);
      return;
    }
    await context.pushNamed(CreateSalaryAdjustmentPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final selectedEnterpriseId = ref.watch(adjustmentsTabEnterpriseIdProvider);
    final layout = context.screenLayout;
    if (!canViewAdjustment) return AppUnauthorizedState();

    if (layout.isMobile) {
      return AdjustmentsMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
      );
    }

    if (layout.isTablet) {
      return AdjustmentsTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
      );
    }

    return AdjustmentsDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onCreatePressed: _onCreatePressed,
    );
  }
}
