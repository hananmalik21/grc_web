import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/models/cyber_security/ai_governance/ai_governance_models.dart';

class AiSecurityControlsCard extends StatelessWidget {
  const AiSecurityControlsCard({super.key});

  static const List<AiSecurityControl> defaultControls = [
    AiSecurityControl(name: 'Prompt injection prevention'),
    AiSecurityControl(name: 'Output validation before action'),
    AiSecurityControl(name: 'Tenant data isolation'),
    AiSecurityControl(name: 'Sensitive data masking (PII, secrets)'),
    AiSecurityControl(name: 'Prompt + response audit logging'),
    AiSecurityControl(name: 'Human approval for prod actions'),
    AiSecurityControl(name: 'Model performance monitoring'),
    AiSecurityControl(name: 'Hallucination detection', isPartial: true),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.cyberCardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'AI SECURITY CONTROLS',
            style: TextStyle(
              color: AppColors.textTertiaryDark,
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const Gap(14),
          ...defaultControls.map((ctrl) {
            return Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                children: [
                  Container(
                    width: 6.r,
                    height: 6.r,
                    decoration: BoxDecoration(
                      color: ctrl.statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Text(
                      ctrl.name,
                      style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 7.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: ctrl.statusColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4.r),
                      border: Border.all(
                        color: ctrl.statusColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      ctrl.statusLabel,
                      style: TextStyle(
                        color: ctrl.statusColor,
                        fontSize: 9.5.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
