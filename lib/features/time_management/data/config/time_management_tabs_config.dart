import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/time_management/data/models/time_management_tab_model.dart';

/// Configuration for time management tabs
/// This follows clean architecture by separating data/config from presentation
class TimeManagementTabsConfig {
  TimeManagementTabsConfig._();

  /// Returns the list of tabs to display in time management
  static List<TimeManagementTabItem> getTabs() {
    return [
      TimeManagementTabItem(
        id: 'shifts',
        labelKey: 'shifts',
        iconPath: Assets.icons.clockIcon.path,
      ),
      TimeManagementTabItem(
        id: 'workPatterns',
        labelKey: 'workPatterns',
        iconPath: Assets.icons.leaveManagementIcon.path,
      ),
      TimeManagementTabItem(
        id: 'workSchedules',
        labelKey: 'workSchedules',
        iconPath: Assets.icons.sidebar.workSchedules.path,
      ),
      TimeManagementTabItem(
        id: 'scheduleAssignments',
        labelKey: 'scheduleAssignments',
        iconPath: Assets.icons.sidebar.scheduleAssignments.path,
      ),
      TimeManagementTabItem(
        id: 'viewCalendar',
        labelKey: 'viewCalendar',
        iconPath: Assets.icons.sidebar.workSchedules.path,
      ),
      TimeManagementTabItem(
        id: 'publicHolidays',
        labelKey: 'publicHolidays',
        iconPath: Assets.icons.sidebar.publicHolidays.path,
      ),
    ];
  }

  /// Returns the localized label for a given tab label key
  static String getLocalizedLabel(String key, AppLocalizations localizations) {
    switch (key) {
      case 'shifts':
        return localizations.shifts;
      case 'workPatterns':
        return localizations.workPatterns;
      case 'workSchedules':
        return localizations.workSchedules;
      case 'scheduleAssignments':
        return localizations.scheduleAssignments;
      case 'viewCalendar':
        return localizations.viewCalendar;
      case 'publicHolidays':
        return localizations.publicHolidays;
      default:
        return key;
    }
  }
}
