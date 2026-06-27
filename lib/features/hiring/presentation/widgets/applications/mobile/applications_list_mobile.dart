import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/hiring/presentation/models/application_table_row_data.dart';
import 'package:grc/features/hiring/application/applications/providers/applications_controller_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../screens/application_detail_page.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ApplicationsListMobile extends ConsumerWidget {
  const ApplicationsListMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final state = ref.watch(applicationsControllerProvider);
    final controller = ref.read(applicationsControllerProvider.notifier);
    final rows = state.displayRows;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.error != null && state.items.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: MobileStateCard(
                isDark: isDark,
                borderColor: isDark ? AppColors.cardBorderDark : AppColors.errorBorder,
                iconBackground: AppColors.errorBg,
                icon: Icon(Icons.wifi_off_rounded, size: 32.sp, color: AppColors.brandRed),
                title: 'Failed to load applications',
                subtitle: state.error!,
                action: GestureDetector(
                  onTap: controller.retryFetch,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
                    decoration: BoxDecoration(color: AppColors.brandRed, borderRadius: BorderRadius.circular(10.r)),
                    child: Text(
                      'Retry',
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.buttonTextLight),
                    ),
                  ),
                ),
              ),
            )
          else
            Skeletonizer(
              enabled: state.isLoading,
              child: rows.isEmpty && !state.isLoading
                  ? Padding(
                      padding: EdgeInsets.all(16.w),
                      child: MobileStateCard(
                        isDark: isDark,
                        borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
                        iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
                        icon: Icon(
                          Icons.layers_clear_rounded,
                          size: 32.sp,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                        title: 'No Applications Found',
                        subtitle: 'No applications match your search or filters.',
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                      itemCount: rows.length,
                      separatorBuilder: (_, _) => Gap(10.h),
                      itemBuilder: (context, index) => _ApplicationCard(row: rows[index], isDark: isDark),
                    ),
            ),
          const DigifyDivider.horizontal(),
          MobilePaginationControls(
            isDark: isDark,
            currentPage: state.currentPage,
            totalPages: state.totalPages,
            hasPrevious: state.hasPrevious,
            hasNext: state.hasNext,
            onPrevious: state.hasPrevious && !state.isLoading ? controller.previousPage : null,
            onNext: state.hasNext && !state.isLoading ? controller.nextPage : null,
          ),
        ],
      ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({required this.row, required this.isDark});

  final ApplicationTableRowData row;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final tileBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final appliedDate = DateFormat.yMMMd().format(row.appliedDate);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.pushNamed(ApplicationDetailPage.routeName, extra: row),
        borderRadius: BorderRadius.circular(10.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.w),
          decoration: BoxDecoration(
            color: tileBg,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: tileBorderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          row.candidateName,
                          style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Gap(2.h),
                        Text(
                          row.applicationId,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: AppColors.primary,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(8.w),
                  DigifyStatusCapsule(status: row.status),
                ],
              ),
              Gap(12.h),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Requisition',
                          style: context.textTheme.labelSmall?.copyWith(fontSize: 10.sp, color: subtitleColor),
                        ),
                        Gap(2.h),
                        Text(row.jobTitle, style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Applied Date',
                        style: context.textTheme.labelSmall?.copyWith(fontSize: 10.sp, color: subtitleColor),
                      ),
                      Gap(2.h),
                      Text(appliedDate, style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
              Gap(12.h),
              const DigifyDivider.thin(),
              Gap(12.h),
              Row(
                children: [
                  _buildStageCapsule(row.currentStage),
                  const Spacer(),
                  Text(row.source, style: context.textTheme.labelSmall?.copyWith(color: subtitleColor)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStageCapsule(String stage) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Text(
        stage.toUpperCase(),
        style: TextStyle(
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
