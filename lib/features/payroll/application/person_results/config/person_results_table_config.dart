import 'package:grc/features/payroll/application/person_results/config/person_results_table_types.dart';

class PersonResultsTableConfig {
  PersonResultsTableConfig._();

  static const int pageSize = 10;

  static const double nameWidth = 314;
  static const double businessTitleWidth = 244;
  static const double personNumberWidth = 130;
  static const double assignmentNumberWidth = 161;
  static const double assignmentStatusWidth = 185;
  static const double workerTypeWidth = 112;
  static const double workEmailWidth = 217;
  static const double workPhoneWidth = 136;

  static const List<PersonResultsTableColumn> columns = PersonResultsTableColumn.values;

  static double widthFor(PersonResultsTableColumn column) {
    return switch (column) {
      PersonResultsTableColumn.name => nameWidth,
      PersonResultsTableColumn.businessTitle => businessTitleWidth,
      PersonResultsTableColumn.personNumber => personNumberWidth,
      PersonResultsTableColumn.assignmentNumber => assignmentNumberWidth,
      PersonResultsTableColumn.assignmentStatus => assignmentStatusWidth,
      PersonResultsTableColumn.workerType => workerTypeWidth,
      PersonResultsTableColumn.workEmail => workEmailWidth,
      PersonResultsTableColumn.workPhone => workPhoneWidth,
    };
  }

  static double minWidthFor(PersonResultsTableColumn column) {
    return switch (column) {
      PersonResultsTableColumn.name => 180,
      PersonResultsTableColumn.assignmentStatus => 160,
      PersonResultsTableColumn.workEmail => 160,
      _ => 80,
    };
  }
}
