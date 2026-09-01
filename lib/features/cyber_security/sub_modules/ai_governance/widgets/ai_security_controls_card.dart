import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/cyber_security/sub_modules/ai_governance/models/ai_governance_models.dart';

class AiSecurityControlsCard extends StatelessWidget {
  const AiSecurityControlsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controls = AiSecurityControl.getMockControls();

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            'AI SECURITY CONTROLS',
            style: TextStyle(
              color: const Color(0xFF64748B),
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
          const Gap(14),

          // Controls List
          ...controls.map((ctrl) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      ctrl.name,
                      style: TextStyle(
                        color: const Color(0xFFCBD5E1),
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.w,
                        height: 6.w,
                        decoration: BoxDecoration(
                          color: ctrl.statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const Gap(6),
                      Text(
                        ctrl.statusLabel,
                        style: TextStyle(
                          color: ctrl.statusColor,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
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
