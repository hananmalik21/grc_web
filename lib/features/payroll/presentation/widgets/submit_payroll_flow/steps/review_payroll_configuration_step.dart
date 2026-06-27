import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/payroll/application/submit_payroll_flow/config/submit_payroll_flow_config.dart';
import 'package:grc/features/payroll/application/submit_payroll_flow/providers/submit_payroll_flow_provider.dart';
import 'package:grc/features/payroll/presentation/widgets/element_entries/add_element/common/add_element_form_row.dart';
import 'package:grc/features/payroll/presentation/widgets/submit_payroll_flow/submit_payroll_flow_review_field.dart';
import 'package:grc/features/payroll/presentation/widgets/submit_payroll_flow/submit_payroll_flow_step_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ReviewPayrollConfigurationStep extends ConsumerWidget {
  const ReviewPayrollConfigurationStep({super.key});

  static const _desktopColumns = 4;
  static const _flowInfoColumns = 2;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(submitPayrollFlowProvider);
    final controller = ref.read(submitPayrollFlowProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ReviewHeader(
          title: loc.payrollSubmitPayrollFlowReviewTitle,
          subtitle: loc.payrollSubmitPayrollFlowReviewSubtitle,
        ),
        Gap(28.h),
        _ReviewSection(
          title: loc.payrollSubmitPayrollFlowFlowInformation,
          children: [
            AddElementFormRow(
              columns: _flowInfoColumns,
              children: [
                SubmitPayrollFlowReviewField(
                  label: loc.payrollSubmitPayrollFlowPayrollFlow,
                  value: _displayValue(state.payrollFlow),
                  isRequired: true,
                ),
                SubmitPayrollFlowReviewField(
                  label: loc.payrollSubmitPayrollFlowSchedule,
                  value: SubmitPayrollFlowConfig.scheduleLabel(loc, state.schedule),
                  isRequired: true,
                ),
              ],
            ),
          ],
        ),
        Gap(20.h),
        const DigifyDivider.horizontal(),
        Gap(20.h),
        _ReviewSection(
          title: loc.payrollSubmitPayrollFlowRequiredParameters,
          children: [
            AddElementFormRow(
              columns: _desktopColumns,
              children: [
                SubmitPayrollFlowReviewField(
                  label: loc.payrollSubmitPayrollFlowScope,
                  value: _displayValue(state.scope),
                  isRequired: true,
                ),
                SubmitPayrollFlowReviewField(
                  label: loc.payrollSubmitPayrollFlowPayroll,
                  value: _displayValue(state.payroll),
                  isRequired: true,
                ),
                SubmitPayrollFlowReviewField(
                  label: loc.payrollSubmitPayrollFlowPayrollPeriod,
                  value: _displayValue(state.payrollPeriod),
                  isRequired: true,
                ),
                SubmitPayrollFlowReviewField(
                  label: loc.payrollSubmitPayrollFlowConsolidationGroup,
                  value: _displayValue(state.consolidationGroup),
                ),
              ],
            ),
            Gap(16.h),
            AddElementFormRow(
              columns: _desktopColumns,
              children: [
                SubmitPayrollFlowReviewField(
                  label: loc.payrollSubmitPayrollFlowRunType,
                  value: _displayValue(state.runType),
                  isRequired: true,
                ),
                SubmitPayrollFlowReviewField(
                  label: loc.payrollSubmitPayrollFlowPayrollRelationshipGroup,
                  value: _displayValue(state.payrollRelationshipGroup),
                ),
              ],
            ),
          ],
        ),
        Gap(20.h),
        const DigifyDivider.horizontal(),
        Gap(20.h),
        _ReviewSection(
          title: loc.payrollSubmitPayrollFlowOptionalParameters,
          children: [
            AddElementFormRow(
              columns: _desktopColumns,
              children: [
                SubmitPayrollFlowReviewField(
                  label: loc.payrollSubmitPayrollFlowElementGroup,
                  value: _displayValue(state.elementGroup),
                ),
                SubmitPayrollFlowReviewField(
                  label: loc.payrollSubmitPayrollFlowReportCategory,
                  value: _displayValue(state.reportCategory),
                ),
                SubmitPayrollFlowReviewField(
                  label: loc.payrollSubmitPayrollFlowProcessConfigurationGroup,
                  value: _displayValue(state.processConfigurationGroup),
                ),
                SubmitPayrollFlowReviewField(
                  label: loc.payrollSubmitPayrollFlowRunMode,
                  value: SubmitPayrollFlowConfig.runModeLabel(loc, state.runMode),
                ),
              ],
            ),
          ],
        ),
        Gap(24.h),
        SubmitPayrollFlowStepFooter(
          showBack: true,
          backLabel: loc.previous,
          onBackPressed: controller.goBackToEdit,
          primaryLabel: loc.payrollSubmitPayrollFlowConfirmSubmit,
          onPrimaryPressed: controller.confirmAndSubmit,
        ),
      ],
    );
  }

  static String _displayValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return SubmitPayrollFlowReviewField.emptyValue;
    }
    return value;
  }
}

class _ReviewHeader extends StatelessWidget {
  const _ReviewHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.headlineMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(4.h),
        Text(
          subtitle,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontSize: 15.sp,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        Gap(16.h),
        ...children,
      ],
    );
  }
}
