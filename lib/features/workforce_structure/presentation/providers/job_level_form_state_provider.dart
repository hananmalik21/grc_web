import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobLevelFormState {
  final Grade? selectedMinGrade;
  final Grade? selectedMaxGrade;

  const JobLevelFormState({this.selectedMinGrade, this.selectedMaxGrade});

  JobLevelFormState copyWith({
    Grade? selectedMinGrade,
    Grade? selectedMaxGrade,
    bool clearMinGrade = false,
    bool clearMaxGrade = false,
  }) {
    return JobLevelFormState(
      selectedMinGrade: clearMinGrade ? null : (selectedMinGrade ?? this.selectedMinGrade),
      selectedMaxGrade: clearMaxGrade ? null : (selectedMaxGrade ?? this.selectedMaxGrade),
    );
  }
}

class JobLevelFormNotifier extends StateNotifier<JobLevelFormState> {
  JobLevelFormNotifier(JobLevel? jobLevel) : super(_initialState(jobLevel)) {
    _needsResolve = _checkNeedsResolve(jobLevel);
    _minGradeIdToResolve = jobLevel?.minGradeId;
    _maxGradeIdToResolve = jobLevel?.maxGradeId;
  }

  bool _needsResolve = false;
  int? _minGradeIdToResolve;
  int? _maxGradeIdToResolve;

  static JobLevelFormState _initialState(JobLevel? jobLevel) {
    if (jobLevel == null) return const JobLevelFormState();
    final minG = jobLevel.minGrade;
    final maxG = jobLevel.maxGrade;
    final validMax = maxG != null && minG != null && _isGradeNumberHigherThan(maxG, minG) ? maxG : null;
    return JobLevelFormState(selectedMinGrade: minG, selectedMaxGrade: validMax);
  }

  static bool _checkNeedsResolve(JobLevel? jobLevel) {
    if (jobLevel == null) return false;
    final needsMin = jobLevel.minGrade == null && jobLevel.minGradeId != 0;
    final needsMax = jobLevel.maxGrade == null && jobLevel.maxGradeId != 0;
    return needsMin || needsMax;
  }

  void setMinGrade(Grade? grade) {
    final currentMax = state.selectedMaxGrade;
    final shouldClearMax =
        grade != null &&
        currentMax != null &&
        (currentMax.gradeCategory != grade.gradeCategory || !_isGradeNumberHigherThan(currentMax, grade));

    state = state.copyWith(
      selectedMinGrade: grade,
      clearMinGrade: grade == null,
      clearMaxGrade: grade == null || shouldClearMax,
    );
  }

  void setMaxGrade(Grade? grade) {
    state = state.copyWith(selectedMaxGrade: grade, clearMaxGrade: grade == null);
  }

  void resolveFromGrades(List<Grade> grades) {
    if (!_needsResolve) return;
    Grade? minG;
    Grade? maxG;
    for (final x in grades) {
      if (minG == null && _minGradeIdToResolve != null && x.id == _minGradeIdToResolve) minG = x;
      if (maxG == null && _maxGradeIdToResolve != null && x.id == _maxGradeIdToResolve) maxG = x;
      if (minG != null && maxG != null) break;
    }
    _needsResolve = false;
    if (minG != null && maxG != null && !_isGradeNumberHigherThan(maxG, minG)) maxG = null;
    if (minG != null || maxG != null) {
      state = state.copyWith(
        selectedMinGrade: minG ?? state.selectedMinGrade,
        selectedMaxGrade: maxG ?? state.selectedMaxGrade,
      );
    }
  }

  (int minId, int maxId)? _validateGradeSelection(BuildContext context, AppLocalizations l10n) {
    final minId = state.selectedMinGrade?.id;
    final maxId = state.selectedMaxGrade?.id;
    if (minId == null || maxId == null) {
      ToastService.error(context, l10n.pleaseSelectGrades);
      return null;
    }
    return (minId, maxId);
  }

  Future<JobLevelSubmitResult> submitJobLevel(
    BuildContext context,
    WidgetRef ref, {
    required String nameEn,
    required String code,
    required String description,
    required bool isEdit,
    required JobLevel? existingJobLevel,
  }) async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return JobLevelSubmitResult.validationFailure();

    final nameTrimmed = nameEn.trim();
    if (nameTrimmed.isEmpty) {
      ToastService.error(context, l10n.levelNameRequired);
      return JobLevelSubmitResult.validationFailure();
    }

    final codeTrimmed = code.trim();
    if (codeTrimmed.isEmpty) {
      ToastService.error(context, l10n.jobLevelCodeRequired);
      return JobLevelSubmitResult.validationFailure();
    }

    final descTrimmed = description.trim();
    if (descTrimmed.isEmpty) {
      ToastService.error(context, l10n.jobLevelDescriptionRequired);
      return JobLevelSubmitResult.validationFailure();
    }

    final gradeIds = _validateGradeSelection(context, l10n);
    if (gradeIds == null) return JobLevelSubmitResult.validationFailure();

    try {
      final jobLevel = JobLevel(
        id: existingJobLevel?.id ?? 0,
        nameEn: nameTrimmed,
        code: codeTrimmed,
        description: descTrimmed,
        minGradeId: gradeIds.$1,
        maxGradeId: gradeIds.$2,
        status: 'ACTIVE',
      );

      if (isEdit) {
        final updated = await ref.read(jobLevelNotifierProvider.notifier).updateJobLevel(ref, jobLevel);
        return JobLevelSubmitResult.success(updated, l10n.jobLevelUpdatedSuccessfully);
      } else {
        final created = await ref.read(jobLevelNotifierProvider.notifier).createJobLevel(ref, jobLevel);
        return JobLevelSubmitResult.success(created, l10n.jobLevelCreatedSuccessfully);
      }
    } catch (_) {
      return JobLevelSubmitResult.apiError(l10n.somethingWentWrong);
    }
  }
}

sealed class JobLevelSubmitResult {
  const JobLevelSubmitResult();

  factory JobLevelSubmitResult.success(JobLevel level, String successMessage) = JobLevelSubmitSuccess;
  factory JobLevelSubmitResult.validationFailure() = JobLevelSubmitValidationFailure;
  factory JobLevelSubmitResult.apiError(String errorMessage) = JobLevelSubmitApiError;
}

final class JobLevelSubmitSuccess extends JobLevelSubmitResult {
  final JobLevel level;
  final String successMessage;

  JobLevelSubmitSuccess(this.level, this.successMessage);
}

final class JobLevelSubmitValidationFailure extends JobLevelSubmitResult {
  JobLevelSubmitValidationFailure();
}

final class JobLevelSubmitApiError extends JobLevelSubmitResult {
  final String errorMessage;

  JobLevelSubmitApiError(this.errorMessage);
}

final jobLevelFormStateProvider = StateNotifierProvider.autoDispose
    .family<JobLevelFormNotifier, JobLevelFormState, JobLevel?>((ref, jobLevel) {
      final notifier = JobLevelFormNotifier(jobLevel);
      ref.listen(gradesForJobLevelFormProvider, (prev, next) {
        next.whenData((grades) => notifier.resolveFromGrades(grades));
      });
      return notifier;
    });

int? _gradeNumberFromGradeNumber(String gradeNumber) {
  final match = RegExp(r'\d+$').firstMatch(gradeNumber);
  if (match == null) return null;
  return int.tryParse(match.group(0)!);
}

bool _isGradeNumberHigherThan(Grade higher, Grade lower) {
  final higherNum = _gradeNumberFromGradeNumber(higher.gradeNumber);
  final lowerNum = _gradeNumberFromGradeNumber(lower.gradeNumber);
  if (higherNum == null || lowerNum == null) return false;
  return higherNum > lowerNum;
}

final maxGradeOptionsForJobLevelFormProvider = Provider.autoDispose.family<List<Grade>, JobLevel?>((ref, jobLevel) {
  final grades = ref.watch(gradesForJobLevelFormProvider).valueOrNull ?? [];
  final minGrade = ref.watch(jobLevelFormStateProvider(jobLevel)).selectedMinGrade;
  if (minGrade == null) return [];
  final minGradeCategory = minGrade.gradeCategory;
  final minGradeNum = _gradeNumberFromGradeNumber(minGrade.gradeNumber);
  if (minGradeNum == null) return [];

  return grades.where((g) {
    if (g.gradeCategory != minGradeCategory) return false;
    final gNum = _gradeNumberFromGradeNumber(g.gradeNumber);
    if (gNum == null) return false;
    return gNum >= minGradeNum;
  }).toList()..sort((a, b) {
    final aNum = _gradeNumberFromGradeNumber(a.gradeNumber) ?? 0;
    final bNum = _gradeNumberFromGradeNumber(b.gradeNumber) ?? 0;
    return aNum.compareTo(bNum);
  });
});
