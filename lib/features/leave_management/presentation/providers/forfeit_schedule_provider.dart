import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grc/features/leave_management/data/datasources/forfeit_schedule_local_data_source.dart';
import 'package:grc/features/leave_management/data/repositories/forfeit_schedule_repository_impl.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_schedule_entry.dart';
import 'package:grc/features/leave_management/domain/repositories/forfeit_schedule_repository.dart';
import 'package:grc/features/leave_management/presentation/widgets/forfeit_processing/forfeit_processing_stepper.dart';
import 'package:grc/features/leave_management/data/datasources/forfeit_preview_local_data_source.dart';
import 'package:grc/features/leave_management/data/repositories/forfeit_preview_repository_impl.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_preview_employee.dart';
import 'package:grc/features/leave_management/domain/repositories/forfeit_preview_repository.dart';
import 'package:grc/features/leave_management/data/datasources/forfeit_processing_summary_local_data_source.dart';
import 'package:grc/features/leave_management/data/repositories/forfeit_processing_summary_repository_impl.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_processing_summary.dart';
import 'package:grc/features/leave_management/domain/repositories/forfeit_processing_summary_repository.dart';

final forfeitScheduleLocalDataSourceProvider = Provider<ForfeitScheduleLocalDataSource>((ref) {
  return ForfeitScheduleLocalDataSourceImpl();
});

final forfeitScheduleRepositoryProvider = Provider<ForfeitScheduleRepository>((ref) {
  return ForfeitScheduleRepositoryImpl(localDataSource: ref.watch(forfeitScheduleLocalDataSourceProvider));
});

class ForfeitScheduleState {
  final ForfeitScheduleEntry? selectedEntry;

  const ForfeitScheduleState({this.selectedEntry});

  ForfeitScheduleState copyWith({ForfeitScheduleEntry? selectedEntry}) {
    return ForfeitScheduleState(selectedEntry: selectedEntry ?? this.selectedEntry);
  }
}

class ForfeitScheduleNotifier extends StateNotifier<ForfeitScheduleState> {
  ForfeitScheduleNotifier() : super(const ForfeitScheduleState());

  void selectEntry(ForfeitScheduleEntry entry) {
    state = state.copyWith(selectedEntry: entry);
  }

  void clearSelection() {
    state = state.copyWith(selectedEntry: null);
  }
}

final forfeitScheduleNotifierProvider = StateNotifierProvider<ForfeitScheduleNotifier, ForfeitScheduleState>((ref) {
  return ForfeitScheduleNotifier();
});

final forfeitScheduleEntriesProvider = FutureProvider<List<ForfeitScheduleEntry>>((ref) async {
  final repository = ref.watch(forfeitScheduleRepositoryProvider);
  return repository.getForfeitScheduleEntries();
});

// Provider for managing the current step in forfeit processing
class ForfeitProcessingStepNotifier extends StateNotifier<ForfeitProcessingStep> {
  ForfeitProcessingStepNotifier() : super(ForfeitProcessingStep.upcomingForfeits);

  void setStep(ForfeitProcessingStep step) {
    state = step;
  }

  void nextStep() {
    switch (state) {
      case ForfeitProcessingStep.upcomingForfeits:
        state = ForfeitProcessingStep.previewReview;
        break;
      case ForfeitProcessingStep.previewReview:
        state = ForfeitProcessingStep.confirmRun;
        break;
      case ForfeitProcessingStep.confirmRun:
        state = ForfeitProcessingStep.resultsSummary;
        break;
      case ForfeitProcessingStep.resultsSummary:
        // Already at last step
        break;
    }
  }
}

final forfeitProcessingStepProvider = StateNotifierProvider<ForfeitProcessingStepNotifier, ForfeitProcessingStep>((
  ref,
) {
  return ForfeitProcessingStepNotifier();
});

// Providers for Forfeit Preview
final forfeitPreviewLocalDataSourceProvider = Provider<ForfeitPreviewLocalDataSource>((ref) {
  return ForfeitPreviewLocalDataSourceImpl();
});

final forfeitPreviewRepositoryProvider = Provider<ForfeitPreviewRepository>((ref) {
  return ForfeitPreviewRepositoryImpl(localDataSource: ref.watch(forfeitPreviewLocalDataSourceProvider));
});

final forfeitPreviewEmployeesProvider = FutureProvider<List<ForfeitPreviewEmployee>>((ref) async {
  final repository = ref.watch(forfeitPreviewRepositoryProvider);
  return repository.getForfeitPreviewEmployees();
});

// Providers for Forfeit Processing Summary
final forfeitProcessingSummaryLocalDataSourceProvider = Provider<ForfeitProcessingSummaryLocalDataSource>((ref) {
  return ForfeitProcessingSummaryLocalDataSourceImpl();
});

final forfeitProcessingSummaryRepositoryProvider = Provider<ForfeitProcessingSummaryRepository>((ref) {
  return ForfeitProcessingSummaryRepositoryImpl(
    localDataSource: ref.watch(forfeitProcessingSummaryLocalDataSourceProvider),
  );
});

final forfeitProcessingSummaryProvider = FutureProvider<ForfeitProcessingSummary>((ref) async {
  final repository = ref.watch(forfeitProcessingSummaryRepositoryProvider);
  return repository.getForfeitProcessingSummary();
});
