import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultTaskDetailTabStatCardData {
  const PersonResultTaskDetailTabStatCardData({required this.value, required this.label, required this.iconPath});

  final String value;
  final String label;
  final String iconPath;
}

class PersonResultTaskDetailTabStatCards extends StatelessWidget {
  const PersonResultTaskDetailTabStatCards({super.key, required this.cards});

  final List<PersonResultTaskDetailTabStatCardData> cards;

  @override
  Widget build(BuildContext context) {
    final isCompact = context.screenLayout.isMobile;
    final cardGap = 16.w;

    if (isCompact) {
      return Column(
        children: [
          for (var index = 0; index < cards.length; index += 2) ...[
            if (index > 0) Gap(cardGap),
            Row(
              children: [
                Expanded(child: PersonResultTaskDetailTabStatCard(data: cards[index])),
                Gap(cardGap),
                Expanded(
                  child: index + 1 < cards.length
                      ? PersonResultTaskDetailTabStatCard(data: cards[index + 1])
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ],
        ],
      );
    }

    return Row(
      children: [
        for (var index = 0; index < cards.length; index++) ...[
          if (index > 0) Gap(cardGap),
          Expanded(child: PersonResultTaskDetailTabStatCard(data: cards[index])),
        ],
      ],
    );
  }
}

class PersonResultTaskDetailTabStatCard extends StatelessWidget {
  const PersonResultTaskDetailTabStatCard({super.key, required this.data});

  final PersonResultTaskDetailTabStatCardData data;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final iconBg = isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : AppColors.infoBg;

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 20.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: data.iconPath, width: 20, height: 20, color: AppColors.primary),
          ),
          Gap(14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  data.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                    height: 22.5 / 15,
                    color: valueColor,
                  ),
                ),
                Gap(2.h),
                Text(
                  data.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, height: 18 / 12, color: labelColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
