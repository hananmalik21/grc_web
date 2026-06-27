import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/features/payroll/application/payroll/providers/payroll_tab_state_provider.dart';
import 'package:grc/features/payroll/application/submit_payroll_flow/providers/submit_payroll_flow_provider.dart';
import 'package:grc/features/payroll/presentation/screens/submit_payroll_flow/mixins/submit_payroll_flow_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubmitPayrollFlowHeaderActions extends ConsumerWidget with SubmitPayrollFlowPermissionMixin {
  const SubmitPayrollFlowHeaderActions({this.compact = false, super.key});

  final bool compact;

  static const _buttonHeight = 44.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;

    if (compact) {
      return Wrap(
        spacing: 12.w,
        runSpacing: 12.h,
        alignment: WrapAlignment.end,
        children: [
          AppMobileButton.outline(svgPath: Assets.icons.closeIcon.path, onPressed: () => _onCancel(ref)),
          if (canSubmitPayrollFlow)
            AppMobileButton.primary(
              svgPath: Assets.icons.arrowRightIcon.path,
              onPressed: () => _onReviewSubmit(context, ref),
            ),
        ],
      );
    }

    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppButton.outline(
          label: loc.cancel,
          svgPath: Assets.icons.closeIcon.path,
          height: _buttonHeight,
          onPressed: () => _onCancel(ref),
        ),
        if (canSubmitPayrollFlow)
          AppButton.primary(
            label: loc.payrollSubmitPayrollFlowReviewSubmit,
            height: _buttonHeight,
            onPressed: () => _onReviewSubmit(context, ref),
          ),
      ],
    );
  }

  void _onCancel(WidgetRef ref) {
    ref.read(payrollTabStateProvider.notifier).setTabIndex(0);
  }

  void _onReviewSubmit(BuildContext context, WidgetRef ref) {
    ref.read(submitPayrollFlowProvider.notifier).goToReviewStep();
    ToastService.info(context, AppLocalizations.of(context)!.payrollSubmitPayrollFlowReviewSubmit);
  }
}
