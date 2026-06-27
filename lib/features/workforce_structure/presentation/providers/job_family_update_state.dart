import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for job family update operation
class JobFamilyUpdateState {
  final bool isUpdating;
  final int? updatingId;
  final String? error;

  const JobFamilyUpdateState({
    this.isUpdating = false,
    this.updatingId,
    this.error,
  });

  JobFamilyUpdateState copyWith({
    bool? isUpdating,
    int? updatingId,
    String? error,
  }) {
    return JobFamilyUpdateState(
      isUpdating: isUpdating ?? this.isUpdating,
      updatingId: updatingId,
      error: error,
    );
  }

  JobFamilyUpdateState clearError() {
    return JobFamilyUpdateState(
      isUpdating: isUpdating,
      updatingId: updatingId,
      error: null,
    );
  }
}

final jobFamilyUpdateStateProvider = StateProvider<JobFamilyUpdateState>(
  (ref) => const JobFamilyUpdateState(),
);
