import 'package:grc/features/time_management/data/config/work_patterns_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum WorkPatternColumn { code, name, type, workingDays, restDays, offDays, hoursPerWeek, status, actions }

class WorkPatternsTableColumnWidths {
  final double? codeOverride;
  final double? nameOverride;
  final double? typeOverride;
  final double? workingDaysOverride;
  final double? restDaysOverride;
  final double? offDaysOverride;
  final double? hoursPerWeekOverride;
  final double? statusOverride;
  final double? actionsOverride;

  const WorkPatternsTableColumnWidths({
    this.codeOverride,
    this.nameOverride,
    this.typeOverride,
    this.workingDaysOverride,
    this.restDaysOverride,
    this.offDaysOverride,
    this.hoursPerWeekOverride,
    this.statusOverride,
    this.actionsOverride,
  });

  double get code => codeOverride ?? WorkPatternsTableConfig.codeWidth.w;
  double get name => nameOverride ?? WorkPatternsTableConfig.nameWidth.w;
  double get type => typeOverride ?? WorkPatternsTableConfig.typeWidth.w;
  double get workingDays => workingDaysOverride ?? WorkPatternsTableConfig.workingDaysWidth.w;
  double get restDays => restDaysOverride ?? WorkPatternsTableConfig.restDaysWidth.w;
  double get offDays => offDaysOverride ?? WorkPatternsTableConfig.offDaysWidth.w;
  double get hoursPerWeek => hoursPerWeekOverride ?? WorkPatternsTableConfig.hoursPerWeekWidth.w;
  double get status => statusOverride ?? WorkPatternsTableConfig.statusWidth.w;
  double get actions => actionsOverride ?? WorkPatternsTableConfig.actionsWidth.w;

  WorkPatternsTableColumnWidths copyWith({
    double? codeOverride,
    double? nameOverride,
    double? typeOverride,
    double? workingDaysOverride,
    double? restDaysOverride,
    double? offDaysOverride,
    double? hoursPerWeekOverride,
    double? statusOverride,
    double? actionsOverride,
  }) {
    return WorkPatternsTableColumnWidths(
      codeOverride: codeOverride ?? this.codeOverride,
      nameOverride: nameOverride ?? this.nameOverride,
      typeOverride: typeOverride ?? this.typeOverride,
      workingDaysOverride: workingDaysOverride ?? this.workingDaysOverride,
      restDaysOverride: restDaysOverride ?? this.restDaysOverride,
      offDaysOverride: offDaysOverride ?? this.offDaysOverride,
      hoursPerWeekOverride: hoursPerWeekOverride ?? this.hoursPerWeekOverride,
      statusOverride: statusOverride ?? this.statusOverride,
      actionsOverride: actionsOverride ?? this.actionsOverride,
    );
  }
}

final workPatternsTableWidthsProvider =
    StateNotifierProvider<WorkPatternsTableWidthsNotifier, WorkPatternsTableColumnWidths>((ref) {
      return WorkPatternsTableWidthsNotifier();
    });

class WorkPatternsTableWidthsNotifier extends StateNotifier<WorkPatternsTableColumnWidths> {
  WorkPatternsTableWidthsNotifier() : super(const WorkPatternsTableColumnWidths());

  void updateWidth(WorkPatternColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(60.0, 600.0);

    switch (column) {
      case WorkPatternColumn.code:
        state = state.copyWith(codeOverride: clampWidth(state.code));
        break;
      case WorkPatternColumn.name:
        state = state.copyWith(nameOverride: clampWidth(state.name));
        break;
      case WorkPatternColumn.type:
        state = state.copyWith(typeOverride: clampWidth(state.type));
        break;
      case WorkPatternColumn.workingDays:
        state = state.copyWith(workingDaysOverride: clampWidth(state.workingDays));
        break;
      case WorkPatternColumn.restDays:
        state = state.copyWith(restDaysOverride: clampWidth(state.restDays));
        break;
      case WorkPatternColumn.offDays:
        state = state.copyWith(offDaysOverride: clampWidth(state.offDays));
        break;
      case WorkPatternColumn.hoursPerWeek:
        state = state.copyWith(hoursPerWeekOverride: clampWidth(state.hoursPerWeek));
        break;
      case WorkPatternColumn.status:
        state = state.copyWith(statusOverride: clampWidth(state.status));
        break;
      case WorkPatternColumn.actions:
        state = state.copyWith(actionsOverride: clampWidth(state.actions));
        break;
    }
  }
}
