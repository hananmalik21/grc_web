abstract class AuthLocalStorage {
  Future<void> saveToken(String token);
  Future<String?> getToken();

  Future<void> saveUserGuid(String userGuid);
  Future<String?> getUserGuid();

  Future<void> saveEnterpriseId(int enterpriseId);
  Future<int?> getEnterpriseId();

  Future<void> saveRefreshToken(String token);
  Future<String?> getRefreshToken();

  Future<void> saveOrgId(String orgId);
  Future<String?> getOrgId();

  Future<void> savePermissions(List<String> permissions);
  Future<List<String>> getPermissions();

  Future<void> clearToken();

  Future<bool> getRememberMe();
  Future<void> setRememberMe(bool value);
  Future<void> saveUserName(String name);
  Future<String?> getUserName();

  Future<void> saveUserRole(String role);
  Future<String?> getUserRole();

  Future<String?> getSavedEmail();
  Future<void> setSavedEmail(String? email);
}
