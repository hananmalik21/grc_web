mixin PublicHolidayStaticValuesMixin {
  static const List<String> holidayTypes = ['Fixed', 'Islamic', 'Variable'];

  static const List<String> appliesToOptions = [
    'All Employees',
    'Kuwait only',
    'Expat only',
    'Government sector',
    'Private sector',
  ];

  static const String defaultHolidayType = 'Fixed';

  static const String defaultAppliesTo = 'All Employees';
}
