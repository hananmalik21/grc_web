import 'package:grc/features/payroll/application/element_entries/config/element_entries_table_types.dart';

class ElementEntriesTableConfig {
  ElementEntriesTableConfig._();

  static const double selectWidth = 90;
  static const double actionsWidth = 120;

  static const double elementNameWidth = 200;
  static const double primaryEntryValueWidth = 150;
  static const double valueNameWidth = 120;
  static const double sourceWidth = 150;
  static const double employmentLevelWidth = 160;
  static const double reasonWidth = 160;
  static const double classificationWidth = 180;
  static const double ldgWidth = 110;
  static const double empNumberWidth = 130;
  static const double statusWidth = 190;

  static double widthFor(ElementEntriesTableColumn column) {
    return switch (column) {
      ElementEntriesTableColumn.elementName => elementNameWidth,
      ElementEntriesTableColumn.primaryEntryValue => primaryEntryValueWidth,
      ElementEntriesTableColumn.valueName => valueNameWidth,
      ElementEntriesTableColumn.source => sourceWidth,
      ElementEntriesTableColumn.employmentLevel => employmentLevelWidth,
      ElementEntriesTableColumn.reason => reasonWidth,
      ElementEntriesTableColumn.classification => classificationWidth,
      ElementEntriesTableColumn.ldg => ldgWidth,
      ElementEntriesTableColumn.empNumber => empNumberWidth,
      ElementEntriesTableColumn.status => statusWidth,
    };
  }

  static double minWidthFor(ElementEntriesTableColumn column) {
    return switch (column) {
      ElementEntriesTableColumn.status => 160,
      _ => 80,
    };
  }

  static const showActions = true;
  static const int pageSize = 10;
}
