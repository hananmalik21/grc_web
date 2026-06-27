import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/security_manager/data/config/roles_management/data_role_form_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateDataRoleSectionTitle extends StatelessWidget {
  const CreateDataRoleSectionTitle({super.key, required this.iconPath, required this.title});

  final String iconPath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DigifyAsset(assetPath: iconPath, width: 20, height: 20, color: AppColors.primary),
        Gap(8.w),
        Text(title, style: context.textTheme.titleLarge?.copyWith(color: AppColors.textPrimary)),
      ],
    );
  }
}

class CreateDataRoleStepHeader extends StatelessWidget {
  const CreateDataRoleStepHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleLarge?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class CreateDataRoleHelperText extends StatelessWidget {
  const CreateDataRoleHelperText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DigifyAsset(assetPath: DataRoleFormConfig.infoIconPath, width: 14, height: 14, color: AppColors.textSecondary),
        Gap(5.w),
        Text(text, style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }
}

class CreateDataRoleSelectableChip extends StatelessWidget {
  const CreateDataRoleSelectableChip({super.key, required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.dataRoleScopeBg : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(11.r),
          border: Border.all(color: isSelected ? AppColors.dataRoleScopeBorder : AppColors.cardBorder),
        ),
        child: Text(
          label,
          style: context.textTheme.labelLarge?.copyWith(
            color: isSelected ? AppColors.dataRoleScopeText : AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class CreateDataRoleLogicButton extends StatelessWidget {
  const CreateDataRoleLogicButton({super.key, required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.sidebarActiveBg : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(11.r),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.cardBorder, width: isSelected ? 1.4 : 1),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: context.textTheme.labelLarge?.copyWith(
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
