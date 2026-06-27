import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart' as shared_candidate;
import 'package:grc/features/hiring/presentation/widgets/requisition_detail/tabs/find_candidates/candidate_data.dart'
    as requisition_candidate;
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddCandidateAsApplicantDialog extends StatefulWidget {
  const AddCandidateAsApplicantDialog({required this.candidate, super.key});

  final Object candidate;

  static Future<void> show(BuildContext context, Object candidate) {
    return showDialog<void>(
      context: context,
      builder: (context) => AddCandidateAsApplicantDialog(candidate: candidate),
    );
  }

  @override
  State<AddCandidateAsApplicantDialog> createState() => _AddCandidateAsApplicantDialogState();
}

class _AddCandidateAsApplicantDialogState extends State<AddCandidateAsApplicantDialog> {
  final TextEditingController _notesController = TextEditingController();

  late String _selectedSource;
  late String _selectedStage;
  bool _sendNotificationEmail = true;
  bool _notifyHiringTeam = true;

  late final _ApplicantCandidateViewData _candidate;

  @override
  void initState() {
    super.initState();
    _candidate = _ApplicantCandidateViewData.fromCandidate(widget.candidate);
    _selectedSource = HiringConfig.applicationSourceOptions.contains(_candidate.source)
        ? _candidate.source!
        : HiringConfig.applicationSourceOptions.first;
    _selectedStage = HiringConfig.applicantStageOptions.first;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cardBackgroundColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarSearchBg;
    final inputFillColor = isDark ? AppColors.inputBgDark : Colors.white;

    return AppDialog(
      title: 'Add Candidate as Applicant',
      width: 536.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(color: cardBackgroundColor, borderRadius: BorderRadius.circular(10.r)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppAvatar(fallbackInitial: _candidate.name, size: 48.r),
                Gap(12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _candidate.name,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          fontSize: 18.sp,
                        ),
                      ),
                      Gap(2.h),
                      Text(
                        _candidate.subtitle,
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                      ),
                      Gap(12.h),
                      Row(
                        children: [
                          Expanded(
                            child: _CandidateStat(label: 'Email', value: _candidate.email),
                          ),
                          Gap(12.w),
                          Expanded(
                            child: _CandidateStat(label: 'Phone', value: _candidate.phone),
                          ),
                        ],
                      ),
                      Gap(12.h),
                      Row(
                        children: [
                          Expanded(
                            child: _CandidateStat(label: 'Experience', value: _candidate.experience),
                          ),
                          Gap(12.w),
                          Expanded(
                            child: _CandidateStat(label: 'Availability', value: _candidate.availability),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adding to Applicant Pipeline',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.infoTextDark : AppColors.infoText,
                  ),
                ),
                Gap(6.h),
                Text.rich(
                  TextSpan(
                    text: _candidate.pipelineTitle,
                    style: context.textTheme.headlineMedium?.copyWith(
                      color: isDark ? AppColors.infoTextDark : AppColors.roleActionBlue,
                      fontSize: 14.sp,
                    ),
                    children: [
                      TextSpan(
                        text: ' (REQ-2026-001)',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.infoTextDark : AppColors.roleActionBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap(16.h),
          DigifySelectFieldWithLabel<String>(
            label: 'Application Source',
            value: _selectedSource,
            isRequired: true,
            items: HiringConfig.applicationSourceOptions,
            itemLabelBuilder: (item) => item,
            hint: 'Select source',
            fillColor: inputFillColor,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedSource = value);
              }
            },
          ),
          Gap(16.h),
          DigifySelectFieldWithLabel<String>(
            label: 'Initial Stage',
            value: _selectedStage,
            isRequired: true,
            items: HiringConfig.applicantStageOptions,
            itemLabelBuilder: (item) => item,
            hint: 'Select stage',
            fillColor: inputFillColor,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedStage = value);
              }
            },
          ),
          Gap(6.h),
          Text(
            'Select the initial stage for this candidate in the hiring pipeline',
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          Gap(16.h),
          DigifyTextArea(
            labelText: 'Notes (Optional)',
            hintText: 'Add any notes about this candidate or why they\'re a good fit...',
            controller: _notesController,
            maxLines: 4,
            minLines: 4,
            fillColor: inputFillColor,
          ),
          Gap(16.h),
          DigifyCheckbox(
            value: _sendNotificationEmail,
            onChanged: (value) => setState(() => _sendNotificationEmail = value ?? false),
            label: 'Send notification email to candidate',
          ),
          Gap(12.h),
          DigifyCheckbox(
            value: _notifyHiringTeam,
            onChanged: (value) => setState(() => _notifyHiringTeam = value ?? false),
            label: 'Notify hiring team about new applicant',
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Cancel', onPressed: () => context.pop()),
        Gap(8.w),
        AppButton.primary(
          label: 'Add as Applicant',
          svgPath: Assets.icons.securityManager.addUser.path,
          onPressed: () {},
        ),
      ],
    );
  }
}

class _ApplicantCandidateViewData {
  const _ApplicantCandidateViewData({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.pipelineTitle,
    required this.pipelineSubtitle,
    required this.experience,
    required this.availability,
    required this.email,
    required this.phone,
    required this.source,
  });

  final String id;
  final String name;
  final String subtitle;
  final String pipelineTitle;
  final String pipelineSubtitle;
  final String experience;
  final String availability;
  final String email;
  final String phone;
  final String? source;

  factory _ApplicantCandidateViewData.fromCandidate(Object candidate) {
    if (candidate is shared_candidate.CandidateData) {
      return _ApplicantCandidateViewData(
        id: candidate.id,
        name: candidate.name,
        subtitle: '${candidate.jobTitle} at ${candidate.company}',
        pipelineTitle: candidate.jobTitle,
        pipelineSubtitle: '${candidate.location} • ${_availabilityLabel(candidate.noticePeriod)}',
        experience: candidate.experience,
        availability: _availabilityLabel(candidate.noticePeriod),
        email: candidate.email,
        phone: candidate.phone,
        source: candidate.sourcedFrom,
      );
    }

    if (candidate is requisition_candidate.CandidateData) {
      return _ApplicantCandidateViewData(
        id: candidate.id,
        name: candidate.name,
        subtitle: '${candidate.role} at ${candidate.company}',
        pipelineTitle: candidate.role,
        pipelineSubtitle: '${candidate.talentPool} • ${candidate.education}',
        experience: candidate.experience,
        availability: candidate.availability,
        email: candidate.email,
        phone: 'Not provided',
        source: candidate.talentPool,
      );
    }

    throw ArgumentError.value(candidate, 'candidate', 'Unsupported candidate type');
  }

  static String _availabilityLabel(String? noticePeriod) {
    if (noticePeriod == null || noticePeriod.trim().isEmpty) {
      return 'Available now';
    }

    final normalized = noticePeriod.trim();
    if (normalized.toLowerCase() == 'immediate') {
      return 'Immediate';
    }

    return normalized.toLowerCase().contains('available') ? normalized : 'Available in $normalized';
  }
}

class _CandidateStat extends StatelessWidget {
  const _CandidateStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          Gap(2.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
