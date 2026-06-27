import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateJobRoleSectionHeader extends StatelessWidget {
  const CreateJobRoleSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
      ),
      child: Text(
        title,
        style: context.textTheme.titleSmall?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
      ),
    );
  }
}

class CreateJobRoleSelectionSummaryBanner extends StatelessWidget {
  const CreateJobRoleSelectionSummaryBanner({super.key, required this.title, required this.selectedCount});

  final String title;
  final int selectedCount;

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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            ),
          ),
          Text(
            '$selectedCount Selected',
            style: context.textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class CreateJobRoleSelectionCheckbox extends StatelessWidget {
  const CreateJobRoleSelectionCheckbox({super.key, required this.isSelected, this.onTap});

  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DigifyCheckbox(value: isSelected, size: 18.w, onChanged: onTap != null ? (_) => onTap!() : null);
  }
}
