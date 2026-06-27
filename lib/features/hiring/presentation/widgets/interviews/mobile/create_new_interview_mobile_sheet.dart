import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/interviews/providers/create_new_interview_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/widgets/schedule_interview/schedule_interview_form_binding.dart';
import 'package:grc/features/hiring/presentation/widgets/schedule_interview/schedule_interview_form_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateNewInterviewMobileSheet extends ConsumerStatefulWidget {
  const CreateNewInterviewMobileSheet({super.key, this.onSuccess});

  final Future<void> Function()? onSuccess;

  static const _binding = ScheduleInterviewFormBinding.interviewsTab();

  static Future<void> show(BuildContext context, {int? enterpriseId, Future<void> Function()? onSuccess}) {
    final loc = AppLocalizations.of(context)!;
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: loc.hiringInterviewsNew,
      barrierDismissible: false,
      child: ProviderScope(
        overrides: [
          if (enterpriseId != null) createNewInterviewEnterpriseIdProvider.overrideWithValue(enterpriseId),
          if (enterpriseId != null) candidatesTabEnterpriseIdProvider.overrideWithValue(enterpriseId),
        ],
        child: CreateNewInterviewMobileSheet(onSuccess: onSuccess),
      ),
    );
  }

  @override
  ConsumerState<CreateNewInterviewMobileSheet> createState() => _CreateNewInterviewMobileSheetState();
}

class _CreateNewInterviewMobileSheetState extends ConsumerState<CreateNewInterviewMobileSheet> {
  final TextEditingController _notesController = TextEditingController();
  CandidateData? _selectedCandidate;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final notifier = CreateNewInterviewMobileSheet._binding.readActions(ref);
    notifier.setAdditionalNotes(_notesController.text);

    final success = await notifier.submit();

    if (!mounted) return;

    if (success) {
      await widget.onSuccess?.call();
      if (!mounted) return;
      ToastService.success(context, 'Interview scheduled successfully');
      context.pop();
    } else {
      final state = ref.read(CreateNewInterviewMobileSheet._binding.formStateProvider);
      final message = state.submitError ?? state.fieldErrors.values.firstOrNull ?? 'Please correct the form errors';
      ToastService.error(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final formState = ref.watch(CreateNewInterviewMobileSheet._binding.formStateProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
            child: ScheduleInterviewFormBody(
              binding: CreateNewInterviewMobileSheet._binding,
              notesController: _notesController,
              selectedCandidate: _selectedCandidate,
              onCandidateSelected: (candidate) => setState(() => _selectedCandidate = candidate),
            ),
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
                  onPressed: formState.isSubmitting ? null : () => context.pop(),
                  height: 46,
                ),
              ),
              Gap(8.w),
              Expanded(
                child: AppButton.primary(
                  label: loc.hiringInterviewsNew,
                  isLoading: formState.isSubmitting,
                  onPressed: formState.isSubmitting ? null : _onSubmit,
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
