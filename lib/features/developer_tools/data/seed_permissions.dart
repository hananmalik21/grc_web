import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/permissions/perm_catalog.dart';

/// Seeds all permission keys from [kAllModules] into the backend.
///
/// Call once from developer tools / admin panel. Idempotent if the backend
/// handles duplicate keys gracefully (upsert).
///
/// POST body shape per key:
/// ```json
/// {
///   "key": "employees.manage_employees.create",
///   "label": "Create",
///   "module": "Employees",
///   "is_active": true,
///   "is_system_permission": false
/// }
/// ```
Future<void> seedAllPermissions() async {
  final client = ApiClient(baseUrl: ApiConfig.baseUrl);

  for (final module in kAllModules) {
    for (final sub in module.subModules) {
      // Seed wildcard
      await _post(client, key: sub.wildcard, label: '${sub.label} — All', moduleName: module.label);

      // Seed each action
      for (final action in sub.actions) {
        await _post(
          client,
          key: sub.action(action),
          label: action.label,
          moduleName: module.label,
        );
      }
    }
  }
}

Future<void> _post(
  ApiClient client, {
  required String key,
  required String label,
  required String moduleName,
}) async {
  await client.post(ApiEndpoints.securityFunctions, body: {
    'key': key,
    'label': label,
    'module': moduleName,
    'is_active': true,
    'is_system_permission': false,
  });
}
