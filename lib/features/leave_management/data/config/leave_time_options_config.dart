class LeaveTimeOptionsConfig {
  static const List<String> timeOptions = ['Full Time', 'Half Time'];

  static const String defaultTimeOption = 'Full Time';

  static bool isValidTimeOption(String? timeOption) {
    if (timeOption == null) return false;
    return timeOptions.contains(timeOption);
  }
}
