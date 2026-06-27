import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/hiring/application/candidates/providers/create_candidate_provider.dart';
import 'package:grc/features/hiring/presentation/utils/candidate_resume_attachment.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/add_candidate_form_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddCandidateMobileSheet extends ConsumerStatefulWidget {
  const AddCandidateMobileSheet({super.key});

  @override
  ConsumerState<AddCandidateMobileSheet> createState() => _AddCandidateMobileSheetState();
}

class _AddCandidateMobileSheetState extends ConsumerState<AddCandidateMobileSheet> {
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
      Navigator.pop(context);
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

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CandidatePersonalSection(
                  firstNameController: _firstNameController,
                  middleNameController: _middleNameController,
                  lastNameController: _lastNameController,
                  singleColumn: true,
                ),
                Gap(20.h),
                CandidateContactSection(emailController: _emailController, state: state, singleColumn: true),
                Gap(20.h),
                CandidateProfessionalSection(
                  currentTitleController: _currentTitleController,
                  currentEmployerController: _currentEmployerController,
                  yearsOfExperienceController: _yearsOfExperienceController,
                  currentLocationController: _currentLocationController,
                  singleColumn: true,
                ),
                Gap(20.h),
                CandidateAdditionalSection(
                  expectedSalaryController: _expectedSalaryController,
                  linkedinProfileController: _linkedinProfileController,
                  state: state,
                  dropdownFillColor: dropdownFillColor,
                  singleColumn: true,
                ),
                Gap(20.h),
                const DigifyDivider.horizontal(),
                Gap(20.h),
                const CandidateEducationOptionalSection(),
                Gap(20.h),
                const CandidateWorkExperienceOptionalSection(),
                Gap(20.h),
                CandidateResumeSection(state: state, onPickResume: _pickResume, uploadLabel: 'Tap to upload resume'),
                Gap(8.h),
              ],
            ),
          ),
        ),
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton.primary(label: 'Add Candidate', isLoading: state.isSubmitting, onPressed: _onSubmit),
              Gap(10.h),
              AppButton.outline(label: 'Cancel', onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),
      ],
    );
  }
}
