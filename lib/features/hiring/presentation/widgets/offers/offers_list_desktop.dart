import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/hiring/application/offers/config/offers_list_config.dart';
import 'package:grc/features/hiring/presentation/providers/offers/offers_list_provider.dart';
import 'package:grc/features/hiring/presentation/providers/offers/offers_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/widgets/offers/offer_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OffersListDesktop extends ConsumerWidget {
  const OffersListDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final liveOffersAsync = ref.watch(offersListProvider);
    final liveOffers = liveOffersAsync.valueOrNull ?? const [];
    final isLoading = ref.watch(offersListIsLoadingProvider);
    final errorMessage = ref.watch(offersListErrorProvider);
    final skeletonOffers = ref.watch(offersSkeletonItemsProvider);
    final offers = isLoading && liveOffers.isEmpty ? skeletonOffers : liveOffers;
    final currentPage = ref.watch(offersCurrentPageProvider);
    final totalPages = ref.watch(offersTotalPagesProvider);
    final totalItems = ref.watch(offersTotalItemsProvider);
    final hasNext = ref.watch(offersHasNextProvider);
    final hasPrevious = ref.watch(offersHasPreviousProvider);

    if (errorMessage != null && liveOffers.isEmpty) {
      return Column(
        children: [
          _buildErrorState(context, loc, errorMessage, ref),
          Gap(32.h),
          _buildPagination(ref, currentPage, totalPages, totalItems, hasNext, hasPrevious, isLoading),
        ],
      );
    }

    if (offers.isEmpty && !isLoading) {
      return Column(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Text(loc.noResultsFound),
            ),
          ),
          Gap(32.h),
          _buildPagination(ref, currentPage, totalPages, totalItems, hasNext, hasPrevious, isLoading),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Skeletonizer(
          enabled: isLoading,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: offers.length,
            separatorBuilder: (context, index) => Gap(16.h),
            itemBuilder: (context, index) {
              return OfferCard(offer: offers[index], onDownloadSigned: () {}, onConvertToEmployee: () {});
            },
          ),
        ),
        Gap(32.h),
        _buildPagination(ref, currentPage, totalPages, totalItems, hasNext, hasPrevious, isLoading),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context, AppLocalizations loc, String errorMessage, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              loc.hiringOffersLoadErrorTitle,
              style: context.textTheme.titleMedium?.copyWith(color: AppColors.error),
            ),
            Gap(8.h),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
            Gap(16.h),
            AppButton.outline(label: loc.retry, onPressed: () => ref.invalidate(offersPageProvider)),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination(
    WidgetRef ref,
    int currentPage,
    int totalPages,
    int totalItems,
    bool hasNext,
    bool hasPrevious,
    bool isLoading,
  ) {
    return PaginationControls(
      currentPage: currentPage,
      totalPages: totalPages,
      totalItems: totalItems,
      pageSize: OffersListConfig.pageSize,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
      isLoading: false,
      onPrevious: hasPrevious && !isLoading
          ? () => ref.read(offersCurrentPageProvider.notifier).state = currentPage - 1
          : null,
      onNext: hasNext && !isLoading ? () => ref.read(offersCurrentPageProvider.notifier).state = currentPage + 1 : null,
    );
  }
}
