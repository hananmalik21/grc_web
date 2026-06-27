import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_management_enterprise_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_requests_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/new_leave_request/contact_notes_step.dart';
import 'package:grc/features/leave_management/presentation/widgets/new_leave_request/documents_review/documents_review_step.dart';
import 'package:grc/features/leave_management/presentation/widgets/new_leave_request/leave_details_step.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NewLeaveRequestMobileSheet {
  NewLeaveRequestMobileSheet._();

  static void show(BuildContext context) {
    DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'New Leave Request',
      barrierDismissible: false,
      child: const _LeaveRequestSheetBody(isEdit: false),
    );
  }
}

class EditLeaveRequestMobileSheet {
  EditLeaveRequestMobileSheet._();

  static void show(BuildContext context, WidgetRef ref, TimeOffRequest request) {
    final notifier = ref.read(newLeaveRequestProvider.notifier);
    final repository = ref.read(leaveRequestsRepositoryProvider);

    notifier.reset();
    notifier.setLoadingDraft(true);

    DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Edit Leave Request',
      barrierDismissible: false,
      child: const _LeaveRequestSheetBody(isEdit: true),
    );

    () async {
      try {
        final tenantId = ref.read(leaveManagementEnterpriseIdProvider);
        final response = await repository.getLeaveRequestById(request.guid, tenantId: tenantId);
        await notifier.loadDraftData(response, originalRequest: request);
        notifier.setLoadingDraft(false);
      } catch (e) {
        notifier.setLoadingDraft(false);
        if (context.mounted) {
          Navigator.of(context).maybePop();
          ToastService.error(context, e.toString().replaceFirst('Exception: ', ''));
        }
      }
    }();
  }
}

class _LeaveRequestSheetBody extends ConsumerWidget {
  const _LeaveRequestSheetBody({required this.isEdit});

  final bool isEdit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(newLeaveRequestProvider);
    final isDark = context.isDark;

    if (state.isLoadingDraft) {
      return _LoadingBody(isDark: isDark);
    }

    final notifier = ref.read(newLeaveRequestProvider.notifier);
    final localizations = AppLocalizations.of(context)!;
    final totalSteps = LeaveRequestStep.values.length;
    final currentIndex = state.currentStep.index;
    final isLastStep = currentIndex == totalSteps - 1;

    Future<void> onSaveAsDraft() async {
      final result = await notifier.saveAsDraft();
      if (!context.mounted) return;
      if (result.isSuccess) {
        ToastService.success(context, localizations.draftSaved);
        notifier.reset();
        Navigator.of(context).pop();
        ref.read(leaveRequestsNotifierProvider.notifier).refresh();
      } else {
        ToastService.error(context, result.errorMessage ?? '');
      }
    }

    Future<void> onSubmit() async {
      final validationError = notifier.validateStep(state.currentStep);
      if (validationError != null) {
        ToastService.error(context, validationError);
        return;
      }
      final result = await notifier.submit();
      if (!context.mounted) return;
      if (result.isSuccess) {
        ToastService.success(context, localizations.submitRequest);
        notifier.reset();
        Navigator.of(context).pop();
        ref.read(leaveRequestsNotifierProvider.notifier).refresh();
      } else {
        ToastService.error(context, result.errorMessage ?? '');
      }
    }

    void onNext() {
      final validationError = notifier.validateStep(state.currentStep);
      if (validationError != null) {
        ToastService.error(context, validationError);
        return;
      }
      notifier.nextStep();
    }

    return Column(
      children: [
        _SheetProgressBar(
          currentStep: currentIndex,
          totalSteps: totalSteps,
          stepLabel: _stepLabel(state.currentStep, localizations),
          isDark: isDark,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 16.h, 16.w, 8.h),
            child: _SheetStepContent(step: state.currentStep),
          ),
        ),
        const DigifyDivider.horizontal(),
        _SheetFooter(
          currentStep: state.currentStep,
          isLastStep: isLastStep,
          isSubmitting: state.isSubmitting,
          isSavingDraft: state.isSavingDraft,
          isEdit: isEdit,
          localizations: localizations,
          onBack: notifier.previousStep,
          onSaveAsDraft: onSaveAsDraft,
          onNext: onNext,
          onSubmit: onSubmit,
        ),
      ],
    );
  }

  String _stepLabel(LeaveRequestStep step, AppLocalizations l10n) {
    switch (step) {
      case LeaveRequestStep.leaveDetails:
        return l10n.leaveDetails;
      case LeaveRequestStep.contactNotes:
        return l10n.contactNotes;
      case LeaveRequestStep.documentsReview:
        return l10n.documentsReview;
    }
  }
}

class _SheetStepContent extends StatelessWidget {
  const _SheetStepContent({required this.step});

  final LeaveRequestStep step;

  @override
  Widget build(BuildContext context) {
    switch (step) {
      case LeaveRequestStep.leaveDetails:
        return const LeaveDetailsStep();
      case LeaveRequestStep.contactNotes:
        return const ContactNotesStep();
      case LeaveRequestStep.documentsReview:
        return const DocumentsReviewStep();
    }
  }
}

class _SheetProgressBar extends StatelessWidget {
  const _SheetProgressBar({
    required this.currentStep,
    required this.totalSteps,
    required this.stepLabel,
    required this.isDark,
  });

  final int currentStep;
  final int totalSteps;
  final String stepLabel;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final progress = (currentStep + 1) / totalSteps;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final trackColor = isDark ? AppColors.cardBorderDark.withValues(alpha: 0.6) : AppColors.cardBorder;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 12.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                stepLabel,
                style: context.textTheme.labelMedium?.copyWith(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Text(
                '${currentStep + 1} / $totalSteps',
                style: context.textTheme.labelSmall?.copyWith(
                  fontSize: 11.sp,
                  color: labelColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Gap(6.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4.h,
              backgroundColor: trackColor,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          Gap(4.h),
          _StepDots(currentStep: currentStep, totalSteps: totalSteps, isDark: isDark),
        ],
      ),
    );
  }
}

class _StepDots extends StatelessWidget {
  const _StepDots({required this.currentStep, required this.totalSteps, required this.isDark});

  final int currentStep;
  final int totalSteps;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (i) {
        final isActive = i == currentStep;
        final isCompleted = i < currentStep;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: isActive ? 16.w : 6.w,
          height: 6.h,
          margin: EdgeInsetsDirectional.only(end: 4.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3.r),
            color: isActive
                ? AppColors.primary
                : isCompleted
                ? AppColors.primary.withValues(alpha: 0.35)
                : isDark
                ? AppColors.cardBorderDark
                : AppColors.cardBorder,
          ),
        );
      }),
    );
  }
}

class _SheetFooter extends StatelessWidget {
  const _SheetFooter({
    required this.currentStep,
    required this.isLastStep,
    required this.isSubmitting,
    required this.isSavingDraft,
    required this.isEdit,
    required this.localizations,
    required this.onBack,
    required this.onSaveAsDraft,
    required this.onNext,
    required this.onSubmit,
  });

  final LeaveRequestStep currentStep;
  final bool isLastStep;
  final bool isSubmitting;
  final bool isSavingDraft;
  final bool isEdit;
  final AppLocalizations localizations;
  final VoidCallback onBack;
  final VoidCallback onSaveAsDraft;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  static const double _btnHeight = 44;

  @override
  Widget build(BuildContext context) {
    final isBusy = isSubmitting || isSavingDraft;
    final isFirstStep = currentStep.index == 0;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: isLastStep
                ? AppButton(
                    label: isEdit ? 'Update' : localizations.submitRequest,
                    type: AppButtonType.primary,
                    isLoading: isSubmitting,
                    onPressed: isBusy ? null : onSubmit,
                    height: _btnHeight,
                    backgroundColor: AppColors.greenButton,
                  )
                : AppButton.primary(label: localizations.next, onPressed: isBusy ? null : onNext, height: _btnHeight),
          ),
          Gap(8.h),
          Row(
            children: [
              if (!isFirstStep)
                Expanded(
                  child: AppButton.outline(
                    label: localizations.previous,
                    onPressed: isBusy ? null : onBack,
                    height: _btnHeight,
                  ),
                )
              else
                const SizedBox.shrink(),
              if (!isFirstStep) Gap(8.w),
              Expanded(
                child: AppButton.outline(
                  label: localizations.saveAsDraft,
                  isLoading: isSavingDraft,
                  onPressed: isBusy ? null : onSaveAsDraft,
                  height: _btnHeight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingBody extends StatelessWidget {
  const _LoadingBody({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(48.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLoadingIndicator(size: 40),
            Gap(16.h),
            Text(
              'Loading leave request...',
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
