import 'package:grc/features/workforce_structure/presentation/widgets/reporting_structure/configs/reporting_table_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ReportingColumn { code, title, department, level, grade, reportsTo, status, actions }

class ReportingTableColumnWidths {
  final double? codeOverride;
  final double? titleOverride;
  final double? departmentOverride;
  final double? levelOverride;
  final double? gradeOverride;
  final double? reportsToOverride;
  final double? statusOverride;
  final double? actionsOverride;

  const ReportingTableColumnWidths({
    this.codeOverride,
    this.titleOverride,
    this.departmentOverride,
    this.levelOverride,
    this.gradeOverride,
    this.reportsToOverride,
    this.statusOverride,
    this.actionsOverride,
  });

  double get code => codeOverride ?? ReportingTableConfig.codeWidth.w;
  double get title => titleOverride ?? ReportingTableConfig.titleWidth.w;
  double get department => departmentOverride ?? ReportingTableConfig.departmentWidth.w;
  double get level => levelOverride ?? ReportingTableConfig.levelWidth.w;
  double get grade => gradeOverride ?? ReportingTableConfig.gradeWidth.w;
  double get reportsTo => reportsToOverride ?? ReportingTableConfig.reportsToWidth.w;
  double get status => statusOverride ?? ReportingTableConfig.statusWidth.w;
  double get actions => actionsOverride ?? ReportingTableConfig.actionsWidth.w;

  ReportingTableColumnWidths copyWith({
    double? codeOverride,
    double? titleOverride,
    double? departmentOverride,
    double? levelOverride,
    double? gradeOverride,
    double? reportsToOverride,
    double? statusOverride,
    double? actionsOverride,
  }) {
    return ReportingTableColumnWidths(
      codeOverride: codeOverride ?? this.codeOverride,
      titleOverride: titleOverride ?? this.titleOverride,
      departmentOverride: departmentOverride ?? this.departmentOverride,
      levelOverride: levelOverride ?? this.levelOverride,
      gradeOverride: gradeOverride ?? this.gradeOverride,
      reportsToOverride: reportsToOverride ?? this.reportsToOverride,
      statusOverride: statusOverride ?? this.statusOverride,
      actionsOverride: actionsOverride ?? this.actionsOverride,
    );
  }
}

final reportingTableWidthsProvider = StateNotifierProvider<ReportingTableWidthsNotifier, ReportingTableColumnWidths>((
  ref,
) {
  return ReportingTableWidthsNotifier();
});

class ReportingTableWidthsNotifier extends StateNotifier<ReportingTableColumnWidths> {
  ReportingTableWidthsNotifier() : super(const ReportingTableColumnWidths());

  void updateWidth(ReportingColumn column, double delta) {
    double clampWidth(double current) => (current + delta).clamp(60.0, 600.0);

    switch (column) {
      case ReportingColumn.code:
        state = state.copyWith(codeOverride: clampWidth(state.code));
        break;
      case ReportingColumn.title:
        state = state.copyWith(titleOverride: clampWidth(state.title));
        break;
      case ReportingColumn.department:
        state = state.copyWith(departmentOverride: clampWidth(state.department));
        break;
      case ReportingColumn.level:
        state = state.copyWith(levelOverride: clampWidth(state.level));
        break;
      case ReportingColumn.grade:
        state = state.copyWith(gradeOverride: clampWidth(state.grade));
        break;
      case ReportingColumn.reportsTo:
        state = state.copyWith(reportsToOverride: clampWidth(state.reportsTo));
        break;
      case ReportingColumn.status:
        state = state.copyWith(statusOverride: clampWidth(state.status));
        break;
      case ReportingColumn.actions:
        state = state.copyWith(actionsOverride: clampWidth(state.actions));
        break;
    }
  }
}
