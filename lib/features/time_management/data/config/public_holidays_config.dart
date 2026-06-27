import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/mixins/public_holiday_static_values_mixin.dart';

class PublicHolidaysConfig with PublicHolidayStaticValuesMixin {
  PublicHolidaysConfig._();

  /// Available years for filtering holidays
  static List<String> get availableYears => ['All Years', '2024', '2025', '2026', '2027'];

  static List<String> get availableTypes => ['All Types', ...PublicHolidayStaticValuesMixin.holidayTypes];

  static List<String> get availableAppliesTo => PublicHolidayStaticValuesMixin.appliesToOptions;

  /// Default selected year
  static String get defaultYear => 'All Years';

  /// Default selected type
  static String get defaultType => 'All Types';

  static String get defaultAppliesTo => PublicHolidayStaticValuesMixin.defaultAppliesTo;

  /// Get holiday type from display string
  static HolidayType? getHolidayTypeFromDisplay(String displayName) {
    switch (displayName) {
      case 'Fixed':
        return HolidayType.fixed;
      case 'Islamic':
        return HolidayType.islamic;
      case 'Variable':
        return HolidayType.variable;
      default:
        return null;
    }
  }

  /// Get display name for holiday type
  static String getHolidayTypeDisplayName(HolidayType type) {
    switch (type) {
      case HolidayType.fixed:
        return 'Fixed';
      case HolidayType.islamic:
        return 'Islamic';
      case HolidayType.variable:
        return 'Variable';
    }
  }

  static String? getAppliesToApiValue(String displayName) {
    switch (displayName) {
      case 'All Employees':
        return 'ALL';
      case 'Kuwait only':
        return 'KUWAIT_ONLY';
      case 'Expat only':
        return 'EXPAT_ONLY';
      case 'Government sector':
        return 'GOVERNMENT';
      case 'Private sector':
        return 'PRIVATE';
      default:
        return null;
    }
  }

  static String? getAppliesToDisplayName(String apiValue) {
    switch (apiValue.toUpperCase()) {
      case 'ALL':
        return 'All Employees';
      case 'KUWAIT_ONLY':
        return 'Kuwait only';
      case 'EXPAT_ONLY':
        return 'Expat only';
      case 'GOVERNMENT':
        return 'Government sector';
      case 'PRIVATE':
        return 'Private sector';
      default:
        return null;
    }
  }
}
