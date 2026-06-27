import 'package:grc/features/hiring/application/interviews/providers/interviews_api_providers.dart';
import 'package:grc/features/hiring/application/interviews/providers/interviews_filter_provider.dart';
import 'package:grc/features/hiring/application/interviews/providers/interviews_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/features/hiring/presentation/screens/interviews_tab/interviews_tab_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InterviewsPageResult {
  const InterviewsPageResult({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<Interview> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final bool hasNext;
  final bool hasPrevious;

  static const empty = InterviewsPageResult(
    items: [],
    totalItems: 0,
    totalPages: 1,
    currentPage: 1,
    hasNext: false,
    hasPrevious: false,
  );
}

final interviewsPageProvider = FutureProvider.autoDispose<InterviewsPageResult>((ref) async {
  ref.watch(interviewsTabRefreshTickProvider);
  final enterpriseId = ref.watch(interviewsTabEnterpriseIdProvider);
  final filters = ref.watch(interviewsFilterProvider);
  final currentPage = ref.watch(interviewsCurrentPageProvider);

  if (enterpriseId == null) {
    return InterviewsPageResult.empty;
  }

  final useCase = ref.watch(getInterviewsUseCaseProvider);
  final response = await useCase(enterpriseId: enterpriseId, page: currentPage, pageSize: InterviewsTabConfig.pageSize);

  final pagination = response.pagination;
  final filtered = _filterInterviews(response.items, filters);

  return InterviewsPageResult(
    items: filtered,
    totalItems: pagination?.total ?? filtered.length,
    totalPages: pagination?.totalPages ?? 1,
    currentPage: pagination?.page ?? currentPage,
    hasNext: pagination?.hasNext ?? false,
    hasPrevious: pagination?.hasPrevious ?? false,
  );
});

List<Interview> _filterInterviews(List<Interview> items, InterviewsFilterState filters) {
  final query = filters.searchQuery.trim().toLowerCase();
  final status = filters.status;

  return items.where((interview) {
    if (status != null) {
      final interviewStatus = interview.statusCode ?? interview.status.name.toUpperCase();
      if (interviewStatus != status.toUpperCase()) {
        return false;
      }
    }

    if (query.isEmpty) return true;

    final haystack = [
      interview.candidateName,
      interview.position,
      interview.interviewType,
      interview.roundInfo,
      interview.interviewTitle,
    ].join(' ').toLowerCase();

    return haystack.contains(query);
  }).toList();
}

final interviewsListProvider = FutureProvider.autoDispose<List<Interview>>((ref) async {
  final page = await ref.watch(interviewsPageProvider.future);
  return page.items;
});

final interviewsTableIsLoadingProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(interviewsPageProvider).isLoading;
});

final interviewsTableErrorProvider = Provider.autoDispose<String?>((ref) {
  final asyncValue = ref.watch(interviewsPageProvider);
  return asyncValue.hasError ? asyncValue.error.toString() : null;
});

final interviewsTotalPagesProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(interviewsPageProvider).valueOrNull?.totalPages ?? 1;
});

final interviewsTotalItemsProvider = Provider.autoDispose<int>((ref) {
  return ref.watch(interviewsPageProvider).valueOrNull?.totalItems ?? 0;
});

final interviewsHasNextProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(interviewsPageProvider).valueOrNull?.hasNext ?? false;
});

final interviewsHasPreviousProvider = Provider.autoDispose<bool>((ref) {
  return ref.watch(interviewsPageProvider).valueOrNull?.hasPrevious ?? false;
});

final interviewsSkeletonItemsProvider = Provider.autoDispose<List<Interview>>((ref) {
  return const [
    Interview(
      id: 0,
      candidateName: 'Loading Candidate',
      position: 'Software Engineer',
      status: InterviewStatus.scheduled,
      dateTime: null,
      interviewType: 'TECHNICAL',
      interviewers: ['Loading Interviewer'],
      roundInfo: 'Round 1',
    ),
    Interview(
      id: 0,
      candidateName: 'Loading Candidate',
      position: 'Product Manager',
      status: InterviewStatus.scheduled,
      dateTime: null,
      interviewType: 'HR',
      interviewers: ['Loading Interviewer'],
      roundInfo: 'Round 1',
    ),
  ];
});
