import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for job family deletion operation
class JobFamilyDeleteState {
  final bool isDeleting;
  final int? deletingId;
  final String? error;

  const JobFamilyDeleteState({
    this.isDeleting = false,
    this.deletingId,
    this.error,
  });

  JobFamilyDeleteState copyWith({
    bool? isDeleting,
    int? deletingId,
    String? error,
  }) {
    return JobFamilyDeleteState(
      isDeleting: isDeleting ?? this.isDeleting,
      deletingId: deletingId,
      error: error,
    );
  }

  JobFamilyDeleteState clearError() {
    return JobFamilyDeleteState(
      isDeleting: isDeleting,
      deletingId: deletingId,
      error: null,
    );
  }
}

/// Provider for job family deletion state
final jobFamilyDeleteStateProvider = StateProvider<JobFamilyDeleteState>(
  (ref) => const JobFamilyDeleteState(),
);
