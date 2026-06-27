import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/compensation/presentation/providers/salary_structure_creation_provider.dart';
import 'package:grc/features/compensation/presentation/providers/salary_structure_edit_load_provider.dart';
import 'package:grc/features/compensation/presentation/providers/salary_structure_edit_load_state.dart';
import 'package:grc/features/compensation/presentation/providers/update_salary_structure_api_provider.dart';
import 'package:grc/features/compensation/presentation/screens/manage_salary_structure_tab/widgets/salary_structure_creation_step_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EditSalaryStructureMobileSheet extends ConsumerWidget {
  const EditSalaryStructureMobileSheet({super.key, required this.structureGuid});

  final String structureGuid;

  static const _stepLabels = [
    'Basic Information',
    'Scope & Assignment',
    'Components',
    'Financial Details',
    'Advanced Settings',
  ];

  static Future<bool> show(BuildContext context, {required String structureGuid}) async {
    final result = await DigifyBottomSheet.show<bool>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Edit Salary Structure',
      barrierDismissible: false,
      child: ProviderScope(child: EditSalaryStructureMobileSheet(structureGuid: structureGuid)),
    );
    return result == true;
  }

  void _onNext(BuildContext context, WidgetRef ref) {
    final error = ref.read(salaryStructureCreationProvider.notifier).tryGoNext();
    if (error != null) ToastService.error(context, error);
  }

  void _onSave(BuildContext context, WidgetRef ref) {
    final submitState = ref.read(updateSalaryStructureApiProvider(structureGuid));
    if (submitState.isLoading) return;

    final validationError = ref.read(salaryStructureCreationProvider.notifier).validateForSubmit();
    if (validationError != null) {
      ToastService.error(context, validationError);
      return;
    }

    ref.read(updateSalaryStructureApiProvider(structureGuid).notifier).submit().then((apiError) {
      if (!context.mounted) return;
      if (apiError != null) {
        ToastService.error(context, apiError);
        return;
      }
      ToastService.success(context, 'Salary Structure updated successfully!');
      Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(salaryStructureCreationProvider);
    final loadState = ref.watch(salaryStructureEditLoadProvider(structureGuid));

    return switch (loadState) {
      SalaryStructureEditLoading() => _EditSheetLoading(isDark: context.isDark),
      SalaryStructureEditError(:final message) => _EditSheetError(
        message: message,
        onRetry: () => ref.read(salaryStructureEditLoadProvider(structureGuid).notifier).retry(),
      ),
      SalaryStructureEditLoaded() => _EditSheetForm(
        structureGuid: structureGuid,
        stepLabels: _stepLabels,
        isDark: context.isDark,
        onNext: () => _onNext(context, ref),
        onSave: () => _onSave(context, ref),
        onPrevious: ref.read(salaryStructureCreationProvider.notifier).previousStep,
      ),
    };
  }
}

class _EditSheetLoading extends StatelessWidget {
  final bool isDark;

  const _EditSheetLoading({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppLoadingIndicator(size: 40.r),
          Gap(12.h),
          Text('Loading salary structure...', style: context.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _EditSheetError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _EditSheetError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsetsDirectional.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Failed to load salary structure.', style: context.textTheme.titleSmall),
            Gap(8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            Gap(16.h),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _EditSheetForm extends ConsumerWidget {
  final String structureGuid;
  final List<String> stepLabels;
  final bool isDark;
  final VoidCallback onNext;
  final VoidCallback onSave;
  final VoidCallback onPrevious;

  const _EditSheetForm({
    required this.structureGuid,
    required this.stepLabels,
    required this.isDark,
    required this.onNext,
    required this.onSave,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(salaryStructureCreationProvider);
    final submitState = ref.watch(updateSalaryStructureApiProvider(structureGuid));
    final totalSteps = stepLabels.length;
    final isLastStep = state.currentStep == totalSteps - 1;

    return DigifyStepperSheetContent(
      currentStep: state.currentStep,
      totalSteps: totalSteps,
      stepLabel: stepLabels[state.currentStep],
      isDark: isDark,
      canGoPrevious: state.currentStep > 0,
      isLastStep: isLastStep,
      isLoading: submitState.isLoading,
      previousLabel: 'Back',
      nextLabel: 'Continue',
      saveLabel: 'Save Changes',
      onPrevious: onPrevious,
      onNext: onNext,
      onSave: onSave,
      body: SalaryStructureCreationStepBody(currentStep: state.currentStep),
    );
  }
}
