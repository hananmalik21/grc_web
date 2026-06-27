import 'package:grc/features/hiring/presentation/models/application_table_row_data.dart';
import 'package:grc/features/hiring/application/applications/config/applications_list_config.dart';

const int applicationsDefaultPage = 1;

class ApplicationsState {
  const ApplicationsState({
    this.items = const [],
    this.currentPage = applicationsDefaultPage,
    this.totalPages = 1,
    this.totalItems = 0,
    this.hasNext = false,
    this.hasPrevious = false,
    this.isLoading = false,
    this.error,
    this.searchQuery = '',
    this.status,
    this.source,
    this.showFilters = false,
  });

  final List<ApplicationTableRowData> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNext;
  final bool hasPrevious;
  final bool isLoading;
  final String? error;
  final String searchQuery;
  final String? status;
  final String? source;
  final bool showFilters;

  factory ApplicationsState.initial() => const ApplicationsState();

  bool get hasActiveFilters => searchQuery.isNotEmpty || status != null || source != null;

  bool get showSkeleton => isLoading && items.isEmpty;

  List<ApplicationTableRowData> get skeletonRows => List.generate(
    ApplicationsListConfig.pageSize,
    (index) => ApplicationTableRowData(
      applicationGuid: 'skeleton-$index',
      applicationId: 'APP-2026-00000$index',
      candidateName: 'Candidate Name',
      candidateId: '0',
      jobTitle: 'Job Title',
      requisitionId: 'REQ-2026-00000$index',
      appliedDate: DateTime.now(),
      currentStage: 'Applied',
      status: 'New',
      source: 'Career Site',
    ),
  );

  List<ApplicationTableRowData> get displayRows => showSkeleton ? skeletonRows : items;

  ApplicationsState copyWith({
    List<ApplicationTableRowData>? items,
    int? currentPage,
    int? totalPages,
    int? totalItems,
    bool? hasNext,
    bool? hasPrevious,
    bool? isLoading,
    String? error,
    bool clearError = false,
    String? searchQuery,
    String? status,
    bool clearStatus = false,
    String? source,
    bool clearSource = false,
    bool? showFilters,
  }) {
    return ApplicationsState(
      items: items ?? this.items,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      searchQuery: searchQuery ?? this.searchQuery,
      status: clearStatus ? null : (status ?? this.status),
      source: clearSource ? null : (source ?? this.source),
      showFilters: showFilters ?? this.showFilters,
    );
  }
}
