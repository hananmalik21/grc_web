import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeGridCard extends StatelessWidget {
  final EmployeeListItem employee;
  final AppLocalizations localizations;
  final bool isDark;
  final VoidCallback? onView;
  final VoidCallback? onMore;

  const EmployeeGridCard({
    super.key,
    required this.employee,
    required this.localizations,
    required this.isDark,
    this.onView,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final titleColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    final cardBackgroundColor = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 2.w),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppAvatar(
                    image: null,
                    fallbackInitial: employee.fullName,
                    size: 80.w,
                    backgroundColor: AppColors.infoBg,
                    showStatusDot: false,
                  ),
                  Gap(16.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 44.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            employee.fullNameDisplay.toUpperCase(),
                            style: textTheme.headlineMedium?.copyWith(color: titleColor, fontSize: 16.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Gap(4.h),
                          Text(
                            employee.employeeIdDisplay,
                            style: textTheme.labelSmall?.copyWith(color: secondaryColor, fontSize: 12.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Gap(24.h),
              _LabelValueRow(
                label: localizations.position,
                value: employee.positionDisplay,
                labelColor: secondaryColor,
                valueColor: titleColor,
                textTheme: textTheme,
              ),
              Gap(12.h),
              _LabelValueRow(
                label: localizations.department,
                value: employee.departmentDisplay.toUpperCase(),
                labelColor: secondaryColor,
                valueColor: titleColor,
                textTheme: textTheme,
              ),
              Gap(12.h),
              _LabelValueRow(
                label: localizations.email,
                value: employee.emailDisplay,
                labelColor: secondaryColor,
                valueColor: titleColor,
                textTheme: textTheme,
              ),
              Gap(12.h),
              _LabelValueRow(
                label: localizations.phone,
                value: employee.phoneDisplay,
                labelColor: secondaryColor,
                valueColor: titleColor,
                textTheme: textTheme,
              ),
              DigifyDivider.horizontal(
                margin: EdgeInsets.symmetric(vertical: 24.h),
                color: borderColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusCapsule(),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onView,
                      borderRadius: BorderRadius.circular(10.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.primary, width: 1.w),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              localizations.view,
                              style: textTheme.headlineMedium?.copyWith(color: AppColors.primary, fontSize: 14.sp),
                            ),
                            Gap(6.w),
                            DigifyAsset(
                              assetPath: Assets.icons.employeeManagement.arrowRight.path,
                              width: 16,
                              height: 16,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: DigifyAssetButton(
              assetPath: Assets.icons.employeeManagement.more.path,
              onTap: onMore,
              width: 20,
              height: 20,
              padding: 8.w,
              borderRadius: BorderRadius.circular(10.r),
              color: secondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCapsule() {
    final isProbation = employee.status.toLowerCase().contains('probation');
    final label = employee.statusDisplay.toUpperCase();
    return DigifyCapsule(
      label: label,
      iconPath: isProbation ? Assets.icons.clockIcon.path : null,
      backgroundColor: isProbation ? AppColors.warningBg : AppColors.activeStatusBg,
      textColor: isProbation ? AppColors.warningText : AppColors.successText,
      borderColor: isProbation ? AppColors.warningBorder : AppColors.activeStatusBorder,
    );
  }
}

class _LabelValueRow extends StatelessWidget {
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final TextTheme textTheme;

  const _LabelValueRow({
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90.w,
          child: Text(
            label,
            style: textTheme.labelMedium?.copyWith(color: labelColor, fontSize: 12.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Gap(8.w),
        Expanded(
          child: Text(
            value,
            style: textTheme.titleSmall?.copyWith(color: valueColor, fontSize: 12.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
