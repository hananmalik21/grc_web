import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/security_manager/data/config/roles_management/duty_role_form_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateDutyRoleSectionHeader extends StatelessWidget {
  const CreateDutyRoleSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.h),
      decoration: const BoxDecoration(
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

class CreateDutyRoleSelectionSummaryBanner extends StatelessWidget {
  const CreateDutyRoleSelectionSummaryBanner({
    super.key,
    required this.title,
    required this.selectedCount,
  });

  final String title;
  final int selectedCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.75.r),
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
            style: context.textTheme.labelSmall?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class CreateDutyRoleSelectableCheckbox extends StatelessWidget {
  const CreateDutyRoleSelectableCheckbox({
    super.key,
    required this.isSelected,
    this.onTap,
  });

  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.75.r),
      child: Container(
        width: 16.88.w,
        height: 16.88.w,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(4.75.r),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.cardBorder, width: 1.4),
        ),
        alignment: Alignment.center,
        child: isSelected ? Icon(Icons.check_rounded, size: 14.sp, color: AppColors.buttonTextLight) : null,
      ),
    );
  }
}

class CreateDutyRoleFunctionRoleEmptyState extends StatelessWidget {
  const CreateDutyRoleFunctionRoleEmptyState({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.sidebarSearchBg,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DigifyAsset(assetPath: DutyRoleFormConfig.functionRolesIconPath, width: 52, height: 52, color: AppColors.borderGrey),
          Gap(16.h),
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          ),
          Gap(8.h),
          Text(
            body,
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}
