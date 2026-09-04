import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';

class AiSocCopilotHeader extends StatelessWidget {
  const AiSocCopilotHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildLeftSection(context),
                const Gap(8),
                _buildRightSection(),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildLeftSection(context), _buildRightSection()],
            ),
    );
  }

  Widget _buildLeftSection(BuildContext context) {
    final isDark = context.isDark;
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: AppColors.teal.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.teal.withValues(alpha: 0.4)),
          ),
          child: Center(
            child: Icon(
              Icons.smart_toy_outlined,
              size: 18.sp,
              color: AppColors.teal,
            ),
          ),
        ),
        const Gap(10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'AI SOC Copilot',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Gap(2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: const BoxDecoration(
                    color: AppColors.cyberLiveGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                const Gap(5),
                Text(
                  'Online · Claude Sonnet 4.6',
                  style: TextStyle(
                    color: AppColors.cyberLiveGreen,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRightSection() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.gavel_outlined,
          size: 13.sp,
          color: AppColors.textPlaceholderDark,
        ),
        const Gap(6),
        Text(
          'All actions require human approval',
          style: TextStyle(
            color: AppColors.textPlaceholderDark,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
