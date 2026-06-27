import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State for work pattern creation operation
class WorkPatternCreateState {
  final bool isCreating;
  final String? error;

  const WorkPatternCreateState({this.isCreating = false, this.error});

  WorkPatternCreateState copyWith({bool? isCreating, String? error}) {
    return WorkPatternCreateState(isCreating: isCreating ?? this.isCreating, error: error);
  }

  WorkPatternCreateState clearError() {
    return WorkPatternCreateState(isCreating: isCreating, error: null);
  }
}

/// Provider for work pattern creation state
final workPatternCreateStateProvider = StateProvider<WorkPatternCreateState>((ref) => const WorkPatternCreateState());
