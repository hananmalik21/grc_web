import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_basic_info_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_dialog_flow_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_editing_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_org_selection_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_stepper_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/employee_structure_providers.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/address_step.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/assignment_step.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/basic_info_step.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/banking_step.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/compensation_step.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/demographics_step.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/documents_step.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/review_step.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/work_schedule_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditEmployeeMobileSheet extends ConsumerWidget {
  const EditEmployeeMobileSheet({super.key});

  static Future<void> show(BuildContext context, String employeeGuid) {
    final container = ProviderScope.containerOf(context);
    container.read(addEmployeeDialogFlowProvider).clearForm();
    container.read(addEmployeeEditingEmployeeIdProvider.notifier).state = employeeGuid;
    final enterpriseId = container.read(manageEmployeesEnterpriseIdProvider);
    if (enterpriseId != null) {
      container.read(employeeWorkSchedulesNotifierProvider(enterpriseId).notifier).setEnterpriseId(enterpriseId);
    }
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: AppLocalizations.of(context)!.editEmployee,
      barrierDismissible: false,
      child: const EditEmployeeMobileSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(addEmployeeEditPreloadProvider);

    final key = ref.watch(addEmployeeOrgSelectionKeyProvider);
    if (key != null) ref.watch(addEmployeeOrgSelectionProvider(key));

    final localizations = AppLocalizations.of(context)!;
    final stepperState = ref.watch(addEmployeeStepperProvider);
    final basicInfoState = ref.watch(addEmployeeBasicInfoProvider);
    final flow = ref.watch(addEmployeeDialogFlowProvider);

    return DigifyStepperSheetContent(
      currentStep: stepperState.currentStepIndex,
      totalSteps: addEmployeeTotalSteps,
      stepLabel: _stepLabel(stepperState.currentStepIndex, localizations),
      isDark: context.isDark,
      canGoPrevious: stepperState.canGoPrevious,
      isLastStep: stepperState.isLastStep,
      isLoading: basicInfoState.isSubmitting,
      previousLabel: localizations.previous,
      nextLabel: localizations.next,
      saveLabel: localizations.saveChanges,
      onPrevious: flow.goPrevious,
      onNext: () => flow.goNext(context),
      onSave: () => flow.saveAndClose(context),
      body: _buildStepContent(stepperState.currentStepIndex),
    );
  }

  static String _stepLabel(int index, AppLocalizations l) => switch (index) {
    0 => l.addEmployeeStepBasicInfo,
    1 => l.addEmployeeStepDemographics,
    2 => l.addEmployeeStepAddress,
    3 => l.addEmployeeStepAssignmentInfo,
    4 => l.addEmployeeStepWorkSchedule,
    5 => l.addEmployeeStepCompensation,
    6 => l.addEmployeeStepBanking,
    7 => l.addEmployeeStepDocuments,
    8 => l.addEmployeeStepReview,
    _ => '',
  };

  static Widget _buildStepContent(int stepIndex) => switch (stepIndex) {
    0 => const AddEmployeeBasicInfoStep(),
    1 => const AddEmployeeDemographicsStep(),
    2 => const AddEmployeeAddressStep(),
    3 => const AddEmployeeAssignmentStep(),
    4 => const AddEmployeeWorkScheduleStep(),
    5 => const AddEmployeeCompensationStep(),
    6 => const AddEmployeeBankingStep(),
    7 => const AddEmployeeDocumentsStep(),
    8 => const AddEmployeeReviewStep(),
    _ => const SizedBox.shrink(),
  };
}
