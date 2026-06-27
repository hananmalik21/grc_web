/// Central configuration to enable/disable sidebar menu items by id.
class MenuFeatureConfig {
  MenuFeatureConfig._();

  static const Map<String, bool> _enabled = <String, bool>{
    'company': false,
    'division': false,
    'businessUnit': false,
    'department': false,
    'section': false,
  };

  static bool isEnabled(String id) => _enabled[id] ?? true;
}
