import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/schedule_interview_enterprise_provider.dart';
import 'package:grc/features/hiring/application/interviews/providers/create_new_interview_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/models/schedule_interview_subject.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/mobile/create_new_interview_mobile_sheet.dart';
import 'package:grc/features/hiring/presentation/widgets/schedule_interview/schedule_interview_form_binding.dart';
import 'package:grc/features/hiring/presentation/widgets/schedule_interview/schedule_interview_form_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ScheduleInterviewDialog extends ConsumerStatefulWidget {
  const ScheduleInterviewDialog({
    super.key,
    required this.binding,
    this.subject,
    this.onSuccess,
    this.selectedCandidate,
    this.onCandidateSelected,
  });

  final ScheduleInterviewFormBinding binding;
  final ScheduleInterviewSubject? subject;
  final Future<void> Function()? onSuccess;
  final CandidateData? selectedCandidate;
  final ValueChanged<CandidateData>? onCandidateSelected;

  static Future<void> show(
    BuildContext context,
    ScheduleInterviewSubject subject, {
    int? enterpriseId,
    Future<void> Function()? onSuccess,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => ProviderScope(
        overrides: [if (enterpriseId != null) scheduleInterviewEnterpriseIdProvider.overrideWithValue(enterpriseId)],
        child: ScheduleInterviewDialog(
          binding: ScheduleInterviewFormBinding.candidate(subject.candidateGuid),
          subject: subject,
          onSuccess: onSuccess,
        ),
      ),
    );
  }

  static Future<void> showCreateNew(BuildContext context, {int? enterpriseId, Future<void> Function()? onSuccess}) {
    if (context.isMobile) {
      return CreateNewInterviewMobileSheet.show(context, enterpriseId: enterpriseId, onSuccess: onSuccess);
    }

    return showDialog<void>(
      context: context,
      builder: (dialogContext) => ProviderScope(
        overrides: [
          if (enterpriseId != null) createNewInterviewEnterpriseIdProvider.overrideWithValue(enterpriseId),
          if (enterpriseId != null) candidatesTabEnterpriseIdProvider.overrideWithValue(enterpriseId),
        ],
        child: ScheduleInterviewDialog(
          binding: const ScheduleInterviewFormBinding.interviewsTab(),
          onSuccess: onSuccess,
        ),
      ),
    );
  }

  @override
  ConsumerState<ScheduleInterviewDialog> createState() => _ScheduleInterviewDialogState();
}

class _ScheduleInterviewDialogState extends ConsumerState<ScheduleInterviewDialog> {
  final TextEditingController _notesController = TextEditingController();
  CandidateData? _selectedCandidate;

  @override
  void initState() {
    super.initState();
    _selectedCandidate = widget.selectedCandidate;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _onCandidateSelected(CandidateData candidate) {
    setState(() => _selectedCandidate = candidate);
    widget.onCandidateSelected?.call(candidate);
  }

  Future<void> _onSubmit() async {
    final notifier = widget.binding.readActions(ref);
    notifier.setAdditionalNotes(_notesController.text);

    final success = await notifier.submit();

    if (!mounted) return;

    if (success) {
      await widget.onSuccess?.call();
      if (!mounted) return;
      ToastService.success(context, 'Interview scheduled successfully');
      context.pop();
    } else {
      final state = ref.read(widget.binding.formStateProvider);
      final message = state.submitError ?? state.fieldErrors.values.firstOrNull ?? 'Please correct the form errors';
      ToastService.error(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final formState = ref.watch(widget.binding.formStateProvider);
    final title = widget.binding.showsCandidatePicker ? loc.hiringInterviewsNew : 'Schedule Interview';
    final submitLabel = widget.binding.showsCandidatePicker ? loc.hiringInterviewsNew : 'Schedule Interview';

    return AppDialog(
      title: title,
      width: 650.w,
      content: SingleChildScrollView(
        child: ScheduleInterviewFormBody(
          binding: widget.binding,
          notesController: _notesController,
          subject: widget.subject,
          selectedCandidate: _selectedCandidate,
          onCandidateSelected: _onCandidateSelected,
        ),
      ),
      actions: [
        AppButton.outline(label: loc.cancel, onPressed: () => context.pop()),
        Gap(8.w),
        AppButton.primary(
          label: submitLabel,
          isLoading: formState.isSubmitting,
          onPressed: formState.isSubmitting ? null : _onSubmit,
        ),
      ],
    );
  }
}
