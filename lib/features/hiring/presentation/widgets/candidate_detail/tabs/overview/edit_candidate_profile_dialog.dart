import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/hiring/application/candidates/controllers/update_candidate_controller.dart';
import 'package:grc/features/hiring/application/candidates/providers/create_candidate_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/get_candidate_detail_provider.dart';
import 'package:grc/features/hiring/application/candidates/update_candidate_session.dart';
import 'package:grc/features/hiring/domain/models/candidates/candidate.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/overview/edit_candidate_profile_form_content.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/overview/edit_candidate_profile_mobile_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EditCandidateProfileDialog extends ConsumerWidget {
  const EditCandidateProfileDialog({super.key, required this.candidate});

  final CandidateData candidate;

  static Future<void> show(BuildContext context, CandidateData candidate) {
    if (context.isMobileLayout) {
      return EditCandidateProfileMobileSheet.show(context, candidate);
    }
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => EditCandidateProfileDialog(candidate: candidate),
    );
  }

  GetCandidateDetailParams _detailParams(WidgetRef ref) {
    final enterpriseId = ref.read(candidatesTabEnterpriseIdProvider) ?? 1;
    return GetCandidateDetailParams(enterpriseId: enterpriseId, candidateGuid: candidate.id);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final detailParams = _detailParams(ref);
    final detailAsync = ref.watch(getCandidateDetailProvider(detailParams));

    return detailAsync.when(
      loading: () => AppDialog(
        title: l10n.editCandidateProfile,
        width: 600.w,
        content: SizedBox(
          height: 200.h,
          child: const Center(child: AppLoadingIndicator()),
        ),
        actions: [AppButton.outline(label: l10n.cancel, onPressed: () => context.pop())],
      ),
      error: (error, _) => AppDialog(
        title: l10n.editCandidateProfile,
        width: 600.w,
        content: DigifyErrorState(
          message: error.toString(),
          onRetry: () => ref.invalidate(getCandidateDetailProvider(detailParams)),
        ),
        actions: [AppButton.outline(label: l10n.cancel, onPressed: () => context.pop())],
      ),
      data: (loadedCandidate) => ProviderScope(
        overrides: [
          updateCandidateSessionProvider.overrideWithValue(
            UpdateCandidateSession(candidate: loadedCandidate, enterpriseId: detailParams.enterpriseId),
          ),
          createCandidateProvider.overrideWith(UpdateCandidateNotifier.new),
        ],
        child: _EditCandidateProfileDialogBody(
          candidate: loadedCandidate,
          title: l10n.editCandidateProfile,
          cancelLabel: l10n.cancel,
          saveLabel: l10n.saveChanges,
        ),
      ),
    );
  }
}

class _EditCandidateProfileDialogBody extends ConsumerStatefulWidget {
  const _EditCandidateProfileDialogBody({
    required this.candidate,
    required this.title,
    required this.cancelLabel,
    required this.saveLabel,
  });

  final Candidate candidate;
  final String title;
  final String cancelLabel;
  final String saveLabel;

  @override
  ConsumerState<_EditCandidateProfileDialogBody> createState() => _EditCandidateProfileDialogBodyState();
}

class _EditCandidateProfileDialogBodyState extends ConsumerState<_EditCandidateProfileDialogBody> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _middleNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _currentTitleController;
  late final TextEditingController _currentEmployerController;
  late final TextEditingController _yearsOfExperienceController;
  late final TextEditingController _currentLocationController;
  late final TextEditingController _expectedSalaryController;
  late final TextEditingController _linkedinProfileController;

  @override
  void initState() {
    super.initState();
    final candidate = widget.candidate;
    _firstNameController = TextEditingController(text: candidate.firstName);
    _middleNameController = TextEditingController(text: candidate.middleName ?? '');
    _lastNameController = TextEditingController(text: candidate.lastName);
    _emailController = TextEditingController(text: candidate.email);
    _currentTitleController = TextEditingController(text: candidate.currentTitle ?? '');
    _currentEmployerController = TextEditingController(text: candidate.currentEmployer ?? '');
    _yearsOfExperienceController = TextEditingController(text: candidate.yearsExperience?.toString() ?? '');
    _currentLocationController = TextEditingController(text: candidate.currentLocation ?? '');
    _expectedSalaryController = TextEditingController(text: candidate.expectedSalary?.toString() ?? '');
    _linkedinProfileController = TextEditingController(text: candidate.linkedinProfile ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _currentTitleController.dispose();
    _currentEmployerController.dispose();
    _yearsOfExperienceController.dispose();
    _currentLocationController.dispose();
    _expectedSalaryController.dispose();
    _linkedinProfileController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final notifier = ref.read(createCandidateProvider.notifier);
    notifier.setFirstName(_firstNameController.text);
    notifier.setMiddleName(_middleNameController.text);
    notifier.setLastName(_lastNameController.text);
    notifier.setEmail(_emailController.text);
    notifier.setCurrentTitle(_currentTitleController.text);
    notifier.setCurrentEmployer(_currentEmployerController.text);
    notifier.setYearsOfExperience(_yearsOfExperienceController.text);
    notifier.setCurrentLocation(_currentLocationController.text);
    notifier.setExpectedSalary(_expectedSalaryController.text);
    notifier.setLinkedinProfile(_linkedinProfileController.text);

    final success = await notifier.submit();
    if (!mounted) return;

    if (success) {
      ToastService.success(context, 'Candidate updated successfully');
      context.pop();
    } else {
      final state = ref.read(createCandidateProvider);
      final firstError =
          state.submitError ?? state.fieldErrors.values.firstOrNull ?? 'Please fill all required fields correctly';
      ToastService.error(context, firstError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createCandidateProvider);

    return AppDialog(
      title: widget.title,
      width: 600.w,
      content: EditCandidateProfileFormContent(
        firstNameController: _firstNameController,
        middleNameController: _middleNameController,
        lastNameController: _lastNameController,
        emailController: _emailController,
        currentTitleController: _currentTitleController,
        currentEmployerController: _currentEmployerController,
        yearsOfExperienceController: _yearsOfExperienceController,
        currentLocationController: _currentLocationController,
        expectedSalaryController: _expectedSalaryController,
        linkedinProfileController: _linkedinProfileController,
      ),
      actions: [
        AppButton.outline(label: widget.cancelLabel, onPressed: () => context.pop()),
        SizedBox(width: 12.w),
        AppButton.primary(label: widget.saveLabel, isLoading: state.isSubmitting, onPressed: _onSubmit),
      ],
    );
  }
}
