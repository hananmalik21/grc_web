import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_api_providers.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_filter_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/screens/candidates_tab/candidates_tab_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CandidatesPageResult {
  const CandidatesPageResult({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<CandidateData> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final bool hasNext;
  final bool hasPrevious;

  static const empty = CandidatesPageResult(
    items: [],
    totalItems: 0,
    totalPages: 1,
    currentPage: 1,
    hasNext: false,
    hasPrevious: false,
  );
}

final candidatesPageProvider = FutureProvider.autoDispose<CandidatesPageResult>((ref) async {
  ref.watch(candidatesTabRefreshTickProvider);
  final enterpriseId = ref.watch(candidatesTabEnterpriseIdProvider);
  final filters = ref.watch(candidatesFilterProvider);
  final currentPage = ref.watch(candidatesCurrentPageProvider);

  if (enterpriseId == null) {
    return CandidatesPageResult.empty;
  }

  final useCase = ref.watch(getCandidatesUseCaseProvider);
  final response = await useCase(enterpriseId: enterpriseId, page: currentPage, pageSize: CandidatesTabConfig.pageSize);

  final pagination = response.pagination;
  final uiCandidates = response.items.map((item) => item.toCandidateData()).toList();
  final filtered = _filterCandidates(uiCandidates, filters);

  return CandidatesPageResult(
    items: filtered,
    totalItems: pagination?.total ?? filtered.length,
    totalPages: pagination?.totalPages ?? 1,
    currentPage: pagination?.page ?? currentPage,
    hasNext: pagination?.hasNext ?? false,
    hasPrevious: pagination?.hasPrevious ?? false,
  );
});

List<CandidateData> _filterCandidates(List<CandidateData> items, CandidatesFilterState filters) {
  final query = filters.searchQuery.trim().toLowerCase();
  final status = filters.status;

  return items.where((candidate) {
    if (status != null && candidate.status.toUpperCase() != status.toUpperCase()) {
      return false;
    }
    if (query.isEmpty) return true;

    final haystack = [
      candidate.name,
      candidate.jobTitle,
      candidate.company,
      candidate.email,
      candidate.phone,
      candidate.location,
    ].join(' ').toLowerCase();

    return haystack.contains(query);
  }).toList();
}

final candidatesListProvider = FutureProvider.autoDispose<List<CandidateData>>((ref) async {
  final page = await ref.watch(candidatesPageProvider.future);
  return page.items;
});

final candidatesTableIsLoadingProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(candidatesPageProvider).isLoading;
});

final candidatesTableErrorProvider = Provider.autoDispose<String?>((ref) {
  final asyncValue = ref.watch(candidatesPageProvider);
  return asyncValue.hasError ? asyncValue.error.toString() : null;
});

final candidatesTotalPagesProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(candidatesPageProvider).valueOrNull?.totalPages ?? 1;
});

final candidatesTotalItemsProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(candidatesPageProvider).valueOrNull?.totalItems ?? 0;
});

final candidatesHasNextProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(candidatesPageProvider).valueOrNull?.hasNext ?? false;
});

final candidatesHasPreviousProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(candidatesPageProvider).valueOrNull?.hasPrevious ?? false;
});

final candidatesSkeletonRowsProvider = Provider.autoDispose<List<CandidateData>>((ref) {
  return [
    const CandidateData(
      id: 'sk-1',
      name: 'Loading Candidate',
      jobTitle: 'Software Engineer',
      company: 'Loading Company',
      rating: 4.5,
      email: 'loading.candidate@email.com',
      phone: '+1-555-0101',
      location: 'San Francisco, CA',
      experience: '6 Years',
      status: 'NEW',
      topSkills: ['Skill A', 'Skill B', 'Skill C'],
      tags: ['Sourced'],
    ),
    const CandidateData(
      id: 'sk-2',
      name: 'Loading Candidate',
      jobTitle: 'Product Manager',
      company: 'Loading Company',
      rating: 4.2,
      email: 'loading.candidate2@email.com',
      phone: '+1-555-0102',
      location: 'New York, NY',
      experience: '5 Years',
      status: 'NEW',
      topSkills: ['Skill X', 'Skill Y', 'Skill Z'],
      tags: ['Sourced'],
    ),
  ];
});
