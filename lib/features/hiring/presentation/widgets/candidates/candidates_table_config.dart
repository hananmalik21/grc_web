import 'candidates_table_types.dart';

class CandidatesTableConfig {
  CandidatesTableConfig._();

  static const double actionsWidth = 160;

  static const double candidateWidth = 240;
  static const double currentRoleWidth = 165;
  static const double experienceWidth = 120;
  static const double locationWidth = 160;
  static const double ratingWidth = 90;
  static const double statusWidth = 110;

  static double widthFor(CandidatesTableColumn column) {
    return switch (column) {
      CandidatesTableColumn.candidate => candidateWidth,
      CandidatesTableColumn.currentRole => currentRoleWidth,
      CandidatesTableColumn.experience => experienceWidth,
      CandidatesTableColumn.location => locationWidth,
      CandidatesTableColumn.rating => ratingWidth,
      CandidatesTableColumn.status => statusWidth,
    };
  }

  static const double maxResizableWidth = 480;

  static const double candidateMinWidth = 180;
  static const double currentRoleMinWidth = 130;
  static const double experienceMinWidth = 80;
  static const double locationMinWidth = 105;
  static const double ratingMinWidth = 70;
  static const double statusMinWidth = 90;

  static double minWidthFor(CandidatesTableColumn column) {
    return switch (column) {
      CandidatesTableColumn.candidate => candidateMinWidth,
      CandidatesTableColumn.currentRole => currentRoleMinWidth,
      CandidatesTableColumn.experience => experienceMinWidth,
      CandidatesTableColumn.location => locationMinWidth,
      CandidatesTableColumn.rating => ratingMinWidth,
      CandidatesTableColumn.status => statusMinWidth,
    };
  }

  static const bool showActions = true;
  static const int pageSize = 10;
}
