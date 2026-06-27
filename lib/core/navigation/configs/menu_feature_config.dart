/// Central configuration to enable/disable sidebar menu items by id.
/// Set an id to false to hide that item; omit or set true to show.
/// No need to comment out code in sidebar_config.dart—toggle here instead.
class MenuFeatureConfig {
  MenuFeatureConfig._();

  static const Map<String, bool> _enabled = <String, bool>{
    'company': false,
    'division': false,
    'businessUnit': false,
    'department': false,
    'section': false,
    'reportingStructure': true,
    'forfeitPolicy': false,
    'myLeaveBalance': false,
    'teamLeaveRisk': false,
  };

  /// Returns true if the menu item with [id] should be shown. Defaults to true when not listed.
  static bool isEnabled(String id) => _enabled[id] ?? true;
}
