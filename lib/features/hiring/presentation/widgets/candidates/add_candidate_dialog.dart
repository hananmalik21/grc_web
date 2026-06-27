import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/hiring/application/candidates/providers/create_candidate_provider.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/add_candidate_form_sections.dart';
import 'package:grc/features/hiring/presentation/utils/candidate_resume_attachment.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/add_candidate_mobile_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AddCandidateDialog extends ConsumerStatefulWidget {
  const AddCandidateDialog({super.key});

  static Future<void> show(BuildContext context) {
    if (context.isMobileLayout) {
      return DigifyBottomSheet.show<void>(
        context,
        type: DigifyBottomSheetType.custom,
        title: 'Add New Candidate',
        barrierDismissible: false,
        child: const AddCandidateMobileSheet(),
      );
    }
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (context) => const AddCandidateDialog(),
    );
  }

  @override
  ConsumerState<AddCandidateDialog> createState() => _AddCandidateDialogState();
}

class _AddCandidateDialogState extends ConsumerState<AddCandidateDialog> {
  final _firstNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _currentTitleController = TextEditingController();
  final _currentEmployerController = TextEditingController();
  final _yearsOfExperienceController = TextEditingController();
  final _currentLocationController = TextEditingController();
  final _expectedSalaryController = TextEditingController();
  final _linkedinProfileController = TextEditingController();

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

  Future<void> _pickResume() async {
    try {
      final attachment = await pickCandidateResumeAttachment();
      if (attachment != null) {
        ref.read(createCandidateProvider.notifier).setResume(attachment);
        if (mounted) ToastService.success(context, 'Resume selected successfully');
      } else if (mounted) {
        ToastService.error(context, 'Could not read the selected file. Please try again.');
      }
    } catch (e) {
      if (mounted) ToastService.error(context, 'Failed to pick file: $e');
    }
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
      ToastService.success(context, 'Candidate added successfully');
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
    final isDark = context.isDark;
    final dropdownFillColor = isDark ? AppColors.inputBgDark : Colors.white;
    final state = ref.watch(createCandidateProvider);

    return AppDialog(
      title: 'Add New Candidate',
      width: 600.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 20.h,
        children: [
          CandidatePersonalSection(
            firstNameController: _firstNameController,
            middleNameController: _middleNameController,
            lastNameController: _lastNameController,
          ),
          CandidateContactSection(emailController: _emailController, state: state),
          CandidateProfessionalSection(
            currentTitleController: _currentTitleController,
            currentEmployerController: _currentEmployerController,
            yearsOfExperienceController: _yearsOfExperienceController,
            currentLocationController: _currentLocationController,
          ),
          CandidateAdditionalSection(
            expectedSalaryController: _expectedSalaryController,
            linkedinProfileController: _linkedinProfileController,
            state: state,
            dropdownFillColor: dropdownFillColor,
          ),
          const DigifyDivider.horizontal(),
          const CandidateEducationOptionalSection(),
          const CandidateWorkExperienceOptionalSection(),
          CandidateResumeSection(state: state, onPickResume: _pickResume),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Cancel', onPressed: () => context.pop()),
        SizedBox(width: 12.w),
        AppButton.primary(label: 'Add Candidate', isLoading: state.isSubmitting, onPressed: _onSubmit),
      ],
    );
  }
}
