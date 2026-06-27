import 'package:grc/features/hiring/presentation/models/job_posting_view_data.dart';

class RequisitionJobPostingsState {
  const RequisitionJobPostingsState({this.items = const [], this.isLoading = false, this.error});

  final List<JobPostingViewData> items;
  final bool isLoading;
  final String? error;

  bool get showInitialLoading => isLoading && items.isEmpty;

  bool get isEmpty => !isLoading && error == null && items.isEmpty;

  RequisitionJobPostingsState copyWith({
    List<JobPostingViewData>? items,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return RequisitionJobPostingsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
