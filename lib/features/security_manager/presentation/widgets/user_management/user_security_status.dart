import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

class UserSecurityStatus extends StatelessWidget {
  final bool is2FAEnabled;

  const UserSecurityStatus({super.key, required this.is2FAEnabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: is2FAEnabled ? AppColors.activeStatusBgLight : AppColors.orangeBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: is2FAEnabled ? AppColors.activeStatusBorderLight : AppColors.orangeBorder,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            Assets.icons.auth.secureShield.path,
            width: 14.w,
            height: 14.h,
            colorFilter: ColorFilter.mode(
              is2FAEnabled ? AppColors.activeStatusTextLight : AppColors.orange,
              BlendMode.srcIn,
            ),
          ),
          Gap(6.w),
          Text(
            is2FAEnabled ? '2FA On' : 'No 2FA',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: is2FAEnabled ? AppColors.activeStatusTextLight : AppColors.orange,
            ),
          ),
        ],
      ),
    );
  }
}
