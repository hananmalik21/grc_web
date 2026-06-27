import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/feedback/app_stepper_dialog_label_below.dart';
import 'package:grc/features/leave_management/presentation/config/new_leave_request_stepper_config.dart';
import 'package:grc/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/new_leave_request/contact_notes_step.dart';
import 'package:grc/features/leave_management/presentation/widgets/new_leave_request/documents_review/documents_review_step.dart';
import 'package:grc/features/leave_management/presentation/widgets/new_leave_request/leave_details_step.dart';
import 'package:grc/features/leave_management/presentation/widgets/new_leave_request/new_leave_request_dialog_footer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NewLeaveRequestDialog extends ConsumerWidget {
  const NewLeaveRequestDialog({super.key});

  static void show(BuildContext context) {
    showDialog(context: context, barrierDismissible: false, builder: (context) => const NewLeaveRequestDialog());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final state = ref.watch(newLeaveRequestProvider);
    final notifier = ref.read(newLeaveRequestProvider.notifier);
    final stepperSteps = newLeaveRequestStepperSteps(localizations);

    return AppStepperDialogLabelBelow(
      title: localizations.newLeaveRequest,
      subtitle: localizations.completeAllStepsToSubmit,
      content: _buildStepContent(state.currentStep),
      stepperSteps: stepperSteps,
      currentStepIndex: state.currentStep.index,
      onClose: () {
        notifier.reset();
        context.pop();
      },
      footerLeftActions: buildNewLeaveRequestFooterLeftActions(context, ref, state, notifier),
      footerActions: buildNewLeaveRequestFooterRightActions(context, ref, state, notifier),
      isLoading: state.isLoadingDraft,
    );
  }

  Widget _buildStepContent(LeaveRequestStep step) {
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
