import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/services/responsive_service.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';

enum AppStatCardSize {
  compact,
  standard,
}

class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.value,
    required this.label,
    this.iconAsset,
    this.iconTint,
    this.trendLabel,
    this.trendIconAsset = 'assets/figma/dashboard/svg/trend.svg',
    this.labelColor,
    this.size = AppStatCardSize.compact,
    this.onTap,
  });

  final String value;
  final String label;
  final String? iconAsset;
  final Color? iconTint;
  final String? trendLabel;
  final String trendIconAsset;
  final Color? labelColor;
  final AppStatCardSize size;
  final VoidCallback? onTap;

  bool get _hasHeader => iconAsset != null || trendLabel != null;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final dense = context.screenLayout.isCompact;
    final padding = dense ? 12.w : (size == AppStatCardSize.compact ? 17.w : 25.w);
    final iconBoxSize = dense ? 36.r : 45.r;
    final iconInnerSize = dense ? 20.r : 26.r;
    final valueFontSize = dense ? 20.sp : 24.sp;
    final trendFontSize = dense ? 13.sp : 16.sp;

    final card = Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_hasHeader) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (iconAsset != null)
                  Container(
                    width: iconBoxSize,
                    height: iconBoxSize,
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        iconAsset!,
                        width: iconInnerSize,
                        height: iconInnerSize,
                        colorFilter: ColorFilter.mode(
                          iconTint ?? AppColors.primary,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                if (trendLabel != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        trendIconAsset,
                        width: 14.r,
                        height: 14.r,
                        colorFilter: ColorFilter.mode(colorScheme.primary, BlendMode.srcIn),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        trendLabel!,
                        style: textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontSize: trendFontSize),
                        strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                        textHeightBehavior: AppTextMetrics.textHeight,
                      ),
                    ],
                  ),
              ],
            ),
            SizedBox(height: dense ? 8.h : 10.h),
          ],
          Text(
            value,
            style: textTheme.headlineSmall?.copyWith(fontSize: valueFontSize),
            strutStyle: AppTextMetrics.strut(fontSize: valueFontSize, lineHeight: 32),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          SizedBox(height: _hasHeader ? 4.h : 0),
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: labelColor ?? AppColors.textBody,
              fontWeight: FontWeight.w400,
              fontSize: dense ? 12.sp : 14.sp,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            strutStyle: AppTextMetrics.strut(fontSize: dense ? 12 : 14, lineHeight: 20),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
        ],
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: card,
      ),
    );
  }
}

class AppStatCardsRow extends StatelessWidget {
  const AppStatCardsRow({
    super.key,
    required this.cards,
    this.height,
    this.cardWidth,
    this.scrollable = false,
    this.spacing = 16,
    this.size = AppStatCardSize.compact,
  });

  final List<AppStatCard> cards;
  final double? height;
  final double? cardWidth;
  final bool scrollable;
  final double spacing;
  final AppStatCardSize size;

  @override
  Widget build(BuildContext context) {
    if (scrollable) {
      return SizedBox(
        height: height,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int i = 0; i < cards.length; i++) ...[
                SizedBox(
                  width: cardWidth ?? 354.w,
                  height: height,
                  child: cards[i],
                ),
                if (i != cards.length - 1) SizedBox(width: spacing.w),
              ],
            ],
          ),
        ),
      );
    }

    if (height != null) {
      return SizedBox(
        height: height,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < cards.length; i++) ...[
              Expanded(child: cards[i]),
              if (i != cards.length - 1) SizedBox(width: spacing.w),
            ],
          ],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < cards.length; i++) ...[
          Expanded(child: cards[i]),
          if (i != cards.length - 1) SizedBox(width: spacing.w),
        ],
      ],
    );
  }
}
