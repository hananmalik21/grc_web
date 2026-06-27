import 'package:grc/features/hiring/application/offers/config/offers_list_config.dart';
import 'package:grc/features/hiring/application/offers/mappers/job_offer_mapper.dart';
import 'package:grc/features/hiring/application/offers/providers/job_offers_api_providers.dart';
import 'package:grc/features/hiring/application/offers/providers/offers_filter_provider.dart';
import 'package:grc/features/hiring/application/offers/providers/offers_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/domain/models/job_offers/offer_status_code.dart';
import 'package:grc/features/hiring/domain/models/offer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OffersPageResult {
  const OffersPageResult({
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

  static const empty = OffersPageResult(
    items: [],
    totalItems: 0,
    totalPages: 1,
    currentPage: offersDefaultPage,
    hasNext: false,
    hasPrevious: false,
  );
}

final offersPageProvider = FutureProvider.autoDispose<OffersPageResult>((ref) async {
  ref.watch(offersTabRefreshTickProvider);
  final enterpriseId = ref.watch(offersTabEnterpriseIdProvider);
  final filters = ref.watch(offersFilterProvider);
  final currentPage = ref.watch(offersCurrentPageProvider);

  if (enterpriseId == null) {
    return OffersPageResult.empty;
  }

  final response = await ref
      .read(getJobOffersUseCaseProvider)
      .call(enterpriseId: enterpriseId, page: currentPage, limit: OffersListConfig.pageSize);

  final pagination = response.pagination;
  final filtered = _filterOffers(response.items.map((dto) => toOfferListItem(dto.toDomain())).toList(), filters);

  return OffersPageResult(
    items: filtered,
    totalItems: pagination?.total ?? filtered.length,
    totalPages: pagination?.totalPages ?? 1,
    currentPage: pagination?.page ?? currentPage,
    hasNext: pagination?.hasNext ?? false,
    hasPrevious: pagination?.hasPrevious ?? false,
  );
});

List<Offer> _filterOffers(List<Offer> offers, OffersFilterState filters) {
  final query = filters.searchQuery.trim().toLowerCase();
  final status = filters.status;

  return offers.where((offer) {
    if (status != null && !_matchesStatus(offer.status, status)) {
      return false;
    }
    if (query.isEmpty) return true;

    final haystack = [
      offer.id,
      offer.candidateName,
      offer.position,
      offer.department,
      offer.location,
      offer.status,
      offer.level,
      offer.type,
    ].join(' ').toLowerCase();

    return haystack.contains(query);
  }).toList();
}

bool _matchesStatus(String offerStatus, String filterStatus) {
  return OfferStatusCode.normalize(offerStatus) == OfferStatusCode.normalize(filterStatus);
}

final offersListProvider = FutureProvider.autoDispose<List<Offer>>((ref) async {
  final page = await ref.watch(offersPageProvider.future);
  return page.items;
});

final offersTotalPagesProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(offersPageProvider).valueOrNull?.totalPages ?? 1;
});

final offersTotalItemsProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(offersPageProvider).valueOrNull?.totalItems ?? 0;
});

final offersHasNextProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(offersPageProvider).valueOrNull?.hasNext ?? false;
});

final offersHasPreviousProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(offersPageProvider).valueOrNull?.hasPrevious ?? false;
});

final offersListIsLoadingProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(offersPageProvider).isLoading;
});

final offersListErrorProvider = Provider.autoDispose<String?>((ref) {
  final async = ref.watch(offersPageProvider);
  return async.hasError ? async.error.toString() : null;
});

final offersSkeletonItemsProvider = Provider.autoDispose<List<Offer>>((ref) {
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
      status: 'DRAFT',
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
      status: 'DRAFT',
      level: 'EX2',
      type: 'Permanent',
      probationPeriod: '3 months',
    ),
  ];
});
