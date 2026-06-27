import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/leave_management/presentation/providers/leave_balance_summary_list_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AllLeaveBalancesStatsSection extends ConsumerStatefulWidget {
  const AllLeaveBalancesStatsSection({super.key});

  @override
  ConsumerState<AllLeaveBalancesStatsSection> createState() => _AllLeaveBalancesStatsSectionState();
}

class _AllLeaveBalancesStatsSectionState extends ConsumerState<AllLeaveBalancesStatsSection> {
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
    final localizations = AppLocalizations.of(context)!;
    final listState = ref.watch(leaveBalanceSummaryListProvider);
    final items = listState.items;
    final isLoading = listState.isLoading;

    final employeeCount = items.length;
    final totalAnnual = items.fold<double>(0, (sum, item) => sum + item.annualLeave);
    final totalSick = items.fold<double>(0, (sum, item) => sum + item.sickLeave);
    final lowBalanceCount = items.where((item) => item.totalAvailable <= 5).length;
    final avgAnnual = employeeCount == 0 ? 0.0 : totalAnnual / employeeCount;
    final avgSick = employeeCount == 0 ? 0.0 : totalSick / employeeCount;

    final cards = [
      _StatCardData(
        title: localizations.totalEmployees,
        value: '$employeeCount',
        iconPath: Assets.icons.employeesBlueIcon.path,
      ),
      _StatCardData(
        title: 'Avg Annual Leave',
        value: '${avgAnnual.toStringAsFixed(1)} days',
        iconPath: Assets.icons.leaveManagement.emptyLeave.path,
      ),
      _StatCardData(
        title: 'Avg Sick Leave',
        value: '${avgSick.toStringAsFixed(1)} days',
        iconPath: Assets.icons.workforce.fillRate.path,
      ),
      _StatCardData(
        title: 'Low Balance Alerts',
        value: '$lowBalanceCount',
        iconPath: Assets.icons.warningIcon.path,
      ),
    ];

    final cardWidth = ResponsiveHelper.getResponsiveWidth(context, mobile: 220, tablet: 236, web: 252);
    final spacing = ResponsiveHelper.getResponsiveWidth(context, mobile: 12, tablet: 16, web: 20);

    return Skeletonizer(
      enabled: isLoading,
      child: Scrollbar(
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
                SizedBox(width: cardWidth, child: _StatCard(data: cards[index])),
                if (index < cards.length - 1) Gap(spacing),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCardData {
  const _StatCardData({required this.title, required this.value, required this.iconPath});

  final String title;
  final String value;
  final String iconPath;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.data});

  final _StatCardData data;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                Gap(6.h),
                Text(
                  data.value,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontSize: 20.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Gap(12.w),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.22) : AppColors.infoBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: data.iconPath, width: 20, height: 20, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
