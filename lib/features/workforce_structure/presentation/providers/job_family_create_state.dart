import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for job family creation operation
class JobFamilyCreateState {
  final bool isCreating;
  final String? error;

  const JobFamilyCreateState({this.isCreating = false, this.error});

  JobFamilyCreateState copyWith({bool? isCreating, String? error}) {
    return JobFamilyCreateState(
      isCreating: isCreating ?? this.isCreating,
      error: error,
    );
  }

  JobFamilyCreateState clearError() {
    return JobFamilyCreateState(isCreating: isCreating, error: null);
  }
}

/// Provider for job family creation state
final jobFamilyCreateStateProvider = StateProvider<JobFamilyCreateState>(
  (ref) => const JobFamilyCreateState(),
);
