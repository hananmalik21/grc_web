import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/features/leave_management/presentation/screens/policy_configuration_permission_mixin.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/label_value_pair.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PolicyDetailsHeader extends StatelessWidget with PolicyConfigurationPermissionMixin {
  final String policyName;
  final String leaveTypeName;
  final String leaveTypeNameArabic;
  final String lastModified;
  final String selectedBy;
  final bool isEditing;
  final bool isSaving;
  final VoidCallback? onEditPressed;
  final VoidCallback? onCancelPressed;
  final VoidCallback? onSavePressed;
  final bool isDark;

  const PolicyDetailsHeader({
    super.key,
    required this.policyName,
    required this.leaveTypeName,
    required this.leaveTypeNameArabic,
    required this.lastModified,
    required this.selectedBy,
    this.isEditing = false,
    this.isSaving = false,
    this.onEditPressed,
    this.onCancelPressed,
    this.onSavePressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: context.isMobile
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context),
    );
  }

  Widget _buildInfoBlock(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          policyName,
          style: context.textTheme.headlineMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(4.h),
        Row(
          children: [
            Text(
              leaveTypeName,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
            Text(
              ' - ',
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
            Text(
              leaveTypeNameArabic,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        Gap(14.h),
        Row(
          spacing: 24.w,
          children: [
            LabelValuePair(label: 'Last Modified', value: lastModified, isDark: isDark),
            LabelValuePair(label: 'Modified By', value: selectedBy, isDark: isDark),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildInfoBlock(context)),
        if (canUpdatePolicyConfiguration) ...[
          Gap(12.w),
          if (isEditing) ...[
            AppButton.outline(label: 'Cancel', onPressed: isSaving ? null : onCancelPressed),
            Gap(7.w),
            AppButton.primary(
              label: 'Save',
              svgPath: Assets.icons.saveConfigIcon.path,
              onPressed: isSaving ? null : onSavePressed,
              isLoading: isSaving,
            ),
          ] else
            AppButton.primary(
              label: 'Edit Policy',
              svgPath: Assets.icons.editIconGreen.path,
              onPressed: onEditPressed,
            ),
        ],
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoBlock(context),
        if (canUpdatePolicyConfiguration) ...[
          Gap(12.h),
          if (isEditing)
            Row(
              spacing: 8.w,
              children: [
                Expanded(
                  child: AppButton.outline(label: 'Cancel', onPressed: isSaving ? null : onCancelPressed),
                ),
                Expanded(
                  child: AppButton.primary(
                    label: 'Save',
                    svgPath: Assets.icons.saveConfigIcon.path,
                    onPressed: isSaving ? null : onSavePressed,
                    isLoading: isSaving,
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                label: 'Edit Policy',
                svgPath: Assets.icons.editIconGreen.path,
                onPressed: onEditPressed,
              ),
            ),
        ],
      ],
    );
  }
}
