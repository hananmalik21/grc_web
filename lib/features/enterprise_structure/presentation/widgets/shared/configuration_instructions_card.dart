import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfigurationInstructionsCard extends StatelessWidget {
  final String title;
  final List<String> instructions;
  final String? boldText;

  const ConfigurationInstructionsCard({
    super.key,
    required this.title,
    required this.instructions,
    this.boldText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: EdgeInsetsDirectional.all(12.w),
        tablet: EdgeInsetsDirectional.all(14.w),
        web: EdgeInsetsDirectional.all(17.w),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.infoBgDark
            : const Color(0xFFEFF6FF),
        border: Border.all(
          color: isDark
              ? AppColors.infoBorderDark
              : const Color(0xFFBEDBFF),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 14.sp : (isTablet ? 14.5.sp : 15.5.sp),
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.infoTextDark
                  : const Color(0xFF1C398E),
              height: 24 / 15.5,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: isMobile ? 6.h : 8.h),
          ...instructions.asMap().entries.map((entry) {
            final index = entry.key;
            final instruction = entry.value;
            final isFirst = index == 0 && boldText != null;

            return Padding(
              padding: EdgeInsetsDirectional.only(
                top: index > 0 ? 3.8.h : 0,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsetsDirectional.only(top: 6.h),
                    width: 4.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.infoTextDark
                          : const Color(0xFF193CB8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 9.5.w),
                  Expanded(
                    child: isFirst
                        ? Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: boldText!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? AppColors.infoTextDark
                                        : const Color(0xFF193CB8),
                                  ),
                                ),
                                TextSpan(
                                  text: instruction.substring(boldText!.length),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: isDark
                                        ? AppColors.infoTextDark
                                        : const Color(0xFF193CB8),
                                  ),
                                ),
                              ],
                            ),
                            style: TextStyle(
                              fontSize: isMobile ? 12.sp : (isTablet ? 12.5.sp : 13.6.sp),
                              height: 20 / 13.6,
                              letterSpacing: 0,
                            ),
                          )
                        : Text(
                            instruction,
                            style: TextStyle(
                              fontSize: isMobile 
                                  ? 12.sp 
                                  : (isTablet 
                                      ? (index == 1 || index == 3 ? 12.5.sp : 12.4.sp)
                                      : (index == 1 || index == 3 ? 13.6.sp : 13.5.sp)),
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppColors.infoTextDark
                                  : const Color(0xFF193CB8),
                              height: 20 / (index == 1 || index == 3 ? 13.6 : 13.5),
                              letterSpacing: 0,
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

