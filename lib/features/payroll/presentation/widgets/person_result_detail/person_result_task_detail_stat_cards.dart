import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultTaskDetailStatCardData {
  const PersonResultTaskDetailStatCardData({required this.label, required this.value, required this.iconPath});

  final String label;
  final String value;
  final String iconPath;
}

class PersonResultTaskDetailStatCards extends StatelessWidget {
  const PersonResultTaskDetailStatCards({super.key, required this.cards});

  final List<PersonResultTaskDetailStatCardData> cards;

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
                Expanded(child: PersonResultTaskDetailStatCard(data: cards[index])),
                Gap(cardGap),
                Expanded(
                  child: index + 1 < cards.length
                      ? PersonResultTaskDetailStatCard(data: cards[index + 1])
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
          Expanded(child: PersonResultTaskDetailStatCard(data: cards[index])),
        ],
      ],
    );
  }
}

class PersonResultTaskDetailStatCard extends StatelessWidget {
  const PersonResultTaskDetailStatCard({super.key, required this.data});

  final PersonResultTaskDetailStatCardData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 19.h),
      decoration: BoxDecoration(
        color: AppColors.onPrimary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.onPrimary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.label,
                  style: context.textTheme.bodyMedium?.copyWith(color: AppColors.cardBackground.withValues(alpha: 0.8)),
                ),
              ),
              DigifyAsset(assetPath: data.iconPath, width: 22, height: 22, color: AppColors.cardBackground),
            ],
          ),
          Gap(10.h),
          Text(data.value, style: context.textTheme.headlineMedium?.copyWith(color: AppColors.cardBackground)),
        ],
      ),
    );
  }
}
