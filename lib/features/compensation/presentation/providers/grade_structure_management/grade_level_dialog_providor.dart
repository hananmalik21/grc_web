import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/grade_structure_management/grade_record.dart';

class GradeLevelFormState {
  final String? gradeIdentifier;
  final String? progressionSteps;
  final String? institutionalDescription;
  final String? minSalary;
  final String? maxSalary;
  final String? stepIncrementalGovernance;
  final bool isLoading;
  final bool clearError;
  final String? error;

  GradeLevelFormState({
    this.gradeIdentifier,
    this.progressionSteps,
    this.institutionalDescription,
    this.minSalary,
    this.maxSalary,
    this.stepIncrementalGovernance,
    this.isLoading = false,
    this.clearError = false,
    this.error,
  });

  GradeLevelFormState copyWith({
    String? gradeIdentifier,
    String? progressionSteps,
    String? institutionalDescription,
    String? minSalary,
    String? maxSalary,
    String? stepIncrementalGovernance,
    bool? isLoading,
    bool? clearError,
    String? error,
  }) {
    return GradeLevelFormState(
      gradeIdentifier: gradeIdentifier ?? this.gradeIdentifier,
      progressionSteps: progressionSteps ?? this.progressionSteps,
      institutionalDescription: institutionalDescription ?? this.institutionalDescription,
      minSalary: minSalary ?? this.minSalary,
      maxSalary: maxSalary ?? this.maxSalary,
      stepIncrementalGovernance: stepIncrementalGovernance ?? this.stepIncrementalGovernance,
      isLoading: isLoading ?? this.isLoading,
      clearError: clearError ?? this.clearError,
      error: error ?? this.error,
    );
  }
}

class GradeLevelDialogNotifier extends StateNotifier<GradeLevelFormState> {
  GradeLevelDialogNotifier() : super(GradeLevelFormState());

  void setInitialData(GradeRecord? gradeRecord) {
    if (gradeRecord != null) {
      state = state.copyWith(
        gradeIdentifier: gradeRecord.gradeLevel,
        progressionSteps: gradeRecord.steps,
        institutionalDescription: gradeRecord.description,
        minSalary: gradeRecord.minSalary,
        maxSalary: gradeRecord.maxSalary,
        stepIncrementalGovernance: gradeRecord.increment,
      );
    }
  }

  void updateGradeIdentifier(String value) {
    state = state.copyWith(gradeIdentifier: value);
  }

  void updateProgressionSteps(String value) {
    state = state.copyWith(progressionSteps: value);
  }

  void updateInstitutionalDescription(String value) {
    state = state.copyWith(institutionalDescription: value);
  }

  void updateMinSalary(String value) {
    state = state.copyWith(minSalary: value);
  }

  void updateMaxSalary(String value) {
    state = state.copyWith(maxSalary: value);
  }

  void updateStepIncrementalGovernance(String value) {
    state = state.copyWith(stepIncrementalGovernance: value);
  }

  Future<void> handleSubmit(WidgetRef ref) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 2));

      state = state.copyWith(isLoading: false, clearError: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString(), clearError: false);
    }
  }
}

final gradeLevelDialogProvider = StateNotifierProvider<GradeLevelDialogNotifier, GradeLevelFormState>(
  (ref) => GradeLevelDialogNotifier(),
);
