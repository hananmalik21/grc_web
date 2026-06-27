enum AuditTrailTableColumn { dateTime, user, action, details, ipAddress }

class CompensationPlanDetailAuditTrailTableConfig {
  CompensationPlanDetailAuditTrailTableConfig._();

  static const double dateTimeWidth = 258;
  static const double userWidth = 198;
  static const double actionWidth = 160;
  static const double detailsWidth = 371;
  static const double ipAddressWidth = 175;

  static double widthFor(AuditTrailTableColumn column) {
    return switch (column) {
      AuditTrailTableColumn.dateTime => dateTimeWidth,
      AuditTrailTableColumn.user => userWidth,
      AuditTrailTableColumn.action => actionWidth,
      AuditTrailTableColumn.details => detailsWidth,
      AuditTrailTableColumn.ipAddress => ipAddressWidth,
    };
  }

  static double get baseWidth => dateTimeWidth + userWidth + actionWidth + detailsWidth + ipAddressWidth;
}
