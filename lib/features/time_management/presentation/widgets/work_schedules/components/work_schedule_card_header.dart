import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkScheduleCardHeader extends StatelessWidget {
  final String title;
  final String? titleArabic;
  final String year;
  final String code;
  final bool isActive;

  const WorkScheduleCardHeader({
    super.key,
    required this.title,
    this.titleArabic,
    required this.year,
    required this.code,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final titleFontSize = ResponsiveHelper.getResponsiveFontSize(context, mobile: 13, tablet: 14, web: 15.6);
    final subtitleFontSize = ResponsiveHelper.getResponsiveFontSize(context, mobile: 11, tablet: 12, web: 14);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyAsset(
              assetPath: Assets.icons.sidebar.workSchedules.path,
              width: 24,
              height: 24,
              color: AppColors.primary,
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                      fontSize: titleFontSize,
                    ),
                  ),
                  if (titleArabic != null && titleArabic!.isNotEmpty) ...[
                    Gap(4.h),
                    Text(
                      titleArabic!,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        fontSize: subtitleFontSize,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            DigifyStatusCapsule(status: isActive ? 'Active' : 'Inactive'),
          ],
        ),
        Gap(9.5.h),
        DigifySquareCapsule(
          label: code.toUpperCase(),
          backgroundColor: AppColors.jobRoleBg,
          textColor: AppColors.infoText,
        ),
      ],
    );
  }
}
