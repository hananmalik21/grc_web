import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/payroll/application/submit_payroll_flow/config/submit_payroll_flow_config.dart';
import 'package:grc/features/payroll/application/submit_payroll_flow/providers/submit_payroll_flow_provider.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_form_row.dart';
import 'package:grc/features/payroll/presentation/widgets/submit_payroll_flow/submit_payroll_flow_section_header.dart';
import 'package:grc/features/payroll/presentation/widgets/submit_payroll_flow/submit_payroll_flow_step_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class FlowDetailsStep extends ConsumerWidget {
  const FlowDetailsStep({super.key});

  static const _flowInfoColumns = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(submitPayrollFlowProvider);
    final controller = ref.read(submitPayrollFlowProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubmitPayrollFlowSectionHeader(
          title: loc.payrollSubmitPayrollFlowFlowInformation,
          subtitle: loc.payrollSubmitPayrollFlowFlowInformationSubtitle,
        ),
        Gap(20.h),
        AddElementFormRow(
          columns: _flowInfoColumns,
          children: [
            DigifySelectFieldWithLabel<String>(
              label: loc.payrollSubmitPayrollFlowPayrollFlow,
              hint: loc.payrollSubmitPayrollFlowSelectPayrollFlow,
              isRequired: true,
              value: state.payrollFlow,
              items: SubmitPayrollFlowConfig.payrollFlowOptions,
              itemLabelBuilder: (value) => value,
              onChanged: controller.setPayrollFlow,
            ),
            DigifySelectFieldWithLabel<String>(
              label: loc.payrollSubmitPayrollFlowSchedule,
              isRequired: true,
              value: state.schedule,
              items: SubmitPayrollFlowConfig.scheduleOptions,
              itemLabelBuilder: (value) => SubmitPayrollFlowConfig.scheduleLabel(loc, value),
              onChanged: (value) {
                if (value != null) controller.setSchedule(value);
              },
            ),
          ],
        ),
        Gap(25.h),
        SubmitPayrollFlowStepFooter(primaryLabel: loc.next, onPrimaryPressed: controller.goToParametersStep),
      ],
    );
  }
}
