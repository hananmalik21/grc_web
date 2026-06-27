import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ComponentStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtext;
  final String iconPath;
  final Color iconColor;
  final Color iconBgColor;
  final Color? subtextColor;

  const ComponentStatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtext,
    required this.iconPath,
    required this.iconColor,
    required this.iconBgColor,
    this.subtextColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final titleColor = isDark ? AppColors.textSecondaryDark : AppColors.dashboardStatLabel;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.dashboardStatValue;
    final effectiveSubtextColor = subtextColor ?? AppColors.statIconBlue;
    final iconBackgroundColor = isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : iconBgColor;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelMedium?.copyWith(color: titleColor, fontSize: 14.sp),
                ),
                Gap(2.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(fontSize: 22.sp, color: valueColor),
                ),
                if (subtext != null) ...[
                  Gap(6.h),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (subtext!.contains('+') || subtext!.toLowerCase().contains('month'))
                        DigifyAsset(
                          assetPath: Assets.icons.priceUpItem.path,
                          width: 12,
                          height: 12,
                          color: effectiveSubtextColor,
                        ),
                      if (subtext!.contains('+') || subtext!.toLowerCase().contains('month')) Gap(4.w),
                      Flexible(
                        child: Text(
                          subtext!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.labelSmall?.copyWith(color: effectiveSubtextColor, fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Gap(16.w),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(color: iconBackgroundColor, borderRadius: BorderRadius.circular(10.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: iconPath, width: 20, height: 20, color: iconColor),
          ),
        ],
      ),
    );
  }
}

class ComponentsStatGrid extends ConsumerStatefulWidget {
  const ComponentsStatGrid({super.key});

  @override
  ConsumerState<ComponentsStatGrid> createState() => _ComponentsStatGridState();
}

class _ComponentsStatGridState extends ConsumerState<ComponentsStatGrid> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const iconColor = AppColors.statIconBlue;
    const iconBgColor = AppColors.infoBg;

    final cardWidth = ResponsiveHelper.getResponsiveWidth(context, mobile: 220, tablet: 236, web: 252);
    final spacing = ResponsiveHelper.getResponsiveWidth(context, mobile: 12, tablet: 16, web: 20);

    final cards = [
      ComponentStatCard(
        title: 'Total Components',
        value: '10',
        subtext: '+2 this month',
        iconPath: Assets.icons.compensation.layers.path,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
      ),
      ComponentStatCard(
        title: 'Active',
        value: '7',
        subtext: 'Currently in use',
        iconPath: Assets.icons.activeDepartmentsIcon.path,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
      ),
      ComponentStatCard(
        title: 'Draft',
        value: '1',
        subtext: 'In preparation',
        iconPath: Assets.icons.editIcon.path,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
      ),
      ComponentStatCard(
        title: 'Payroll Mapped',
        value: '7',
        subtext: 'Ready for transfer',
        iconPath: Assets.icons.compensation.link.path,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
      ),
      ComponentStatCard(
        title: 'Formula Based',
        value: '8',
        subtext: 'Dynamic Calculation',
        iconPath: Assets.icons.compensation.calculator.path,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
      ),
      ComponentStatCard(
        title: 'Used in Plans',
        value: '43',
        subtext: 'Plan Allocations',
        iconPath: Assets.icons.employeeSelfService.learning.path,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
      ),
      ComponentStatCard(
        title: 'With Issues',
        value: '3',
        subtext: 'Needs Attention',
        iconPath: Assets.icons.leaveManagement.warning.path,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
        subtextColor: AppColors.error,
      ),
      ComponentStatCard(
        title: 'Config Health',
        value: '94%',
        subtext: 'Excellent',
        iconPath: Assets.icons.leaveManagement.shield.path,
        iconColor: iconColor,
        iconBgColor: iconBgColor,
        subtextColor: AppColors.success,
      ),
    ];

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < cards.length; index++) ...[
              SizedBox(width: cardWidth, child: cards[index]),
              if (index < cards.length - 1) Gap(spacing),
            ],
          ],
        ),
      ),
    );
  }
}
