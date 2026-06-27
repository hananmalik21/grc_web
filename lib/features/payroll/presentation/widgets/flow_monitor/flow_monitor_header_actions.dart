import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/features/payroll/presentation/screens/flow_monitor/mixins/flow_monitor_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlowMonitorHeaderActions extends ConsumerWidget with FlowMonitorPermissionMixin {
  const FlowMonitorHeaderActions({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;

    if (compact) {
      return Wrap(
        spacing: 10.w,
        runSpacing: 10.h,
        alignment: WrapAlignment.end,
        children: _buildMobileActions(context, loc),
      );
    }

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: _buildDesktopActions(context, loc),
    );
  }

  List<Widget> _buildDesktopActions(BuildContext context, AppLocalizations loc) {
    return [
      if (canProcessFlowMonitorTasks)
        AppButton.primary(
          label: loc.payrollFlowMonitorProcessAllTasks,
          svgPath: Assets.icons.payroll.process.path,
          onPressed: () => _onProcessAllTasks(context, loc),
        ),
      AppButton.outline(
        label: loc.payrollFlowMonitorRefreshStatus,
        svgPath: Assets.icons.refreshGray.path,
        onPressed: () => _onRefreshStatus(context, loc),
      ),
      if (canUpdateFlowMonitorTasks)
        AppButton.outline(
          label: loc.payrollFlowMonitorRetryFailedTasks,
          svgPath: Assets.icons.resetIcon.path,
          onPressed: () => _onRetryFailedTasks(context, loc),
        ),
      AppButton.outline(
        label: loc.payrollFlowMonitorExportReport,
        svgPath: Assets.icons.downloadTemplateIcon.path,
        onPressed: () => _onExportReport(context, loc),
      ),
    ];
  }

  List<Widget> _buildMobileActions(BuildContext context, AppLocalizations loc) {
    return [
      if (canProcessFlowMonitorTasks)
        AppMobileButton.primary(
          svgPath: Assets.icons.payroll.process.path,
          onPressed: () => _onProcessAllTasks(context, loc),
        ),
      AppMobileButton.outline(svgPath: Assets.icons.refreshGray.path, onPressed: () => _onRefreshStatus(context, loc)),
      if (canUpdateFlowMonitorTasks)
        AppMobileButton.outline(
          svgPath: Assets.icons.resetIcon.path,
          onPressed: () => _onRetryFailedTasks(context, loc),
        ),
      AppMobileButton.outline(svgPath: Assets.icons.exportIcon.path, onPressed: () => _onExportReport(context, loc)),
    ];
  }

  void _onProcessAllTasks(BuildContext context, AppLocalizations loc) {
    ToastService.info(context, loc.payrollFlowMonitorProcessAllTasks);
  }

  void _onRefreshStatus(BuildContext context, AppLocalizations loc) {
    ToastService.info(context, loc.payrollFlowMonitorRefreshStatus);
  }

  void _onRetryFailedTasks(BuildContext context, AppLocalizations loc) {
    ToastService.info(context, loc.payrollFlowMonitorRetryFailedTasks);
  }

  void _onExportReport(BuildContext context, AppLocalizations loc) {
    ToastService.info(context, loc.payrollFlowMonitorExportReport);
  }
}
