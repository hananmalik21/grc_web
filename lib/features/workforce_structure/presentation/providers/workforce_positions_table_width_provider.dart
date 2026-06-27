import 'package:grc/features/workforce_structure/data/config/workforce_positions_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum PositionColumn {
  positionCode,
  title,
  department,
  jobFamily,
  jobLevel,
  gradeStep,
  reportsTo,
  headcount,
  vacancy,
  status,
  actions,
}

class PositionTableColumnWidths {
  final double? positionCodeOverride;
  final double? titleOverride;
  final double? departmentOverride;
  final double? jobFamilyOverride;
  final double? jobLevelOverride;
  final double? gradeStepOverride;
  final double? reportsToOverride;
  final double? headcountOverride;
  final double? vacancyOverride;
  final double? statusOverride;
  final double? actionsOverride;

  const PositionTableColumnWidths({
    this.positionCodeOverride,
    this.titleOverride,
    this.departmentOverride,
    this.jobFamilyOverride,
    this.jobLevelOverride,
    this.gradeStepOverride,
    this.reportsToOverride,
    this.headcountOverride,
    this.vacancyOverride,
    this.statusOverride,
    this.actionsOverride,
  });

  double get positionCode => positionCodeOverride ?? WorkforcePositionsTableConfig.positionCodeWidth.w;
  double get title => titleOverride ?? WorkforcePositionsTableConfig.titleWidth.w;
  double get department => departmentOverride ?? WorkforcePositionsTableConfig.departmentWidth.w;
  double get jobFamily => jobFamilyOverride ?? WorkforcePositionsTableConfig.jobFamilyWidth.w;
  double get jobLevel => jobLevelOverride ?? WorkforcePositionsTableConfig.jobLevelWidth.w;
  double get gradeStep => gradeStepOverride ?? WorkforcePositionsTableConfig.gradeStepWidth.w;
  double get reportsTo => reportsToOverride ?? WorkforcePositionsTableConfig.reportsToWidth.w;
  double get headcount => headcountOverride ?? WorkforcePositionsTableConfig.headcountWidth.w;
  double get vacancy => vacancyOverride ?? WorkforcePositionsTableConfig.vacancyWidth.w;
  double get status => statusOverride ?? WorkforcePositionsTableConfig.statusWidth.w;
  double get actions => actionsOverride ?? WorkforcePositionsTableConfig.actionsWidth.w;

  PositionTableColumnWidths copyWith({
    double? positionCodeOverride,
    double? titleOverride,
    double? departmentOverride,
    double? jobFamilyOverride,
    double? jobLevelOverride,
    double? gradeStepOverride,
    double? reportsToOverride,
    double? headcountOverride,
    double? vacancyOverride,
    double? statusOverride,
    double? actionsOverride,
  }) {
    return PositionTableColumnWidths(
      positionCodeOverride: positionCodeOverride ?? this.positionCodeOverride,
      titleOverride: titleOverride ?? this.titleOverride,
      departmentOverride: departmentOverride ?? this.departmentOverride,
      jobFamilyOverride: jobFamilyOverride ?? this.jobFamilyOverride,
      jobLevelOverride: jobLevelOverride ?? this.jobLevelOverride,
      gradeStepOverride: gradeStepOverride ?? this.gradeStepOverride,
      reportsToOverride: reportsToOverride ?? this.reportsToOverride,
      headcountOverride: headcountOverride ?? this.headcountOverride,
      vacancyOverride: vacancyOverride ?? this.vacancyOverride,
      statusOverride: statusOverride ?? this.statusOverride,
      actionsOverride: actionsOverride ?? this.actionsOverride,
    );
  }
}

final positionTableWidthsProvider = StateNotifierProvider<PositionTableWidthsNotifier, PositionTableColumnWidths>((
  ref,
) {
  return PositionTableWidthsNotifier();
});

class PositionTableWidthsNotifier extends StateNotifier<PositionTableColumnWidths> {
  PositionTableWidthsNotifier() : super(const PositionTableColumnWidths());

  void updateWidth(PositionColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(60.0, 600.0);

    switch (column) {
      case PositionColumn.positionCode:
        state = state.copyWith(positionCodeOverride: clampWidth(state.positionCode));
        break;
      case PositionColumn.title:
        state = state.copyWith(titleOverride: clampWidth(state.title));
        break;
      case PositionColumn.department:
        state = state.copyWith(departmentOverride: clampWidth(state.department));
        break;
      case PositionColumn.jobFamily:
        state = state.copyWith(jobFamilyOverride: clampWidth(state.jobFamily));
        break;
      case PositionColumn.jobLevel:
        state = state.copyWith(jobLevelOverride: clampWidth(state.jobLevel));
        break;
      case PositionColumn.gradeStep:
        state = state.copyWith(gradeStepOverride: clampWidth(state.gradeStep));
        break;
      case PositionColumn.reportsTo:
        state = state.copyWith(reportsToOverride: clampWidth(state.reportsTo));
        break;
      case PositionColumn.headcount:
        state = state.copyWith(headcountOverride: clampWidth(state.headcount));
        break;
      case PositionColumn.vacancy:
        state = state.copyWith(vacancyOverride: clampWidth(state.vacancy));
        break;
      case PositionColumn.status:
        state = state.copyWith(statusOverride: clampWidth(state.status));
        break;
      case PositionColumn.actions:
        state = state.copyWith(actionsOverride: clampWidth(state.actions));
        break;
    }
  }
}
