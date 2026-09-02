import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';

class CyberKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData? icon;
  final Widget? trailingIcon;
  final Color? subtitleColor;
  final Color? accentColor;

  const CyberKpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    this.icon,
    this.trailingIcon,
    this.subtitleColor,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.cyberCardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.cyberCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    color: AppColors.textTertiaryDark,
                    fontSize: 9.5.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Gap(4),
              if (icon != null)
                Icon(icon, size: 14.sp, color: accentColor ?? AppColors.textTertiaryDark)
              else
                ?trailingIcon,
            ],
          ),
          const Gap(6),
          Text(
            value,
            style: TextStyle(
              color: AppColors.textPrimaryDark,
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Gap(3),
          Text(
            subtitle,
            style: TextStyle(
              color: subtitleColor ?? AppColors.textPlaceholderDark,
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
