import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/job_family.dart';
import 'package:grc/features/workforce_structure/domain/models/job_level.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PositionFormState {
  final String code;
  final String titleEnglish;
  final String titleArabic;
  final String costCenter;
  final String location;
  final String positions;
  final String filled;
  final String budgetedMin;
  final String budgetedMax;
  final String actualAverage;
  final Map<String, String?> selectedUnitIds;
  final Position? selectedReportsToPosition;
  final bool isSaving;
  final bool isEdit;
  final String? employmentType;
  final bool isActive;
  final JobFamily? jobFamily;
  final JobLevel? jobLevel;
  final Grade? grade;
  final String? minStep;
  final String? maxStep;

  const PositionFormState({
    this.code = '',
    this.titleEnglish = '',
    this.titleArabic = '',
    this.costCenter = '',
    this.location = '',
    this.positions = '0',
    this.filled = '0',
    this.budgetedMin = '',
    this.budgetedMax = '',
    this.actualAverage = '',
    this.selectedUnitIds = const {},
    this.selectedReportsToPosition,
    this.isSaving = false,
    this.isEdit = false,
    this.employmentType = 'FULL_TIME',
    this.isActive = true,
    this.jobFamily,
    this.jobLevel,
    this.grade,
    this.minStep,
    this.maxStep,
  });

  int get minStepNoForPayload => _parseStepNo(minStep) ?? 1;
  int get maxStepNoForPayload => _parseStepNo(maxStep) ?? minStepNoForPayload;

  List<int> get stepNoListForPayload {
    final min = minStepNoForPayload;
    final max = maxStepNoForPayload;
    return List.generate(max - min + 1, (i) => min + i);
  }

  static int? _parseStepNo(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final parsed = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
    return (parsed != null && parsed >= 1 && parsed <= 5) ? parsed : null;
  }

  PositionFormState copyWith({
    String? code,
    String? titleEnglish,
    String? titleArabic,
    String? costCenter,
    String? location,
    String? positions,
    String? filled,
    String? budgetedMin,
    String? budgetedMax,
    String? actualAverage,
    Map<String, String?>? selectedUnitIds,
    Position? selectedReportsToPosition,
    bool clearSelectedReportsTo = false,
    bool? isSaving,
    bool? isEdit,
    String? employmentType,
    bool? isActive,
    JobFamily? jobFamily,
    JobLevel? jobLevel,
    Grade? grade,
    String? minStep,
    String? maxStep,
    bool clearGrade = false,
    bool clearStep = false,
    bool clearBudget = false,
  }) {
    return PositionFormState(
      code: code ?? this.code,
      titleEnglish: titleEnglish ?? this.titleEnglish,
      titleArabic: titleArabic ?? this.titleArabic,
      costCenter: costCenter ?? this.costCenter,
      location: location ?? this.location,
      positions: positions ?? this.positions,
      filled: filled ?? this.filled,
      budgetedMin: clearBudget ? '' : (budgetedMin ?? this.budgetedMin),
      budgetedMax: clearBudget ? '' : (budgetedMax ?? this.budgetedMax),
      actualAverage: clearBudget ? '' : (actualAverage ?? this.actualAverage),
      selectedUnitIds: selectedUnitIds ?? this.selectedUnitIds,
      selectedReportsToPosition: clearSelectedReportsTo
          ? null
          : (selectedReportsToPosition ?? this.selectedReportsToPosition),
      isSaving: isSaving ?? this.isSaving,
      isEdit: isEdit ?? this.isEdit,
      employmentType: employmentType ?? this.employmentType,
      isActive: isActive ?? this.isActive,
      jobFamily: jobFamily ?? this.jobFamily,
      jobLevel: jobLevel ?? this.jobLevel,
      grade: clearGrade ? null : (grade ?? this.grade),
      minStep: clearStep ? null : (minStep ?? this.minStep),
      maxStep: clearStep ? null : (maxStep ?? this.maxStep),
    );
  }
}

class PositionFormNotifier extends StateNotifier<PositionFormState> {
  PositionFormNotifier() : super(const PositionFormState());

  void setEmploymentType(String? value) {
    state = state.copyWith(employmentType: value);
  }

  void setIsActive(bool value) {
    state = state.copyWith(isActive: value);
  }

  void setJobFamily(JobFamily? value) {
    state = state.copyWith(jobFamily: value);
  }

  void setJobLevel(JobLevel? value) {
    final levelChanged = value?.id != state.jobLevel?.id;
    state = state.copyWith(
      jobLevel: value,
      clearGrade: levelChanged,
      clearStep: levelChanged,
      clearBudget: levelChanged,
    );
  }

  void setGrade(Grade? value) {
    final gradeChanged = value?.id != state.grade?.id;
    state = state.copyWith(
      grade: value,
      minStep: value == null ? null : (gradeChanged ? null : state.minStep),
      maxStep: value == null ? null : (gradeChanged ? null : state.maxStep),
      clearBudget: value == null,
      budgetedMin: value?.minSalary.toStringAsFixed(2),
      budgetedMax: value?.maxSalary.toStringAsFixed(2),
      actualAverage: value?.averageSalary.toStringAsFixed(2),
    );
  }

  void setStepRange(String? minStep, String? maxStep) {
    state = state.copyWith(minStep: minStep, maxStep: maxStep);
  }

  void setSelectedSteps(List<GradeStep> selectedSteps) {
    final availableSteps = [...(state.grade?.steps ?? [])]..sort((a, b) => a.step.compareTo(b.step));
    final requiresAtLeastTwo = availableSteps.length >= 2;
    final currentRangeCount = _currentSelectedStepCount();

    List<GradeStep> effectiveSelection = [...selectedSteps]..sort((a, b) => a.step.compareTo(b.step));

    if (requiresAtLeastTwo && effectiveSelection.length < 2) {
      if (currentRangeCount >= 2) {
        return;
      }
      if (effectiveSelection.length == 1) {
        final selected = effectiveSelection.first;
        final selectedIndex = availableSteps.indexWhere((s) => s.step == selected.step);
        if (selectedIndex != -1) {
          final adjacentIndex = selectedIndex < availableSteps.length - 1 ? selectedIndex + 1 : selectedIndex - 1;
          if (adjacentIndex >= 0 && adjacentIndex < availableSteps.length) {
            effectiveSelection = [selected, availableSteps[adjacentIndex]]..sort((a, b) => a.step.compareTo(b.step));
          }
        }
      }
      if (effectiveSelection.length < 2 && availableSteps.length >= 2) {
        effectiveSelection = [availableSteps[0], availableSteps[1]];
      }
    }

    if (effectiveSelection.isEmpty) {
      final grade = state.grade;
      state = state.copyWith(
        minStep: null,
        maxStep: null,
        budgetedMin: grade?.minSalary.toStringAsFixed(2) ?? '',
        budgetedMax: grade?.maxSalary.toStringAsFixed(2) ?? '',
        actualAverage: grade?.averageSalary.toStringAsFixed(2) ?? '',
      );
      return;
    }

    final sorted = effectiveSelection;
    final salaries = sorted.map((s) => s.salary).toList();
    final minSalary = salaries.reduce((a, b) => a < b ? a : b);
    double maxSalary;
    if (sorted.length == 1) {
      final selected = sorted.first;
      final allSteps = (state.grade?.steps ?? [])..sort((a, b) => a.step.compareTo(b.step));
      final nextStep = allSteps.where((s) => s.step > selected.step).firstOrNull;
      final candidateMax = nextStep != null ? (nextStep.salary - 1) : selected.salary;
      maxSalary = candidateMax < selected.salary ? selected.salary : candidateMax;
    } else {
      maxSalary = salaries.reduce((a, b) => a > b ? a : b);
    }
    final avgSalary = (minSalary + maxSalary) / 2;

    state = state.copyWith(
      minStep: sorted.first.step.toString(),
      maxStep: sorted.last.step.toString(),
      budgetedMin: minSalary.toStringAsFixed(2),
      budgetedMax: maxSalary.toStringAsFixed(2),
      actualAverage: avgSalary.toStringAsFixed(2),
    );
  }

  int _currentSelectedStepCount() {
    final min = PositionFormState._parseStepNo(state.minStep);
    final max = PositionFormState._parseStepNo(state.maxStep);
    if (min == null || max == null || max < min) return 0;
    return max - min + 1;
  }

  void setCode(String value) => state = state.copyWith(code: value);
  void setTitleEnglish(String value) => state = state.copyWith(titleEnglish: value);
  void setTitleArabic(String value) => state = state.copyWith(titleArabic: value);
  void setCostCenter(String value) => state = state.copyWith(costCenter: value);
  void setLocation(String value) => state = state.copyWith(location: value);
  void setPositions(String value) => state = state.copyWith(positions: value);
  void setFilled(String value) => state = state.copyWith(filled: value);
  void setBudgetedMin(String value) => state = state.copyWith(budgetedMin: value);
  void setBudgetedMax(String value) => state = state.copyWith(budgetedMax: value);
  void setActualAverage(String value) => state = state.copyWith(actualAverage: value);

  void setSelectedUnitId(String levelCode, String? unitId) {
    final updated = Map<String, String?>.from(state.selectedUnitIds);
    updated[levelCode] = unitId;
    state = state.copyWith(selectedUnitIds: updated);
  }

  void setSelectedReportsToPosition(Position? value) {
    state = state.copyWith(selectedReportsToPosition: value, clearSelectedReportsTo: value == null);
  }

  void setIsSaving(bool value) => state = state.copyWith(isSaving: value);

  static String? _parseMinStepFromDisplay(String step) {
    if (step.trim().isEmpty) return null;
    final nums = RegExp(r'\d+').allMatches(step).map((m) => m.group(0)!).toList();
    return nums.isNotEmpty ? nums.first : null;
  }

  static String? _parseMaxStepFromDisplay(String step) {
    if (step.trim().isEmpty) return null;
    final nums = RegExp(r'\d+').allMatches(step).map((m) => m.group(0)!).toList();
    return nums.length >= 2
        ? nums.last
        : nums.isNotEmpty
        ? nums.first
        : null;
  }

  void reset() {
    state = const PositionFormState();
  }

  void initialize({required Position position, required bool isEdit}) {
    final reportsTo = (isEdit && position.reportsToPositionId != null && position.reportsToPositionId!.isNotEmpty)
        ? Position.empty().copyWith(
            id: position.reportsToPositionId,
            titleEnglish: position.reportsToTitle ?? '',
            code: position.reportsToCode ?? '',
          )
        : null;
    final unitIds = Map<String, String?>.from(position.orgPathIds ?? {});
    state = state.copyWith(
      code: position.code,
      titleEnglish: position.titleEnglish,
      titleArabic: position.titleArabic,
      costCenter: position.costCenter,
      location: position.location,
      positions: position.headcount.toString(),
      filled: position.filled.toString(),
      budgetedMin: position.budgetedMin.isNotEmpty
          ? position.budgetedMin
          : (position.gradeRef?.minSalary.toStringAsFixed(2) ?? ''),
      budgetedMax: position.budgetedMax.isNotEmpty
          ? position.budgetedMax
          : (position.gradeRef?.maxSalary.toStringAsFixed(2) ?? ''),
      actualAverage: position.actualAverage.isNotEmpty
          ? position.actualAverage
          : (position.gradeRef?.averageSalary.toStringAsFixed(2) ?? ''),
      selectedUnitIds: unitIds,
      selectedReportsToPosition: reportsTo,
      isEdit: isEdit,
      employmentType: position.employmentType ?? 'FULL_TIME',
      isActive: position.isActive,
      minStep: _parseMinStepFromDisplay(position.step),
      maxStep: _parseMaxStepFromDisplay(position.step),
      jobFamily: position.jobFamilyRef,
      jobLevel: position.jobLevelRef,
      grade: position.gradeRef,
    );
  }

  bool validateForm(BuildContext context, {required bool hasOrgUnitSelected, required AppLocalizations l}) {
    if (!state.isEdit && state.code.trim().isEmpty) {
      ToastService.error(context, '${l.positionCode} ${l.fieldRequired}');
      return false;
    }
    if (state.titleEnglish.trim().isEmpty) {
      ToastService.error(context, '${l.positionTitle} (English) ${l.fieldRequired}');
      return false;
    }
    if (state.costCenter.trim().isEmpty) {
      ToastService.error(context, '${l.costCenter} ${l.fieldRequired}');
      return false;
    }
    if (state.location.trim().isEmpty) {
      ToastService.error(context, '${l.location} ${l.fieldRequired}');
      return false;
    }
    final positionsStr = state.positions.trim();
    if (positionsStr.isEmpty) {
      ToastService.error(context, 'Number of positions ${l.fieldRequired}');
      return false;
    }
    final positions = int.tryParse(positionsStr);
    if (positions == null || positions < 0) {
      ToastService.error(context, 'Number of positions must be a valid number (0 or more)');
      return false;
    }
    final filledStr = state.filled.trim();
    if (filledStr.isEmpty) {
      ToastService.error(context, 'Filled positions ${l.fieldRequired}');
      return false;
    }
    final filled = int.tryParse(filledStr);
    if (filled == null || filled < 0) {
      ToastService.error(context, 'Filled positions must be a valid number (0 or more)');
      return false;
    }
    if (filled > positions) {
      ToastService.error(context, 'Filled positions cannot exceed number of positions');
      return false;
    }
    if (state.employmentType == null || state.employmentType!.isEmpty) {
      ToastService.error(context, 'Employment type ${l.fieldRequired}');
      return false;
    }
    if (state.jobFamily == null || state.jobLevel == null || state.grade == null) {
      ToastService.error(context, 'Please select Job Family, Level and Grade');
      return false;
    }
    if (state.minStep == null || state.minStep!.trim().isEmpty) {
      ToastService.error(context, 'Please select a step');
      return false;
    }
    if (!hasOrgUnitSelected) {
      ToastService.error(context, 'Please select at least one organizational unit');
      return false;
    }
    final budgetedMin = state.budgetedMin.trim();
    if (budgetedMin.isEmpty) {
      ToastService.error(context, '${l.budgetedMin} ${l.fieldRequired}');
      return false;
    }
    if (double.tryParse(budgetedMin) == null || double.tryParse(budgetedMin)! < 0) {
      ToastService.error(context, '${l.budgetedMin} must be a valid number (0 or more)');
      return false;
    }
    final budgetedMax = state.budgetedMax.trim();
    if (budgetedMax.isEmpty) {
      ToastService.error(context, '${l.budgetedMax} ${l.fieldRequired}');
      return false;
    }
    if (double.tryParse(budgetedMax) == null || double.tryParse(budgetedMax)! < 0) {
      ToastService.error(context, '${l.budgetedMax} must be a valid number (0 or more)');
      return false;
    }
    final actualAvg = state.actualAverage.trim();
    if (actualAvg.isEmpty) {
      ToastService.error(context, '${l.actualAverage} ${l.fieldRequired}');
      return false;
    }
    if (double.tryParse(actualAvg) == null || double.tryParse(actualAvg)! < 0) {
      ToastService.error(context, '${l.actualAverage} must be a valid number (0 or more)');
      return false;
    }
    return true;
  }
}

final positionFormNotifierProvider = StateNotifierProvider.autoDispose<PositionFormNotifier, PositionFormState>((ref) {
  return PositionFormNotifier();
});
