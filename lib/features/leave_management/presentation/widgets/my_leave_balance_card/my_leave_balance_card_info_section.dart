import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MyLeaveBalanceCardInfoSection extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color subtitleColor;
  final Widget? trailing;

  const MyLeaveBalanceCardInfoSection({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.subtitleColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(11.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  DigifyAsset(assetPath: iconPath, width: 14, height: 14, color: textColor),
                  Gap(4.w),
                  Text(title, style: context.textTheme.labelMedium?.copyWith(color: textColor)),
                ],
              ),
              if (trailing != null) trailing as Widget,
            ],
          ),
          Gap(7.h),
          Text(subtitle, style: context.textTheme.labelSmall?.copyWith(color: subtitleColor)),
        ],
      ),
    );
  }
}
