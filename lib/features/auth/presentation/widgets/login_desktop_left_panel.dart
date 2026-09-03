import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginDesktopLeftPanel extends StatelessWidget {
  const LoginDesktopLeftPanel({super.key});

  static const Color skyBlue = Color(0xFF00B4D8);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image (Cyber Security Lock image)
        Image.asset(
          'assets/images/images.png',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),

        // Dark gradient overlay for text legibility
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.75),
                Colors.black.withValues(alpha: 0.40),
                Colors.black.withValues(alpha: 0.15),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
        ),

        // Content overlay
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 56.w, vertical: 64.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Enterprise Tag / Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: skyBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: skyBlue.withValues(alpha: 0.4),
                  ),
                ),
                child: const Text(
                  'ENTERPRISE PLATFORM',
                  style: TextStyle(
                    color: skyBlue,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                  ),
                ),
              ),
              Gap(24.h),

              // GRC Hero Title
              Text(
                'Governance\nRisk &\nCompliance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48.sp,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
              Gap(20.h),

              // Description
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 440.w),
                child: Text(
                  'Comprehensive Governance, Risk Management, and Compliance OS for modern enterprise operations.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 15.sp,
                    height: 1.5,
                  ),
                ),
              ),
              Gap(36.h),

              // Slide Indicators (Active Pill + Inactive Dots)
              Row(
                children: [
                  Container(
                    width: 28.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: skyBlue,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Gap(8.w),
                  Container(
                    width: 8.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Gap(8.w),
                  Container(
                    width: 8.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
