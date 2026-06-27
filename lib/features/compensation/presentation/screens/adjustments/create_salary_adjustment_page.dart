import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_tab_enterprise_provider.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/adjustments_tab_provider.dart';
import 'package:grc/features/compensation/presentation/providers/adjustments/create_adjustment_form_provider.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustment_details_section.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustment_empty_state.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/compensation_components_section.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/compensation_history/compensation_history_section.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/additional_information_section.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/employee_information_section.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/submit_actions_footer.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateSalaryAdjustmentPage extends StatelessWidget {
  static const String routeName = 'create-salary-adjustment';

  final String? initialEmployeeGuid;
  final int? initialEnterpriseId;
  final bool lockEmployeeSelection;

  const CreateSalaryAdjustmentPage({
    super.key,
    this.initialEmployeeGuid,
    this.initialEnterpriseId,
    this.lockEmployeeSelection = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      body: CreateSalaryAdjustmentContent(
        showPageHeader: true,
        initialEmployeeGuid: initialEmployeeGuid,
        initialEnterpriseId: initialEnterpriseId,
        lockEmployeeSelection: lockEmployeeSelection, // if came from the update employee
        returnResultOnSuccess: lockEmployeeSelection, // if came from the update employee
      ),
    );
  }
}

class CreateSalaryAdjustmentContent extends ConsumerStatefulWidget {
  final bool showPageHeader;
  final String? initialEmployeeGuid;
  final int? initialEnterpriseId;
  final bool lockEmployeeSelection;
  final bool returnResultOnSuccess;

  const CreateSalaryAdjustmentContent({
    super.key,
    required this.showPageHeader,
    this.initialEmployeeGuid,
    this.initialEnterpriseId,
    this.lockEmployeeSelection = false,
    this.returnResultOnSuccess = false,
  });

  @override
  ConsumerState<CreateSalaryAdjustmentContent> createState() => _CreateSalaryAdjustmentContentState();
}

class _CreateSalaryAdjustmentContentState extends ConsumerState<CreateSalaryAdjustmentContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notifier = ref.read(createAdjustmentFormProvider.notifier);
      notifier.reset();
      final guid = widget.initialEmployeeGuid?.trim();
      final enterpriseId = widget.initialEnterpriseId;
      if (guid != null && guid.isNotEmpty && enterpriseId != null && enterpriseId > 0) {
        await notifier.prefillEmployeeByGuid(employeeGuid: guid, enterpriseId: enterpriseId);
      }
    });
  }

  void _popOnSuccess(BuildContext context) {
    if (widget.returnResultOnSuccess) {
      if (context.canPop()) {
        context.pop(true);
      } else {
        Navigator.of(context).pop(true);
      }
      return;
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(createAdjustmentFormProvider);
    final formNotifier = ref.read(createAdjustmentFormProvider.notifier);
    final enterpriseId = widget.initialEnterpriseId ?? ref.watch(adjustmentsTabEnterpriseIdProvider) ?? 0;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showPageHeader)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DigifyAssetButton(
                          onTap: () => context.pop(),
                          assetPath: Assets.icons.employeeManagement.backArrow.path,
                        ),
                        Gap(24.w),
                        Expanded(
                          child: DigifyTabHeader(
                            title: 'Create Salary Adjustment',
                            description:
                                'Configure comprehensive compensation changes with detailed component-level control and impact preview',
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: widget.showPageHeader ? 0 : 24.h),
                  child: Column(
                    children: [
                      EmployeeInformationSection(
                        selectedEmployee: formState.selectedEmployee,
                        employeeDetails: formState.selectedEmployeeDetails,
                        isLoadingEmployeeDetails: formState.isLoadingEmployeeDetails,
                        enterpriseId: enterpriseId,
                        lockEmployeeSelection: widget.lockEmployeeSelection,
                        onEmployeeSelected: formNotifier.selectEmployee,
                      ),
                      Gap(24.h),
                      if (formState.selectedEmployee == null)
                        const AdjustmentEmptyState()
                      else ...[
                        AdjustmentDetailsSection(
                          adjustmentType: formState.adjustmentType,
                          effectiveDate: formState.effectiveDate,
                          reasonCode: formState.reasonCode,
                          budgetCode: formState.budgetCode,
                          onTypeChanged: formNotifier.setAdjustmentType,
                          onDateSelected: formNotifier.setEffectiveDate,
                          onReasonChanged: formNotifier.setReasonCode,
                          onBudgetChanged: formNotifier.setBudgetCode,
                        ),
                        Gap(24.h),
                        const CompensationComponentsSection(),
                        Gap(24.h),
                        const AdditionalInformationSection(),
                        Gap(24.h),
                        const CompensationHistorySection(),
                      ],
                      Gap(40.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (formState.selectedEmployee != null)
          SubmitActionsFooter(
            isLoading: formState.isSubmitting,
            onSubmit: () async {
              final error = formNotifier.firstValidationError();
              if (error != null) {
                ToastService.error(context, error);
                return;
              }
              try {
                await formNotifier.submitAdjustment();
                if (!context.mounted) return;
                ref.invalidate(adjustmentsDataPageProvider);
                ToastService.success(context, 'Salary adjustment submitted successfully');
                _popOnSuccess(context);
              } catch (e) {
                if (!context.mounted) return;
                ToastService.error(context, e.toString());
              }
            },
            onSaveDraft: () => context.pop(),
          ),
      ],
    );
  }
}
