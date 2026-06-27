import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/payroll/presentation/screens/submit_payroll_flow/mixins/submit_payroll_flow_permission_mixin.dart';
import 'package:grc/features/payroll/presentation/screens/submit_payroll_flow/submit_payroll_flow_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubmitPayrollFlowTab extends ConsumerStatefulWidget {
  const SubmitPayrollFlowTab({super.key});

  @override
  ConsumerState<SubmitPayrollFlowTab> createState() => _SubmitPayrollFlowTabState();
}

class _SubmitPayrollFlowTabState extends ConsumerState<SubmitPayrollFlowTab> with SubmitPayrollFlowPermissionMixin {
  @override
  Widget build(BuildContext context) {
    if (!canViewSubmitPayrollFlow) {
      return const AppUnauthorizedState();
    }

    return SubmitPayrollFlowContent(padding: ResponsiveHelper.getScreenPadding(context));
  }
}
