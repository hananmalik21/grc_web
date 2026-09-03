// class ApiConfig {
//   // static const String baseUrl = 'http://localhost:3000';
//   static const String baseUrl =
//       'https://digift-hr-system-backend-48wi.onrender.com';
//   // static const String baseUrl = 'http://145.241.105.37';
//   static const Duration connectTimeout = Duration(seconds: 30);
//   static const Duration receiveTimeout = Duration(seconds: 30);
// }
class ApiConfig {
  static const String baseUrl = 'http://127.0.0.1:3000';
  // static const String baseUrl = 'http://localhost:3000';
  // static const String baseUrl = 'https://digift-hr-system-backend-48wi.onrender.com';
  // static const String baseUrl = 'https://api.digifyhr.com';
  // static const String baseUrl = 'http://145.241.105.37';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Debug-only host for `X-Forwarded-Host` when running on loalhost.
  /// Set to `''` to disable.
  // static const String debugTenantHost = 'abc-trading.app.digifyhr.com';
  static const String debugTenantHost = 'ent001.app.digifyhr.com';
  // static const String debugTenantHost = 'digify-solutions-llc.app.digifyhr.com';
  // static const String debugTenantHost = 'ent002.app.digifyhr.com';
  // static const String debugTenantHost = 'albabtain-hr.app.digifyhr.com';
}
