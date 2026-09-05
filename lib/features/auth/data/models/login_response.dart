/// Represents user data returned from a successful login or `/identity/me`.
class LoginUserData {
  final String userId;
  final String orgId;
  final String email;
  final String firstName;
  final String lastName;
  final String status;
  final List<String> roles;
  final List<String> permissions;

  // Backward compatibility getters
  String get userGuid => userId;
  String get username => email;
  String get primaryEmail => email;
  int get enterpriseId => 1;

  const LoginUserData({
    required this.userId,
    required this.orgId,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.status,
    required this.roles,
    required this.permissions,
  });

  factory LoginUserData.fromJson(Map<String, dynamic> json) {
    // Support new backend format: { id, orgId, email, firstName, lastName, status, roles, permissions }
    if (json.containsKey('id') || json.containsKey('orgId')) {
      return LoginUserData(
        userId: json['id']?.toString() ?? json['userId']?.toString() ?? '',
        orgId: json['orgId']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        firstName: json['firstName']?.toString() ?? '',
        lastName: json['lastName']?.toString() ?? '',
        status: json['status']?.toString() ?? 'ACTIVE',
        roles: (json['roles'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        permissions: (json['permissions'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      );
    }

    // Support legacy backend envelope format
    return LoginUserData(
      userId: json['user_guid']?.toString() ?? json['user_id']?.toString() ?? '',
      orgId: json['enterprise_id']?.toString() ?? '1',
      email: json['primary_email']?.toString() ?? json['username']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      status: 'ACTIVE',
      roles: [],
      permissions: [],
    );
  }
}

class AuthTokensData {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  const AuthTokensData({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthTokensData.fromJson(Map<String, dynamic> json) => AuthTokensData(
    accessToken: json['accessToken']?.toString() ?? json['access_token']?.toString() ?? '',
    refreshToken: json['refreshToken']?.toString() ?? json['refresh_token']?.toString() ?? '',
    expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 900,
  );
}

/// Represents the full login API response envelope.
class LoginApiResponse {
  final bool success;
  final String message;
  final String? accessToken;
  final String? refreshToken;
  final LoginUserData data;

  const LoginApiResponse({
    required this.success,
    required this.message,
    this.accessToken,
    this.refreshToken,
    required this.data,
  });

  factory LoginApiResponse.fromJson(Map<String, dynamic> json) {
    // New backend format: { data: { user: {...}, tokens: { accessToken, refreshToken, expiresIn } } }
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      final dataMap = json['data'] as Map<String, dynamic>;
      if (dataMap.containsKey('user') && dataMap.containsKey('tokens')) {
        final user = LoginUserData.fromJson(dataMap['user'] as Map<String, dynamic>);
        final tokens = AuthTokensData.fromJson(dataMap['tokens'] as Map<String, dynamic>);
        return LoginApiResponse(
          success: true,
          message: 'Authenticated successfully',
          accessToken: tokens.accessToken,
          refreshToken: tokens.refreshToken,
          data: user,
        );
      }
    }

    // Legacy format support
    return LoginApiResponse(
      success: json['success'] as bool? ?? true,
      message: json['message'] as String? ?? 'Authenticated',
      accessToken: json['access_token'] as String? ?? json['accessToken'] as String?,
      refreshToken: json['refresh_token'] as String? ?? json['refreshToken'] as String?,
      data: LoginUserData.fromJson(
        (json['data'] is Map<String, dynamic>) ? json['data'] as Map<String, dynamic> : json,
      ),
    );
  }
}
