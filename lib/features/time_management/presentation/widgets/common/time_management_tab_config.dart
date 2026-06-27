import 'package:grc/core/localization/l10n/app_localizations.dart';

enum TimeManagementTab {
  shifts,
  workPatterns,
  workSchedules,
  scheduleAssignments,
  viewCalendar,
  publicHolidays;

  String label(AppLocalizations localizations) {
    switch (this) {
      case TimeManagementTab.shifts:
        return localizations.shifts;
      case TimeManagementTab.workPatterns:
        return localizations.workPatterns;
      case TimeManagementTab.workSchedules:
        return localizations.workSchedules;
      case TimeManagementTab.scheduleAssignments:
        return localizations.scheduleAssignments;
      case TimeManagementTab.viewCalendar:
        return localizations.viewCalendar;
      case TimeManagementTab.publicHolidays:
        return localizations.publicHolidays;
    }
  }
}
