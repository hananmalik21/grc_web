import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/payroll/presentation/widgets/submit_payroll_flow/submit_payroll_flow_header_actions.dart';
import 'package:flutter/material.dart';

class SubmitPayrollFlowHeader extends StatelessWidget {
  const SubmitPayrollFlowHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isMobile = context.screenLayout.isMobile;

    if (isMobile) {
      return DigifyMobileTabHeader(
        title: loc.payrollSubmitPayrollFlow,
        trailing: const SubmitPayrollFlowHeaderActions(compact: true),
      );
    }

    return DigifyTabHeader(
      title: loc.payrollSubmitPayrollFlow,
      description: loc.payrollSubmitPayrollFlowSubtitle,
      trailing: const SubmitPayrollFlowHeaderActions(),
    );
  }
}
