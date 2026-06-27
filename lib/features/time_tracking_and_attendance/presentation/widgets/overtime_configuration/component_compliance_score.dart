import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../../../../gen/assets.gen.dart';

class ComponentComplianceScore extends ConsumerWidget {
  const ComponentComplianceScore({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.activeStructureIcon.path,
                color: AppColors.textPrimaryDark,

                height: 28.h,
                width: 28.w,
              ),
              Gap(8.w),
              Text(
                'Compliance Score',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryDark,
                ),
              ),
            ],
          ),
          Gap(12.h),
          Text(
            'Your overtime configuration is 100% compliant with Kuwait Labor Law No. 6/2010',
            style: context.textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimaryDark,
            ),
          ),
          Gap(12.h),
          Container(
            height: 14.h,
            decoration: ShapeDecoration(
              shape: StadiumBorder(
                side: BorderSide(color: AppColors.textPrimaryDark),
              ),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 140.w,
                height: 14.h,
                decoration: ShapeDecoration(
                  shape: StadiumBorder(),
                  color: AppColors.textPrimaryDark,
                  shadows: [
                    BoxShadow(
                      color: AppColors.textPrimaryDark.withValues(alpha: .6),
                      blurRadius: 10.r,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Gap(12.h),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'LEGAL RATING: AAA+',
              style: context.textTheme.labelLarge?.copyWith(
                color: AppColors.grayBorder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
