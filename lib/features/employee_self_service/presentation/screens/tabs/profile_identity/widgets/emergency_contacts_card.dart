import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/employee_self_service/presentation/providers/profile_identity/profile_identity_state.dart';
import 'package:grc/features/employee_self_service/presentation/widgets/ess_surface_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmergencyContactsCard extends StatelessWidget {
  final EmergencyContact? primaryContact;
  final VoidCallback onAddEmergencyContact;

  const EmergencyContactsCard({super.key, required this.primaryContact, required this.onAddEmergencyContact});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return EssSurfaceCard(
      title: 'Emergency Contacts',
      titleIconPath: Assets.icons.infoCircleAttendance.path,
      titleIconColor: AppColors.error,
      child: Column(
        children: [
          if (primaryContact != null) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.errorBgDark : AppColors.alertCriticalBg.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: isDark ? AppColors.errorBorderDark : AppColors.alertCriticalBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          primaryContact!.name,
                          style: context.textTheme.headlineMedium?.copyWith(
                            fontSize: 14.sp,
                            color: context.themeTextPrimary,
                          ),
                        ),
                        Gap(2.h),
                        Text(
                          '${primaryContact!.relationshipLabel} • Primary Contact',
                          style: context.textTheme.labelMedium?.copyWith(color: AppColors.sidebarSecondaryText),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    primaryContact!.phoneNumber,
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontSize: 12.sp,
                      color: AppColors.emergencyContactPhoneText,
                    ),
                  ),
                ],
              ),
            ),
            Gap(12.h),
          ],
          AppButton.dotted(
            label: 'Add Emergency Contact',
            svgPath: Assets.icons.addDivisionIcon.path,
            onPressed: onAddEmergencyContact,
            borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            foregroundColor: AppColors.sidebarCategoryText,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
