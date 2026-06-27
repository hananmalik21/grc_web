import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/feedback/table_empty_state.dart';
import 'package:grc/features/hiring/presentation/providers/interviews/interviews_controller_provider.dart';
import 'package:grc/features/hiring/presentation/providers/interviews/interviews_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/providers/interviews/interviews_table_provider.dart';
import 'package:grc/features/hiring/presentation/screens/interviews_tab/interviews_tab_config.dart';
import 'package:grc/features/hiring/presentation/widgets/interviews/scheduled_interviews_grid.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class InterviewsListMobile extends ConsumerWidget {
  const InterviewsListMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;

    final liveItemsAsync = ref.watch(interviewsListProvider);
    final liveItems = liveItemsAsync.valueOrNull ?? const [];
    final isLoading = ref.watch(interviewsTableIsLoadingProvider);
    final errorMessage = ref.watch(interviewsTableErrorProvider);
    final skeletonItems = ref.watch(interviewsSkeletonItemsProvider);

    final items = isLoading && liveItems.isEmpty ? skeletonItems : liveItems;

    final currentPage = ref.watch(interviewsCurrentPageProvider);
    final totalPages = ref.watch(interviewsTotalPagesProvider);
    final totalItems = ref.watch(interviewsTotalItemsProvider);
    final hasNext = ref.watch(interviewsHasNextProvider);
    final hasPrevious = ref.watch(interviewsHasPreviousProvider);
    final controller = ref.read(interviewsControllerProvider);

    if (errorMessage != null && liveItems.isEmpty) {
      return _buildErrorState(context, errorMessage, ref);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Skeletonizer(
          enabled: isLoading && liveItems.isEmpty,
          child: ScheduledInterviewsGrid(interviews: items),
        ),
        if (!isLoading && liveItems.isEmpty)
          TableEmptyState(
            width: double.infinity,
            iconPath: Assets.icons.hiring.videoMeet.path,
            title: loc.hiringInterviews,
            message: loc.hiringInterviewsDescription,
          ),
        Gap(32.h),
        PaginationControls(
          currentPage: currentPage,
          totalPages: totalPages,
          totalItems: totalItems,
          pageSize: InterviewsTabConfig.pageSize,
          hasNext: hasNext,
          hasPrevious: hasPrevious,
          isLoading: false,
          onPrevious: hasPrevious && !isLoading ? controller.previousPage : null,
          onNext: hasNext && !isLoading ? controller.nextPage : null,
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, String errorMessage, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 24.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context)!.hiringInterviews,
            style: context.textTheme.titleMedium?.copyWith(color: AppColors.error),
          ),
          Gap(8.h),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          Gap(16.h),
          AppButton.outline(
            label: AppLocalizations.of(context)!.retry,
            onPressed: ref.read(interviewsControllerProvider).retryFetch,
          ),
        ],
      ),
    );
  }
}
