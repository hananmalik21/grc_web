import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'candidate_section_card.dart';
import 'initiate_background_check_dialog.dart';

class CandidateBackgroundCheckCard extends StatelessWidget {
  const CandidateBackgroundCheckCard({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final status = candidate.backgroundCheckStatus.toUpperCase();
    final isCompleted = status == 'COMPLETED';
    final isPending = status == 'IN PROGRESS';

    final assetPath = isCompleted ? Assets.icons.checkIconGreen.path : Assets.icons.clockIcon.path;
    final iconColor = isCompleted
        ? AppColors.success
        : (isPending ? AppColors.warning : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary));

    return CandidateSectionCard(
      title: 'Background Check',
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(assetPath: assetPath, width: 20.w, height: 20.w, color: iconColor),
              Gap(8.w),
              Text(
                candidate.backgroundCheckStatus,
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 16.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          if (isPending) ...[
            Gap(8.h),
            Text(
              'A background check is currently pending. Please check back later.',
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          ],
          Gap(12.h),
          AppButton.primary(
            label: isPending
                ? 'Pending Background Check'
                : (isCompleted ? 'Background Check Completed' : 'Initiate Background Check'),
            onPressed: status == 'NOT STARTED' ? () => InitiateBackgroundCheckDialog.show(context, candidate) : null,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
