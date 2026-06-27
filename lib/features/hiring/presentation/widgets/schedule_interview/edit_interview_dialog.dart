import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/hiring/application/interviews/providers/update_interview_provider.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/mobile/edit_interview_mobile_sheet.dart';
import 'package:grc/features/hiring/presentation/widgets/schedule_interview/edit_interview_form_binding.dart';
import 'package:grc/features/hiring/presentation/widgets/schedule_interview/update_interview_form_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EditInterviewDialog extends ConsumerStatefulWidget {
  const EditInterviewDialog({super.key, required this.interview, required this.binding, this.onSuccess});

  final Interview interview;
  final EditInterviewFormBinding binding;
  final Future<void> Function()? onSuccess;

  static Future<void> show(
    BuildContext context, {
    required Interview interview,
    int? enterpriseId,
    Future<void> Function()? onSuccess,
  }) {
    final interviewGuid = interview.interviewGuid?.trim() ?? '';
    if (interviewGuid.isEmpty) return Future.value();

    if (context.isMobile) {
      return EditInterviewMobileSheet.show(
        context,
        interview: interview,
        enterpriseId: enterpriseId,
        onSuccess: onSuccess,
      );
    }

    return showDialog<void>(
      context: context,
      builder: (dialogContext) => EditInterviewDialog(
        interview: interview,
        binding: EditInterviewFormBinding(interviewGuid),
        onSuccess: onSuccess,
      ),
    );
  }

  @override
  ConsumerState<EditInterviewDialog> createState() => _EditInterviewDialogState();
}

class _EditInterviewDialogState extends ConsumerState<EditInterviewDialog> {
  final TextEditingController _notesController = TextEditingController();
  bool _notesInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(updateInterviewProvider(widget.binding.interviewGuid).notifier)
          .initializeFromInterview(widget.interview);
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final notifier = widget.binding.readActions(ref);
    notifier.setAdditionalNotes(_notesController.text);

    final success = await notifier.submit();

    if (!mounted) return;

    if (success) {
      await widget.onSuccess?.call();
      if (!mounted) return;
      ToastService.success(context, AppLocalizations.of(context)!.hiringInterviewEditSuccess);
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

    if (!_notesInitialized && formState.additionalNotes.isNotEmpty) {
      _notesController.text = formState.additionalNotes;
      _notesInitialized = true;
    }

    return AppDialog(
      title: loc.hiringInterviewEditTitle,
      width: 650.w,
      content: SingleChildScrollView(
        child: UpdateInterviewFormBody(binding: widget.binding, notesController: _notesController),
      ),
      actions: [
        AppButton.outline(label: loc.cancel, onPressed: () => context.pop()),
        Gap(8.w),
        AppButton.primary(
          label: loc.update,
          isLoading: formState.isSubmitting,
          onPressed: formState.isSubmitting ? null : _onSubmit,
        ),
      ],
    );
  }
}
