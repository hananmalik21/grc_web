import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/payroll/application/submit_payroll_flow/config/submit_payroll_flow_config.dart';
import 'package:grc/features/payroll/application/submit_payroll_flow/providers/submit_payroll_flow_provider.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_form_row.dart';
import 'package:grc/features/payroll/presentation/widgets/submit_payroll_flow/submit_payroll_flow_section_header.dart';
import 'package:grc/features/payroll/presentation/widgets/submit_payroll_flow/submit_payroll_flow_step_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ParametersStep extends ConsumerWidget {
  const ParametersStep({super.key});

  static const _desktopColumns = 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(submitPayrollFlowProvider);
    final controller = ref.read(submitPayrollFlowProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SubmitPayrollFlowSectionHeader(
          title: loc.payrollSubmitPayrollFlowRequiredParameters,
          subtitle: loc.payrollSubmitPayrollFlowRequiredParametersSubtitle,
        ),
        Gap(20.h),
        AddElementFormRow(
          columns: _desktopColumns,
          children: [
            DigifySelectFieldWithLabel<String>(
              label: loc.payrollSubmitPayrollFlowScope,
              hint: loc.payrollSubmitPayrollFlowSelectScope,
              isRequired: true,
              value: state.scope,
              items: SubmitPayrollFlowConfig.scopeOptions,
              itemLabelBuilder: (value) => value,
              onChanged: controller.setScope,
            ),
            DigifySelectFieldWithLabel<String>(
              label: loc.payrollSubmitPayrollFlowPayroll,
              hint: loc.payrollSubmitPayrollFlowSelectPayroll,
              isRequired: true,
              value: state.payroll,
              items: SubmitPayrollFlowConfig.payrollOptions,
              itemLabelBuilder: (value) => value,
              onChanged: controller.setPayroll,
            ),
            DigifySelectFieldWithLabel<String>(
              label: loc.payrollSubmitPayrollFlowPayrollPeriod,
              hint: loc.payrollSubmitPayrollFlowSelectPayrollPeriod,
              isRequired: true,
              value: state.payrollPeriod,
              items: SubmitPayrollFlowConfig.payrollPeriodOptions,
              itemLabelBuilder: (value) => value,
              onChanged: controller.setPayrollPeriod,
            ),
            DigifySelectFieldWithLabel<String>(
              label: loc.payrollSubmitPayrollFlowConsolidationGroup,
              hint: loc.payrollSubmitPayrollFlowSelectConsolidationGroup,
              value: state.consolidationGroup,
              items: SubmitPayrollFlowConfig.consolidationGroupOptions,
              itemLabelBuilder: (value) => value,
              onChanged: controller.setConsolidationGroup,
            ),
          ],
        ),
        Gap(16.h),
        AddElementFormRow(
          columns: _desktopColumns,
          children: [
            DigifySelectFieldWithLabel<String>(
              label: loc.payrollSubmitPayrollFlowRunType,
              hint: loc.payrollSubmitPayrollFlowSelectRunType,
              isRequired: true,
              value: state.runType,
              items: SubmitPayrollFlowConfig.runTypeOptions,
              itemLabelBuilder: (value) => value,
              onChanged: controller.setRunType,
            ),
            DigifySelectFieldWithLabel<String>(
              label: loc.payrollSubmitPayrollFlowPayrollRelationshipGroup,
              hint: loc.payrollSubmitPayrollFlowSelectPayrollRelationshipGroup,
              value: state.payrollRelationshipGroup,
              items: SubmitPayrollFlowConfig.payrollRelationshipGroupOptions,
              itemLabelBuilder: (value) => value,
              onChanged: controller.setPayrollRelationshipGroup,
            ),
          ],
        ),
        Gap(24.h),
        const DigifyDivider.horizontal(),
        Gap(24.h),
        SubmitPayrollFlowSectionHeader(
          title: loc.payrollSubmitPayrollFlowOptionalParameters,
          subtitle: loc.payrollSubmitPayrollFlowOptionalParametersSubtitle,
        ),
        Gap(20.h),
        AddElementFormRow(
          columns: _desktopColumns,
          children: [
            DigifyDateField(
              label: loc.payrollSubmitPayrollFlowProcessStartDate,
              isRequired: false,
              hintText: loc.payrollSubmitPayrollFlowDateHint,
              initialDate: state.processStartDate,
              onDateSelected: controller.setProcessStartDate,
            ),
            DigifyDateField(
              label: loc.payrollSubmitPayrollFlowProcessEndDate,
              isRequired: false,
              hintText: loc.payrollSubmitPayrollFlowDateHint,
              initialDate: state.processEndDate,
              onDateSelected: controller.setProcessEndDate,
            ),
            DigifyDateField(
              label: loc.payrollSubmitPayrollFlowDateEarned,
              isRequired: false,
              hintText: loc.payrollSubmitPayrollFlowDateHint,
              initialDate: state.dateEarned,
              onDateSelected: controller.setDateEarned,
            ),
            DigifySelectFieldWithLabel<String>(
              label: loc.payrollSubmitPayrollFlowElementGroup,
              hint: loc.payrollSubmitPayrollFlowSelectElementGroup,
              value: state.elementGroup,
              items: SubmitPayrollFlowConfig.elementGroupOptions,
              itemLabelBuilder: (value) => value,
              onChanged: controller.setElementGroup,
            ),
          ],
        ),
        Gap(16.h),
        AddElementFormRow(
          columns: _desktopColumns,
          children: [
            DigifySelectFieldWithLabel<String>(
              label: loc.payrollSubmitPayrollFlowReportCategory,
              hint: loc.payrollSubmitPayrollFlowSelectReportCategory,
              value: state.reportCategory,
              items: SubmitPayrollFlowConfig.reportCategoryOptions,
              itemLabelBuilder: (value) => value,
              onChanged: controller.setReportCategory,
            ),
            DigifySelectFieldWithLabel<String>(
              label: loc.payrollSubmitPayrollFlowProcessConfigurationGroup,
              hint: loc.payrollSubmitPayrollFlowSelectProcessConfigurationGroup,
              value: state.processConfigurationGroup,
              items: SubmitPayrollFlowConfig.processConfigurationGroupOptions,
              itemLabelBuilder: (value) => value,
              onChanged: controller.setProcessConfigurationGroup,
            ),
            DigifySelectFieldWithLabel<String>(
              label: loc.payrollSubmitPayrollFlowRunMode,
              value: state.runMode,
              items: SubmitPayrollFlowConfig.runModeOptions,
              itemLabelBuilder: (value) => SubmitPayrollFlowConfig.runModeLabel(loc, value),
              onChanged: (value) {
                if (value != null) controller.setRunMode(value);
              },
            ),
          ],
        ),
        Gap(24.h),
        SubmitPayrollFlowStepFooter(
          showBack: true,
          backLabel: loc.previous,
          onBackPressed: controller.goToFlowDetailsStep,
          primaryLabel: loc.payrollSubmitPayrollFlowReviewSubmit,
          onPrimaryPressed: controller.goToReviewStep,
        ),
      ],
    );
  }
}
