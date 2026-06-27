import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/services/toast_service.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../providers/create_salary_structure_api_provider.dart';
import '../../providers/salary_structure_company_scope_provider.dart';
import '../../providers/salary_structure_creation_provider.dart';
import '../../providers/salary_structure_listing_provider.dart';
import 'widgets/salary_structure_creation_header.dart';
import 'widgets/salary_structure_creation_step_body.dart';
import 'widgets/salary_structure_creation_stepper.dart';

class SalaryStructureCreationScreen extends ConsumerStatefulWidget {
  static const String routeName = 'compensation-manage-salary-structure-create';

  const SalaryStructureCreationScreen({super.key});

  @override
  ConsumerState<SalaryStructureCreationScreen> createState() => _SalaryStructureCreationScreenState();
}

class _SalaryStructureCreationScreenState extends ConsumerState<SalaryStructureCreationScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(companyScopeSelectionProvider.notifier).reset();
    });
  }

  Future<void> _handleContinue(BuildContext context) async {
    final state = ref.read(salaryStructureCreationProvider);
    final notifier = ref.read(salaryStructureCreationProvider.notifier);
    final submitNotifier = ref.read(createSalaryStructureApiProvider.notifier);
    final isLastStep = state.currentStep == 4;

    if (!isLastStep) {
      final error = notifier.tryGoNext();
      if (error != null) {
        ToastService.error(context, error);
      }
      return;
    }

    final error = notifier.validateForSubmit();
    if (error != null) {
      ToastService.error(context, error);
      return;
    }

    final apiError = await submitNotifier.submit();
    if (!context.mounted) return;

    if (apiError != null) {
      ToastService.error(context, apiError);
      return;
    }

    ToastService.success(context, 'Salary Structure saved successfully!');
    ref.read(salaryStructuresCurrentPageProvider.notifier).state = salaryStructuresDefaultPage;
    ref.read(salaryStructuresRefreshTickProvider.notifier).state++;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final state = ref.watch(salaryStructureCreationProvider);
    final notifier = ref.read(salaryStructureCreationProvider.notifier);
    final submitState = ref.watch(createSalaryStructureApiProvider);
    final isLastStep = state.currentStep == 4;
    final canGoBack = state.currentStep > 0;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 24.h, bottom: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SalaryStructureCreationHeader(
              canGoBack: canGoBack,
              isLastStep: isLastStep,
              isLoading: isLastStep && submitState.isLoading,
              onBack: notifier.previousStep,
              onCancel: () {
                context.pop();
              },
              onContinue: () => _handleContinue(context),
            ),
            Gap(24.h),
            SalaryStructureCreationStepper(currentStep: state.currentStep),
            Gap(24.h),
            SalaryStructureCreationStepBody(currentStep: state.currentStep),
            Gap(48.h),
          ],
        ),
      ),
    );
  }
}
