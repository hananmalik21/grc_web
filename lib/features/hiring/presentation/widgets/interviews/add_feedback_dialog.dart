import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/hiring/application/interviews/providers/submit_interview_feedback_provider.dart';
import 'package:grc/features/hiring/application/interviews/states/submit_interview_feedback_state.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/add_feedback_form.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/mobile/add_feedback_mobile_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddFeedbackDialog extends ConsumerStatefulWidget {
  const AddFeedbackDialog({required this.interview, super.key});

  final Interview interview;

  static Future<void> show(BuildContext context, {required Interview interview}) {
    if (context.isMobile) {
      return AddFeedbackMobileSheet.show(context, interview: interview);
    }
    return showDialog<void>(
      context: context,
      builder: (context) => AddFeedbackDialog(interview: interview),
    );
  }

  @override
  ConsumerState<AddFeedbackDialog> createState() => _AddFeedbackDialogState();
}

class _AddFeedbackDialogState extends ConsumerState<AddFeedbackDialog> {
  final _form = AddFeedbackFormState();

  SubmitInterviewFeedbackParams get _params =>
      SubmitInterviewFeedbackParams(interviewGuid: widget.interview.interviewGuid ?? '');

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  Future<void> _onSubmit() async {
    final loc = AppLocalizations.of(context)!;
    final notifier = ref.read(submitInterviewFeedbackControllerProvider(_params).notifier);
    final success = await notifier.submit(
      overallRating: _form.overallRating,
      recommendation: _form.recommendation,
      technicalSkills: _form.technicalSkills,
      communication: _form.communication,
      cultureFit: _form.cultureFit,
      detailedComments: _form.commentsController.text,
    );

    if (!mounted) return;

    if (success) {
      ToastService.success(context, loc.interviewFeedbackSubmitSuccess);
      context.pop();
      return;
    }

    final submitError = ref.read(submitInterviewFeedbackControllerProvider(_params)).submitError;
    if (submitError != null) {
      ToastService.error(context, submitError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final submitState = ref.watch(submitInterviewFeedbackControllerProvider(_params));

    return AppDialog(
      title: loc.addFeedback,
      width: 500.w,
      content: AddFeedbackFormContent(interview: widget.interview, form: _form, onChanged: _onChanged),
      actions: [
        AppButton.outline(label: loc.cancel, onPressed: submitState.isSubmitting ? null : () => context.pop()),
        Gap(8.w),
        AppButton.primary(
          label: loc.submitFeedback,
          isLoading: submitState.isSubmitting,
          onPressed: _form.canSubmit && !submitState.isSubmitting ? _onSubmit : null,
        ),
      ],
    );
  }
}
