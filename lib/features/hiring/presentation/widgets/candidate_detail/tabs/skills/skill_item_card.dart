import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SkillItemCard extends StatelessWidget {
  const SkillItemCard({super.key, required this.skill, required this.isDark});

  final CandidateSkillData skill;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                skill.name,
                style: context.textTheme.titleSmall?.copyWith(color: textPrimary, fontSize: 15.sp),
              ),
              if (skill.isVerified) ...[
                Gap(8.w),
                DigifyAsset(
                  assetPath: Assets.icons.checkIconGreen.path,
                  color: AppColors.success,
                  width: 16.w,
                  height: 16.w,
                ),
              ],
            ],
          ),
          Text(skill.experience, style: context.textTheme.bodyMedium?.copyWith(color: textSecondary)),
        ],
      ),
    );
  }
}
