import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Primary login button widget with gradient and loading state
class LoginPrimaryButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onTap;

  const LoginPrimaryButton({super.key, required this.text, required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF4F39F6)]),
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 15, offset: const Offset(0, 10)),
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10.r),
          child: SizedBox(
            height: 48.h,
            child: Center(
              child: isLoading
                  ? SizedBox(
                      child: AppLoadingIndicator(color: Colors.white, type: LoadingType.circle, size: 20.0),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.lock_outline, size: 20.sp, color: Colors.white),
                        SizedBox(width: 8.w),
                        Text(
                          text,
                          style: TextStyle(
                            fontSize: 15.5.sp.clamp(13.5, 16.5),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
