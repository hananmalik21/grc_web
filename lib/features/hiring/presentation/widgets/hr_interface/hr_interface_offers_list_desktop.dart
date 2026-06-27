import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/pagination_controls.dart';
import 'package:grc/features/hiring/application/hr_interface/config/hr_interface_offers_list_config.dart';
import 'package:grc/features/hiring/presentation/providers/hr_interface/hr_interface_accepted_offers_provider.dart';
import 'package:grc/features/hiring/presentation/providers/hr_interface/hr_interface_offers_controller.dart';
import 'package:grc/features/hiring/presentation/widgets/hr_interface/hr_interface_offer_card_desktop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HrInterfaceOffersListDesktop extends ConsumerWidget {
  const HrInterfaceOffersListDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final liveOffersAsync = ref.watch(hrInterfaceAcceptedOffersListProvider);
    final liveOffers = liveOffersAsync.valueOrNull ?? const [];
    final isLoading = ref.watch(hrInterfaceAcceptedOffersIsLoadingProvider);
    final errorMessage = ref.watch(hrInterfaceAcceptedOffersErrorProvider);
    final skeletonOffers = ref.watch(hrInterfaceAcceptedOffersSkeletonItemsProvider);
    final offers = isLoading && liveOffers.isEmpty ? skeletonOffers : liveOffers;
    final currentPage = ref.watch(hrInterfaceOffersCurrentPageProvider);
    final totalPages = ref.watch(hrInterfaceAcceptedOffersTotalPagesProvider);
    final totalItems = ref.watch(hrInterfaceAcceptedOffersTotalItemsProvider);
    final hasNext = ref.watch(hrInterfaceAcceptedOffersHasNextProvider);
    final hasPrevious = ref.watch(hrInterfaceAcceptedOffersHasPreviousProvider);
    final controller = ref.read(hrInterfaceOffersControllerProvider);

    if (errorMessage != null && liveOffers.isEmpty) {
      return Column(
        children: [
          _buildErrorState(context, loc, errorMessage, controller),
          Gap(24.h),
          _buildPagination(controller, currentPage, totalPages, totalItems, hasNext, hasPrevious, isLoading),
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
          Gap(24.h),
          _buildPagination(controller, currentPage, totalPages, totalItems, hasNext, hasPrevious, isLoading),
        ],
      );
    }

    return Column(
      children: [
        Skeletonizer(
          enabled: isLoading,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: offers.length,
            separatorBuilder: (context, index) => Gap(16.h),
            itemBuilder: (context, index) {
              return HrInterfaceOfferCardDesktop(offer: offers[index]);
            },
          ),
        ),
        Gap(24.h),
        _buildPagination(controller, currentPage, totalPages, totalItems, hasNext, hasPrevious, isLoading),
      ],
    );
  }

  Widget _buildErrorState(
    BuildContext context,
    AppLocalizations loc,
    String errorMessage,
    HrInterfaceOffersController controller,
  ) {
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
            AppButton.outline(label: loc.retry, onPressed: controller.retry),
          ],
        ),
      ),
    );
  }

  Widget _buildPagination(
    HrInterfaceOffersController controller,
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
      pageSize: HrInterfaceOffersListConfig.pageSize,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
      isLoading: false,
      onPrevious: hasPrevious && !isLoading ? controller.goToPreviousPage : null,
      onNext: hasNext && !isLoading ? controller.goToNextPage : null,
    );
  }
}
