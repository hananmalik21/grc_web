import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/services/toast_service.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/common/app_loading_indicator.dart';
import '../../providers/salary_structure_creation_provider.dart';
import '../../providers/salary_structure_edit_load_provider.dart';
import '../../providers/salary_structure_edit_load_state.dart';
import '../../providers/salary_structure_listing_provider.dart';
import '../../providers/update_salary_structure_api_provider.dart';
import 'widgets/salary_structure_creation_step_body.dart';
import 'widgets/salary_structure_creation_stepper.dart';
import 'widgets/salary_structure_edit_header.dart';

class SalaryStructureEditScreen extends ConsumerWidget {
  static const String routeName = 'compensation-manage-salary-structure-edit';

  final String structureGuid;

  const SalaryStructureEditScreen({super.key, required this.structureGuid});

  Future<void> _handleContinue(BuildContext context, WidgetRef ref) async {
    final state = ref.read(salaryStructureCreationProvider);
    final notifier = ref.read(salaryStructureCreationProvider.notifier);
    final submitNotifier = ref.read(updateSalaryStructureApiProvider(structureGuid).notifier);

    if (state.currentStep != 4) {
      final error = notifier.tryGoNext();
      if (error != null) ToastService.error(context, error);
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

    ToastService.success(context, 'Salary Structure updated successfully!');
    ref.read(salaryStructuresCurrentPageProvider.notifier).state = salaryStructuresDefaultPage;
    ref.read(salaryStructuresRefreshTickProvider.notifier).state++;
    context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Always watch to keep the autoDispose form provider alive so the load
    // notifier can write to it during prefill without triggering a rebuild loop.
    ref.watch(salaryStructureCreationProvider);
    final loadState = ref.watch(salaryStructureEditLoadProvider(structureGuid));

    return switch (loadState) {
      SalaryStructureEditLoading() => const _EditLoadingView(),
      SalaryStructureEditError(:final message) => _EditErrorView(
        error: message,
        onRetry: () => ref.read(salaryStructureEditLoadProvider(structureGuid).notifier).retry(),
      ),
      SalaryStructureEditLoaded() => _EditFormView(
        structureGuid: structureGuid,
        onContinue: () => _handleContinue(context, ref),
      ),
    };
  }
}

// ── Private sub-widgets ───────────────────────────────────────────────────────

class _EditLoadingView extends StatelessWidget {
  const _EditLoadingView();

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLoadingIndicator(size: 48.r),
            Gap(16.h),
            Text(
              'Loading salary structure...',
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _EditErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Failed to load salary structure details.', style: context.textTheme.titleMedium),
              Gap(8.h),
              Text(
                error,
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
      ),
    );
  }
}

class _EditFormView extends ConsumerWidget {
  final String structureGuid;
  final VoidCallback onContinue;

  const _EditFormView({required this.structureGuid, required this.onContinue});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(salaryStructureCreationProvider);
    final notifier = ref.read(salaryStructureCreationProvider.notifier);
    final submitState = ref.watch(updateSalaryStructureApiProvider(structureGuid));
    final isLastStep = state.currentStep == 4;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w).copyWith(top: 24.h, bottom: 40.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SalaryStructureEditHeader(
              canGoBack: state.currentStep > 0,
              isLastStep: isLastStep,
              isLoading: isLastStep && submitState.isLoading,
              onBack: notifier.previousStep,
              onCancel: () => context.pop(),
              onContinue: onContinue,
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
