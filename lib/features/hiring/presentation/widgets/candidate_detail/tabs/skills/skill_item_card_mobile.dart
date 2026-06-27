import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SkillItemCardMobile extends StatelessWidget {
  const SkillItemCardMobile({super.key, required this.skill, required this.isDark});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        skill.name,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: textPrimary,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (skill.isVerified) ...[
                      Gap(6.w),
                      DigifyAsset(
                        assetPath: Assets.icons.checkIconGreen.path,
                        color: AppColors.success,
                        width: 14.w,
                        height: 14.w,
                      ),
                    ],
                  ],
                ),
              ),
              _buildLevelBadge(skill.level),
            ],
          ),
          Gap(8.h),
          Text(
            skill.experience,
            style: context.textTheme.bodySmall?.copyWith(color: textSecondary, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelBadge(String level) {
    Color bgColor;
    Color textColor;

    switch (level.toLowerCase()) {
      case 'expert':
        bgColor = isDark ? AppColors.successBgDark : const Color(0xFFDCFCE7);
        textColor = isDark ? AppColors.successTextDark : const Color(0xFF008236);
        break;
      case 'advanced':
        bgColor = isDark ? AppColors.infoBgDark : const Color(0xFFDBEAFE);
        textColor = isDark ? AppColors.infoTextDark : const Color(0xFF1447E6);
        break;
      case 'intermediate':
        bgColor = isDark ? AppColors.warningBgDark : const Color(0xFFFEF9C2);
        textColor = isDark ? AppColors.warningTextDark : const Color(0xFFA65F00);
        break;
      default:
        bgColor = isDark ? AppColors.grayBgDark : AppColors.grayBg;
        textColor = isDark ? AppColors.grayTextDark : AppColors.grayText;
    }

    return DigifyCapsule(
      backgroundColor: bgColor,
      label: level,
      textColor: textColor,
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
    );
  }
}
