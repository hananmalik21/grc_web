import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/core/widgets/mobile/mobile_state_card.dart';
import 'package:grc/features/hiring/presentation/providers/hr_interface/hr_interface_accepted_offers_provider.dart';
import 'package:grc/features/hiring/presentation/providers/hr_interface/hr_interface_offers_controller.dart';
import 'package:grc/features/hiring/presentation/widgets/hr_interface/hr_interface_offer_card_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HrInterfaceOffersListMobile extends ConsumerWidget {
  const HrInterfaceOffersListMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final liveOffersAsync = ref.watch(hrInterfaceAcceptedOffersListProvider);
    final liveOffers = liveOffersAsync.valueOrNull ?? const [];
    final isLoading = ref.watch(hrInterfaceAcceptedOffersIsLoadingProvider);
    final errorMessage = ref.watch(hrInterfaceAcceptedOffersErrorProvider);
    final skeletonOffers = ref.watch(hrInterfaceAcceptedOffersSkeletonItemsProvider);
    final offers = isLoading && liveOffers.isEmpty ? skeletonOffers : liveOffers;
    final currentPage = ref.watch(hrInterfaceOffersCurrentPageProvider);
    final totalPages = ref.watch(hrInterfaceAcceptedOffersTotalPagesProvider);
    final hasNext = ref.watch(hrInterfaceAcceptedOffersHasNextProvider);
    final hasPrevious = ref.watch(hrInterfaceAcceptedOffersHasPreviousProvider);
    final controller = ref.read(hrInterfaceOffersControllerProvider);

    return Column(
      children: [
        if (errorMessage != null && liveOffers.isEmpty)
          MobileStateCard(
            isDark: isDark,
            borderColor: isDark ? AppColors.cardBorderDark : AppColors.errorBorder,
            iconBackground: AppColors.errorBg,
            icon: Icon(Icons.wifi_off_rounded, size: 32.sp, color: AppColors.brandRed),
            title: loc.hiringOffersLoadErrorTitle,
            subtitle: errorMessage,
            action: GestureDetector(
              onTap: controller.retry,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.w),
                decoration: BoxDecoration(color: AppColors.brandRed, borderRadius: BorderRadius.circular(10.r)),
                child: Text(
                  loc.retry,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.buttonTextLight),
                ),
              ),
            ),
          )
        else
          Skeletonizer(
            enabled: isLoading,
            child: offers.isEmpty && !isLoading
                ? MobileStateCard(
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
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: offers.length,
                    separatorBuilder: (context, index) => Gap(12.h),
                    itemBuilder: (context, index) {
                      return HrInterfaceOfferCardMobile(offer: offers[index]);
                    },
                  ),
          ),
        Gap(16.h),
        MobilePaginationControls(
          isDark: isDark,
          currentPage: currentPage,
          totalPages: totalPages,
          hasPrevious: hasPrevious,
          hasNext: hasNext,
          onPrevious: hasPrevious && !isLoading ? controller.goToPreviousPage : null,
          onNext: hasNext && !isLoading ? controller.goToNextPage : null,
        ),
      ],
    );
  }
}
