import 'package:grc/features/workforce_structure/data/config/job_levels_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum JobLevelColumn { levelName, code, description, minGrade, maxGrade, totalPositions, actions }

class JobLevelsTableColumnWidths {
  final double? levelNameOverride;
  final double? codeOverride;
  final double? descriptionOverride;
  final double? minGradeOverride;
  final double? maxGradeOverride;
  final double? totalPositionsOverride;
  final double? actionsOverride;

  const JobLevelsTableColumnWidths({
    this.levelNameOverride,
    this.codeOverride,
    this.descriptionOverride,
    this.minGradeOverride,
    this.maxGradeOverride,
    this.totalPositionsOverride,
    this.actionsOverride,
  });

  double get levelName => levelNameOverride ?? JobLevelsTableConfig.levelNameWidth.w;
  double get code => codeOverride ?? JobLevelsTableConfig.codeWidth.w;
  double get description => descriptionOverride ?? JobLevelsTableConfig.descriptionWidth.w;
  double get minGrade => minGradeOverride ?? JobLevelsTableConfig.minGradeWidth.w;
  double get maxGrade => maxGradeOverride ?? JobLevelsTableConfig.maxGradeWidth.w;
  double get totalPositions => totalPositionsOverride ?? JobLevelsTableConfig.totalPositionsWidth.w;
  double get actions => actionsOverride ?? JobLevelsTableConfig.actionsWidth.w;

  JobLevelsTableColumnWidths copyWith({
    double? levelNameOverride,
    double? codeOverride,
    double? descriptionOverride,
    double? minGradeOverride,
    double? maxGradeOverride,
    double? totalPositionsOverride,
    double? actionsOverride,
  }) {
    return JobLevelsTableColumnWidths(
      levelNameOverride: levelNameOverride ?? this.levelNameOverride,
      codeOverride: codeOverride ?? this.codeOverride,
      descriptionOverride: descriptionOverride ?? this.descriptionOverride,
      minGradeOverride: minGradeOverride ?? this.minGradeOverride,
      maxGradeOverride: maxGradeOverride ?? this.maxGradeOverride,
      totalPositionsOverride: totalPositionsOverride ?? this.totalPositionsOverride,
      actionsOverride: actionsOverride ?? this.actionsOverride,
    );
  }
}

final jobLevelsTableWidthsProvider = StateNotifierProvider<JobLevelsTableWidthsNotifier, JobLevelsTableColumnWidths>((
  ref,
) {
  return JobLevelsTableWidthsNotifier();
});

class JobLevelsTableWidthsNotifier extends StateNotifier<JobLevelsTableColumnWidths> {
  JobLevelsTableWidthsNotifier() : super(const JobLevelsTableColumnWidths());

  void updateWidth(JobLevelColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(60.0, 600.0);

    switch (column) {
      case JobLevelColumn.levelName:
        state = state.copyWith(levelNameOverride: clampWidth(state.levelName));
        break;
      case JobLevelColumn.code:
        state = state.copyWith(codeOverride: clampWidth(state.code));
        break;
      case JobLevelColumn.description:
        state = state.copyWith(descriptionOverride: clampWidth(state.description));
        break;
      case JobLevelColumn.minGrade:
        state = state.copyWith(minGradeOverride: clampWidth(state.minGrade));
        break;
      case JobLevelColumn.maxGrade:
        state = state.copyWith(maxGradeOverride: clampWidth(state.maxGrade));
        break;
      case JobLevelColumn.totalPositions:
        state = state.copyWith(totalPositionsOverride: clampWidth(state.totalPositions));
        break;
      case JobLevelColumn.actions:
        state = state.copyWith(actionsOverride: clampWidth(state.actions));
        break;
    }
  }
}
