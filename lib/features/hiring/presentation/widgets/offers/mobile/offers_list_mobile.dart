import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/hiring/presentation/providers/offers/offers_list_provider.dart';
import 'package:grc/features/hiring/presentation/providers/offers/offers_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/widgets/offers/mobile/offer_card_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OffersListMobile extends ConsumerWidget {
  const OffersListMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final liveOffersAsync = ref.watch(offersListProvider);
    final liveOffers = liveOffersAsync.valueOrNull ?? const [];
    final isLoading = ref.watch(offersListIsLoadingProvider);
    final errorMessage = ref.watch(offersListErrorProvider);
    final skeletonOffers = ref.watch(offersSkeletonItemsProvider);
    final offers = isLoading && liveOffers.isEmpty ? skeletonOffers : liveOffers;
    final currentPage = ref.watch(offersCurrentPageProvider);
    final totalPages = ref.watch(offersTotalPagesProvider);
    final hasNext = ref.watch(offersHasNextProvider);
    final hasPrevious = ref.watch(offersHasPreviousProvider);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.dashboardCard,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (errorMessage != null && liveOffers.isEmpty)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: MobileStateCard(
                isDark: isDark,
                borderColor: isDark ? AppColors.cardBorderDark : AppColors.errorBorder,
                iconBackground: AppColors.errorBg,
                icon: Icon(Icons.wifi_off_rounded, size: 32.sp, color: AppColors.brandRed),
                title: loc.hiringOffersLoadErrorTitle,
                subtitle: errorMessage,
                action: GestureDetector(
                  onTap: () => ref.invalidate(offersPageProvider),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
                    decoration: BoxDecoration(color: AppColors.brandRed, borderRadius: BorderRadius.circular(10.r)),
                    child: Text(
                      loc.retry,
                      style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.buttonTextLight),
                    ),
                  ),
                ),
              ),
            )
          else
            Skeletonizer(
              enabled: isLoading,
              child: offers.isEmpty && !isLoading
                  ? Padding(
                      padding: EdgeInsets.all(16.w),
                      child: MobileStateCard(
                        isDark: isDark,
                        borderColor: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
                        iconBackground: isDark ? AppColors.cardBorderDark.withValues(alpha: 0.4) : AppColors.slateBg,
                        icon: Icon(
                          Icons.description_outlined,
                          size: 32.sp,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        ),
                        title: loc.noResultsFound,
                        subtitle: loc.noResultsFound,
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
                      itemCount: offers.length,
                      separatorBuilder: (_, _) => Gap(10.h),
                      itemBuilder: (context, index) {
                        return OfferCardMobile(
                          offer: offers[index],
                          onDownloadSigned: () {},
                          onConvertToEmployee: () {},
                        );
                      },
                    ),
            ),
          const DigifyDivider.horizontal(),
          MobilePaginationControls(
            isDark: isDark,
            currentPage: currentPage,
            totalPages: totalPages,
            hasPrevious: hasPrevious,
            hasNext: hasNext,
            onPrevious: hasPrevious && !isLoading
                ? () => ref.read(offersCurrentPageProvider.notifier).state = currentPage - 1
                : null,
            onNext: hasNext && !isLoading
                ? () => ref.read(offersCurrentPageProvider.notifier).state = currentPage + 1
                : null,
          ),
        ],
      ),
    );
  }
}
