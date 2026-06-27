import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/hiring/application/candidates/controllers/candidate_resume_controller.dart'
    show candidateResumeControllerProvider;
import 'package:grc/features/hiring/application/candidates/providers/candidate_resume_providers.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/overview/candidate_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CandidateResumeCard extends ConsumerWidget {
  const CandidateResumeCard({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resume = candidate.primaryResume;
    if (resume == null) return const SizedBox.shrink();

    final resumeKey = _resumeKey(resume);
    final isOpening = ref.watch(candidateResumeOpeningProvider(resumeKey));
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final subTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final fileSizeKb = (resume.fileSize / 1024).toStringAsFixed(1);

    return CandidateSectionCard(
      title: 'Resume',
      isDark: isDark,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.description_outlined, size: 28.r, color: AppColors.primary),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(resume.fileName, style: context.textTheme.titleSmall?.copyWith(color: textColor)),
                Gap(4.h),
                Text(
                  '${resume.fileType} · $fileSizeKb KB',
                  style: context.textTheme.bodySmall?.copyWith(color: subTextColor),
                ),
              ],
            ),
          ),
          AppButton.outline(
            label: 'View',
            isLoading: isOpening,
            onPressed: isOpening
                ? null
                : () => ref.read(candidateResumeControllerProvider).openResume(context, resume: resume),
          ),
        ],
      ),
    );
  }

  String _resumeKey(CandidateResumeData resume) {
    final resumeGuid = resume.resumeGuid.trim();
    if (resumeGuid.isNotEmpty) return resumeGuid;
    return resume.resumeId.toString();
  }
}
