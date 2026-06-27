import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SuccessStatusCard extends StatelessWidget {
  final String text;

  const SuccessStatusCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.activeStatusBgLight,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.successBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyAsset(
            assetPath: Assets.icons.checkIconGreen.path,
            width: 16,
            height: 16,
            color: AppColors.holidayPaidText,
          ),
          Gap(12.w),
          Expanded(
            child: Text(
              text,
              style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.holidayPaidText),
            ),
          ),
        ],
      ),
    );
  }
}
