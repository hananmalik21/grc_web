import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/hiring/application/interviews/providers/submit_interview_feedback_provider.dart';
import 'package:grc/features/hiring/application/interviews/states/submit_interview_feedback_state.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/add_feedback_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddFeedbackMobileSheet extends ConsumerStatefulWidget {
  const AddFeedbackMobileSheet({super.key, required this.interview});

  final Interview interview;

  static Future<void> show(BuildContext context, {required Interview interview}) {
    final loc = AppLocalizations.of(context)!;
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.form,
      title: loc.addFeedback,
      barrierDismissible: false,
      child: AddFeedbackMobileSheet(interview: interview),
    );
  }

  @override
  ConsumerState<AddFeedbackMobileSheet> createState() => _AddFeedbackMobileSheetState();
}

class _AddFeedbackMobileSheetState extends ConsumerState<AddFeedbackMobileSheet> {
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

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
            child: AddFeedbackFormContent(interview: widget.interview, form: _form, onChanged: _onChanged),
          ),
        ),
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
          child: Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  label: loc.cancel,
                  onPressed: submitState.isSubmitting ? null : () => context.pop(),
                  height: 46,
                ),
              ),
              Gap(8.w),
              Expanded(
                child: AppButton.primary(
                  label: loc.submitFeedback,
                  isLoading: submitState.isSubmitting,
                  onPressed: _form.canSubmit && !submitState.isSubmitting ? _onSubmit : null,
                  height: 46,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
