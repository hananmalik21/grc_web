import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ProfileSummaryCard extends StatelessWidget {
  final String fullName;
  final String jobTitle;
  final String nationalityLabel;
  final bool fillHeight;

  const ProfileSummaryCard({
    super.key,
    required this.fullName,
    required this.jobTitle,
    required this.nationalityLabel,
    this.fillHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return EssSurfaceCard(
      expandChild: fillHeight,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppAvatar(
              image: null,
              fallbackInitial: fullName,
              size: 108.w,
              border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.infoBg, width: 2),
            ),
            Gap(14.h),
            Text(
              fullName,
              textAlign: TextAlign.center,
              style: context.textTheme.titleSmall?.copyWith(color: AppColors.textPrimary),
            ),
            Gap(4.h),
            Text(
              jobTitle,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(color: AppColors.tableHeaderText),
            ),
            Gap(12.h),
            DigifyCapsule(
              label: nationalityLabel,
              iconPath: Assets.icons.tasksIcon.path,
              backgroundColor: AppColors.delegationApproveBg,
              textColor: AppColors.roleBadgeSystemText,
            ),
          ],
        ),
      ),
    );
  }
}
