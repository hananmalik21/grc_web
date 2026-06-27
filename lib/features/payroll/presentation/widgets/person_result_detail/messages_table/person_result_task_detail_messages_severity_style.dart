import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/payroll/application/person_result_detail/config/person_result_task_detail_messages_types.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

Color personResultTaskDetailMessageSeverityColor(PersonResultTaskDetailMessageSeverity severity) {
  return switch (severity) {
    PersonResultTaskDetailMessageSeverity.error => AppColors.error,
    PersonResultTaskDetailMessageSeverity.warning => AppColors.warning,
    PersonResultTaskDetailMessageSeverity.information => AppColors.alertNew,
  };
}

String personResultTaskDetailMessageSeverityLabel(
  AppLocalizations loc,
  PersonResultTaskDetailMessageSeverity severity,
) {
  return switch (severity) {
    PersonResultTaskDetailMessageSeverity.error => loc.payrollPersonResultsTaskDetailMessagesError,
    PersonResultTaskDetailMessageSeverity.warning => loc.payrollPersonResultsTaskDetailMessagesWarning,
    PersonResultTaskDetailMessageSeverity.information => loc.payrollPersonResultsTaskDetailMessagesInformation,
  };
}

class PersonResultTaskDetailMessageExpandedStyle {
  const PersonResultTaskDetailMessageExpandedStyle({
    required this.headerBackground,
    required this.borderColor,
    required this.iconBackground,
    required this.iconPath,
  });

  final Color headerBackground;
  final Color borderColor;
  final Color iconBackground;
  final String iconPath;
}

PersonResultTaskDetailMessageExpandedStyle personResultTaskDetailMessageExpandedStyle(
  PersonResultTaskDetailMessageSeverity severity,
  bool isDark,
) {
  final severityColor = personResultTaskDetailMessageSeverityColor(severity);

  return PersonResultTaskDetailMessageExpandedStyle(
    headerBackground: severityColor.withValues(alpha: isDark ? 0.2 : 0.1),
    borderColor: severityColor,
    iconBackground: severityColor,
    iconPath: switch (severity) {
      PersonResultTaskDetailMessageSeverity.error => Assets.icons.errorCircleRed.path,
      PersonResultTaskDetailMessageSeverity.warning => Assets.icons.securityManager.warning.path,
      PersonResultTaskDetailMessageSeverity.information => Assets.icons.infoCircleBlue.path,
    },
  );
}
