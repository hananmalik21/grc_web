import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ViewWorkScheduleDialogHeader extends StatelessWidget {
  final String title;
  final String? titleArabic;
  final String year;
  final String code;

  const ViewWorkScheduleDialogHeader({
    super.key,
    required this.title,
    this.titleArabic,
    required this.year,
    required this.code,
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
            Container(
              width: 64.w,
              height: 64.h,
              decoration: BoxDecoration(color: AppColors.jobRoleBg, borderRadius: BorderRadius.circular(14.r)),
              alignment: Alignment.center,
              child: DigifyAsset(
                assetPath: Assets.icons.sidebar.workSchedules.path,
                width: 32,
                height: 32,
                color: AppColors.primary,
              ),
            ),

            Gap(16.w),
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
                  Gap(9.5.h),
                  DigifySquareCapsule(
                    label: code.toUpperCase(),
                    backgroundColor: AppColors.jobRoleBg,
                    textColor: AppColors.infoText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
