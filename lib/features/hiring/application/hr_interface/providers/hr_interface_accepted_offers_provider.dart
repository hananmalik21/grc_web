import 'package:grc/features/hiring/application/hr_interface/config/hr_interface_offers_list_config.dart';
import 'package:grc/features/hiring/application/hr_interface/providers/hr_interface_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/offers/mappers/job_offer_mapper.dart';
import 'package:grc/features/hiring/application/offers/providers/job_offers_api_providers.dart';
import 'package:grc/features/hiring/domain/models/job_offers/offer_status_code.dart';
import 'package:grc/features/hiring/domain/models/offer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HrInterfaceAcceptedOffersPageResult {
  const HrInterfaceAcceptedOffersPageResult({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<Offer> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final bool hasNext;
  final bool hasPrevious;

  static const empty = HrInterfaceAcceptedOffersPageResult(
    items: [],
    totalItems: 0,
    totalPages: 1,
    currentPage: hrInterfaceOffersDefaultPage,
    hasNext: false,
    hasPrevious: false,
  );
}

final hrInterfaceOffersCurrentPageProvider = StateProvider.autoDispose<int>((ref) {
  return hrInterfaceOffersDefaultPage;
});

final hrInterfaceAcceptedOffersPageProvider = FutureProvider.autoDispose<HrInterfaceAcceptedOffersPageResult>((
  ref,
) async {
  ref.watch(hrInterfaceTabRefreshTickProvider);
  final enterpriseId = ref.watch(hrInterfaceTabEnterpriseIdProvider);
  final currentPage = ref.watch(hrInterfaceOffersCurrentPageProvider);

  if (enterpriseId == null) {
    return HrInterfaceAcceptedOffersPageResult.empty;
  }

  final response = await ref
      .read(getJobOffersUseCaseProvider)
      .call(
        enterpriseId: enterpriseId,
        page: currentPage,
        limit: HrInterfaceOffersListConfig.pageSize,
        status: OfferStatusCode.accepted,
      );

  final pagination = response.pagination;
  final items = response.items.map((dto) => toOfferListItem(dto.toDomain())).toList();

  return HrInterfaceAcceptedOffersPageResult(
    items: items,
    totalItems: pagination?.total ?? items.length,
    totalPages: pagination?.totalPages ?? 1,
    currentPage: pagination?.page ?? currentPage,
    hasNext: pagination?.hasNext ?? false,
    hasPrevious: pagination?.hasPrevious ?? false,
  );
});

final hrInterfaceAcceptedOffersListProvider = FutureProvider.autoDispose<List<Offer>>((ref) async {
  final page = await ref.watch(hrInterfaceAcceptedOffersPageProvider.future);
  return page.items;
});

final hrInterfaceAcceptedOffersTotalPagesProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(hrInterfaceAcceptedOffersPageProvider).valueOrNull?.totalPages ?? 1;
});

final hrInterfaceAcceptedOffersTotalItemsProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(hrInterfaceAcceptedOffersPageProvider).valueOrNull?.totalItems ?? 0;
});

final hrInterfaceAcceptedOffersHasNextProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(hrInterfaceAcceptedOffersPageProvider).valueOrNull?.hasNext ?? false;
});

final hrInterfaceAcceptedOffersHasPreviousProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(hrInterfaceAcceptedOffersPageProvider).valueOrNull?.hasPrevious ?? false;
});

final hrInterfaceAcceptedOffersIsLoadingProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(hrInterfaceAcceptedOffersPageProvider).isLoading;
});

final hrInterfaceAcceptedOffersErrorProvider = Provider.autoDispose<String?>((ref) {
  final async = ref.watch(hrInterfaceAcceptedOffersPageProvider);
  return async.hasError ? async.error.toString() : null;
});

final hrInterfaceAcceptedOffersSkeletonItemsProvider = Provider.autoDispose<List<Offer>>((ref) {
  return const [
    Offer(
      id: 'OFF-2026-000',
      candidateName: 'Loading Candidate',
      candidateInitials: 'LC',
      position: 'Loading Position',
      department: 'Loading Department',
      location: 'Loading Location',
      startDate: '2026-06-01',
      annualSalary: '0',
      status: 'ACCEPTED',
      level: 'EX1',
      type: 'Full Time',
      probationPeriod: '3 months',
    ),
    Offer(
      id: 'OFF-2026-001',
      candidateName: 'Loading Candidate',
      candidateInitials: 'LC',
      position: 'Loading Position',
      department: 'Loading Department',
      location: 'Loading Location',
      startDate: '2026-07-01',
      annualSalary: '0',
      status: 'ACCEPTED',
      level: 'EX2',
      type: 'Permanent',
      probationPeriod: '3 months',
    ),
  ];
});
