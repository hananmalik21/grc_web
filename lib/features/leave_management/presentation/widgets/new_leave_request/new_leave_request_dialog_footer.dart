import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_requests_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

List<Widget> buildNewLeaveRequestFooterLeftActions(
  BuildContext context,
  WidgetRef ref,
  NewLeaveRequestState state,
  NewLeaveRequestNotifier notifier,
) {
  final localizations = AppLocalizations.of(context)!;
  return [
    AppButton.outline(
      label: localizations.cancel,
      onPressed: () {
        notifier.reset();
        context.pop();
      },
    ),
    if (state.currentStep != LeaveRequestStep.leaveDetails) ...[
      Gap(8.w),
      AppButton.outline(label: localizations.previous, onPressed: () => notifier.previousStep()),
    ],
  ];
}

List<Widget> buildNewLeaveRequestFooterRightActions(
  BuildContext context,
  WidgetRef ref,
  NewLeaveRequestState state,
  NewLeaveRequestNotifier notifier,
) {
  final localizations = AppLocalizations.of(context)!;

  Future<void> onSaveAsDraft() async {
    final result = await notifier.saveAsDraft();
    if (!context.mounted) return;
    if (result.isSuccess) {
      ToastService.success(context, localizations.draftSaved);
      notifier.reset();
      context.pop();
      ref.read(leaveRequestsNotifierProvider.notifier).refresh();
    } else {
      ToastService.error(context, result.errorMessage ?? '');
    }
  }

  Future<void> onSubmit() async {
    final result = await notifier.submit();
    if (!context.mounted) return;
    if (result.isSuccess) {
      ToastService.success(context, localizations.submitRequest);
      notifier.reset();
      context.pop();
      ref.read(leaveRequestsNotifierProvider.notifier).refresh();
    } else {
      ToastService.error(context, result.errorMessage ?? '');
    }
  }

  return [
    AppButton.outline(
      label: localizations.saveAsDraft,
      isLoading: state.isSavingDraft,
      onPressed: state.isSavingDraft || state.isSubmitting ? null : onSaveAsDraft,
    ),
    Gap(8.w),
    if (state.currentStep != LeaveRequestStep.documentsReview)
      AppButton(
        label: localizations.next,
        onPressed: state.isSavingDraft
            ? null
            : () {
                final error = notifier.validateStep(state.currentStep);
                if (error != null) {
                  ToastService.error(context, error);
                  return;
                }
                notifier.nextStep();
              },
        type: AppButtonType.primary,
      )
    else
      AppButton(
        label: localizations.submitRequest,
        isLoading: state.isSubmitting,
        onPressed: (state.isSubmitting || state.isSavingDraft)
            ? null
            : () {
                final error = notifier.validateStep(state.currentStep);
                if (error != null) {
                  ToastService.error(context, error);
                  return;
                }
                onSubmit();
              },
        type: AppButtonType.primary,
        backgroundColor: AppColors.greenButton,
        svgPath: Assets.icons.checkIconGreen.path,
      ),
  ];
}
