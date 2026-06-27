import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/time_management/presentation/providers/public_holidays_provider.dart';
import 'package:grc/features/time_management/presentation/providers/public_holidays_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_stats_providers.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/dialogs/create_holiday_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/public_holidays_desktop_layout.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/public_holidays_mobile_layout.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/public_holidays_permission_mixin.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/public_holidays_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PublicHolidaysTab extends ConsumerStatefulWidget {
  const PublicHolidaysTab({super.key});

  @override
  ConsumerState<PublicHolidaysTab> createState() => _PublicHolidaysTabState();
}

class _PublicHolidaysTabState extends ConsumerState<PublicHolidaysTab> with PublicHolidaysPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final enterpriseId = ref.read(publicHolidaysTabEnterpriseIdProvider);
      if (enterpriseId != null) {
        ref.read(publicHolidaysNotifierProvider(enterpriseId).notifier).refresh();
        ref.read(timeManagementStatsNotifierProvider.notifier).refresh();
      }
    });
  }

  void _onCreatePressed() {
    final enterpriseId = ref.read(publicHolidaysTabEnterpriseIdProvider);
    if (enterpriseId == null) return;
    CreateHolidayDialog.show(context, enterpriseId: enterpriseId);
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(publicHolidaysTabSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  @override
  Widget build(BuildContext context) {
    if (!canViewPublicHoliday) return const AppUnauthorizedState();

    final selectedEnterpriseId = ref.watch(publicHolidaysTabEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (layout.isMobile) {
      return PublicHolidaysMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
      );
    }
    if (layout.isTablet) {
      return PublicHolidaysTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreatePressed: _onCreatePressed,
      );
    }
    return PublicHolidaysDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onCreatePressed: _onCreatePressed,
    );
  }
}
