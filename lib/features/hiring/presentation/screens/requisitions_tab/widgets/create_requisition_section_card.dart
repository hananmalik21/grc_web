import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateRequisitionSectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const CreateRequisitionSectionCard({super.key, required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
          Gap(6.h),
          Text(subtitle, style: context.textTheme.bodyMedium?.copyWith(color: context.themeTextSecondary)),
          DigifyDivider.horizontal(margin: EdgeInsets.symmetric(vertical: 12.h)),
          child,
        ],
      ),
    );
  }
}
