import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/mixins/overtime_configuration_permission_mixin.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/overtime_configuration_desktop_layout.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/overtime_configuration_mobile_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/overtime_configuration/overtime_configuration_enterprise_provider.dart';
import '../providers/overtime_configuration/overtime_configuration_provider.dart';

class OvertimeConfigurationScreen extends ConsumerStatefulWidget {
  const OvertimeConfigurationScreen({super.key});

  @override
  ConsumerState<OvertimeConfigurationScreen> createState() => _OvertimeConfigurationScreenState();
}

class _OvertimeConfigurationScreenState extends ConsumerState<OvertimeConfigurationScreen>
    with OvertimeConfigurationPermissionMixin {
  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(overtimeConfigurationSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveEnterpriseId = ref.watch(overtimeConfigurationEnterpriseIdProvider);
    final isLoading = ref.watch(overtimeConfigurationProvider.select((state) => state.isLoading));
    final layout = context.screenLayout;

    if (!canViewOvertimeConfiguration) return const AppUnauthorizedState();

    if (layout.isMobile) {
      return OvertimeConfigurationMobileLayout(
        selectedEnterpriseId: effectiveEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onSave: () => _handleSubmit(ref),
        isLoading: isLoading,
      );
    }

    return OvertimeConfigurationDesktopLayout(
      selectedEnterpriseId: effectiveEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onSave: () => _handleSubmit(ref),
      isLoading: isLoading,
    );
  }

  Future<void> _handleSubmit(WidgetRef ref) async {
    final notifier = ref.read(overtimeConfigurationProvider.notifier);

    try {
      await notifier.saveOvertimeConfiguration();
      if (!mounted) return;
      ToastService.success(context, 'Overtime Configuration saved successfully.');
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, 'Failed to save overtime configuration. Please try again.');
    }
  }
}
