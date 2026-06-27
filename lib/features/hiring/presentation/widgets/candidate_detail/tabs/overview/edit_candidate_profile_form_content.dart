import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/hiring/application/candidates/providers/create_candidate_provider.dart';
import 'package:grc/features/hiring/presentation/utils/candidate_resume_attachment.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/add_candidate_form_sections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditCandidateProfileFormContent extends ConsumerStatefulWidget {
  const EditCandidateProfileFormContent({
    super.key,
    required this.firstNameController,
    required this.middleNameController,
    required this.lastNameController,
    required this.emailController,
    required this.currentTitleController,
    required this.currentEmployerController,
    required this.yearsOfExperienceController,
    required this.currentLocationController,
    required this.expectedSalaryController,
    required this.linkedinProfileController,
    this.singleColumn = false,
  });

  final TextEditingController firstNameController;
  final TextEditingController middleNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController currentTitleController;
  final TextEditingController currentEmployerController;
  final TextEditingController yearsOfExperienceController;
  final TextEditingController currentLocationController;
  final TextEditingController expectedSalaryController;
  final TextEditingController linkedinProfileController;
  final bool singleColumn;

  @override
  ConsumerState<EditCandidateProfileFormContent> createState() => _EditCandidateProfileFormContentState();
}

class _EditCandidateProfileFormContentState extends ConsumerState<EditCandidateProfileFormContent> {
  Future<void> _pickResume() async {
    try {
      final attachment = await pickCandidateResumeAttachment();
      if (attachment != null) {
        ref.read(createCandidateProvider.notifier).setResume(attachment);
        if (mounted) {
          ToastService.success(context, 'Resume selected successfully');
        }
      } else if (mounted) {
        ToastService.error(context, 'Could not read the selected file. Please try again.');
      }
    } catch (e) {
      if (mounted) ToastService.error(context, 'Failed to pick file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final dropdownFillColor = isDark ? AppColors.inputBgDark : Colors.white;
    final state = ref.watch(createCandidateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 20.h,
      children: [
        CandidatePersonalSection(
          firstNameController: widget.firstNameController,
          middleNameController: widget.middleNameController,
          lastNameController: widget.lastNameController,
          singleColumn: widget.singleColumn,
        ),
        CandidateContactSection(
          emailController: widget.emailController,
          state: state,
          singleColumn: widget.singleColumn,
        ),
        CandidateProfessionalSection(
          currentTitleController: widget.currentTitleController,
          currentEmployerController: widget.currentEmployerController,
          yearsOfExperienceController: widget.yearsOfExperienceController,
          currentLocationController: widget.currentLocationController,
          singleColumn: widget.singleColumn,
        ),
        CandidateAdditionalSection(
          expectedSalaryController: widget.expectedSalaryController,
          linkedinProfileController: widget.linkedinProfileController,
          state: state,
          dropdownFillColor: dropdownFillColor,
          singleColumn: widget.singleColumn,
        ),
        const DigifyDivider.horizontal(),
        const CandidateEducationOptionalSection(),
        const CandidateWorkExperienceOptionalSection(),
        CandidateResumeSection(
          state: state,
          onPickResume: _pickResume,
          uploadLabel: widget.singleColumn ? 'Tap to upload resume' : 'Drop resume here or click to upload',
        ),
      ],
    );
  }
}
