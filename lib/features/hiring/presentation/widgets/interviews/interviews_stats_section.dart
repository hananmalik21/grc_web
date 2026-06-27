import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/features/hiring/domain/models/interview_status_code.dart';
import 'package:grc/features/hiring/presentation/providers/interviews/interviews_table_provider.dart';
import 'package:grc/features/hiring/presentation/screens/interviews_tab/interviews_tab_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class InterviewsStatsSection extends ConsumerStatefulWidget {
  const InterviewsStatsSection({super.key});

  @override
  ConsumerState<InterviewsStatsSection> createState() => _InterviewsStatsSectionState();
}

class _InterviewsStatsSectionState extends ConsumerState<InterviewsStatsSection> {
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
    final loc = AppLocalizations.of(context)!;
    final pageResult = ref.watch(interviewsPageProvider).valueOrNull;
    final items = pageResult?.items ?? const [];

    final total = pageResult?.totalItems ?? 0;
    final scheduled = items.where((i) => i.statusCode == InterviewStatusCode.scheduled).length;
    final completed = items.where((i) => i.statusCode == InterviewStatusCode.completed).length;
    final rescheduled = items.where((i) => i.statusCode == InterviewStatusCode.rescheduled).length;

    final cards = InterviewsTabConfig.buildStatCards(
      loc,
      total: total,
      scheduled: scheduled,
      completed: completed,
      rescheduled: rescheduled,
    );

    final cardWidth = ResponsiveHelper.getResponsiveWidth(context, mobile: 220, tablet: 236, web: 252);
    final spacing = ResponsiveHelper.getResponsiveWidth(context, mobile: 12, tablet: 16, web: 20);

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
              SizedBox(
                width: cardWidth,
                child: _InterviewStatCard(data: cards[index]),
              ),
              if (index < cards.length - 1) Gap(spacing),
            ],
          ],
        ),
      ),
    );
  }
}

class _InterviewStatCard extends StatelessWidget {
  final InterviewStatCardData data;

  const _InterviewStatCard({required this.data});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data.title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Gap(8.w),
              Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.22) : AppColors.infoBg,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: DigifyAsset(assetPath: data.iconPath, width: 16, height: 16, color: AppColors.primary),
              ),
            ],
          ),
          Gap(8.h),
          Text(
            data.value,
            style: context.textTheme.titleLarge?.copyWith(
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(4.h),
          Text(
            data.subtitle,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
