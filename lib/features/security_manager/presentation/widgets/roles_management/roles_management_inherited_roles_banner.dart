import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RolesManagementInheritedRolesBanner extends StatelessWidget {
  const RolesManagementInheritedRolesBanner({
    super.key,
    required this.roleLabels,
    this.title = 'Inheriting from Selected Roles',
  });

  /// Each entry is displayed as a capsule — pass `'Name · CODE'` strings.
  final List<String> roleLabels;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.infoBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title (${roleLabels.length})',
            style: context.textTheme.labelLarge?.copyWith(
              fontSize: 13.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final label in roleLabels)
                DigifySquareCapsule(
                  label: label,
                  backgroundColor: AppColors.cardBackground,
                  textColor: AppColors.textPrimary,
                  borderColor: AppColors.primary,
                  borderRadius: BorderRadius.circular(6.r),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
