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

class AddEmployeeMobileSheet extends ConsumerWidget {
  const AddEmployeeMobileSheet({super.key});

  static Future<void> show(BuildContext context) {
    final container = ProviderScope.containerOf(context);
    container.read(addEmployeeDialogFlowProvider).clearForm();
    container.read(addEmployeeEditingEmployeeIdProvider.notifier).state = null;
    final enterpriseId = container.read(manageEmployeesEnterpriseIdProvider);
    if (enterpriseId != null) {
      container.read(employeeWorkSchedulesNotifierProvider(enterpriseId).notifier).setEnterpriseId(enterpriseId);
    }
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: AppLocalizations.of(context)!.addNewEmployee,
      barrierDismissible: false,
      child: const AddEmployeeMobileSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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

  static String _stepLabel(int index, AppLocalizations l) {
    switch (index) {
      case 0:
        return l.addEmployeeStepBasicInfo;
      case 1:
        return l.addEmployeeStepDemographics;
      case 2:
        return l.addEmployeeStepAddress;
      case 3:
        return l.addEmployeeStepAssignmentInfo;
      case 4:
        return l.addEmployeeStepWorkSchedule;
      case 5:
        return l.addEmployeeStepCompensation;
      case 6:
        return l.addEmployeeStepBanking;
      case 7:
        return l.addEmployeeStepDocuments;
      case 8:
        return l.addEmployeeStepReview;
      default:
        return '';
    }
  }

  static Widget _buildStepContent(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return const AddEmployeeBasicInfoStep();
      case 1:
        return const AddEmployeeDemographicsStep();
      case 2:
        return const AddEmployeeAddressStep();
      case 3:
        return const AddEmployeeAssignmentStep();
      case 4:
        return const AddEmployeeWorkScheduleStep();
      case 5:
        return const AddEmployeeCompensationStep();
      case 6:
        return const AddEmployeeBankingStep();
      case 7:
        return const AddEmployeeDocumentsStep();
      case 8:
        return const AddEmployeeReviewStep();
      default:
        return const SizedBox.shrink();
    }
  }
}
