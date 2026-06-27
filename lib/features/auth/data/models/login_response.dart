/// Represents user data returned from a successful login.
class LoginUserData {
  final int userId;
  final String userGuid;
  final int enterpriseId;
  final String userCode;
  final String username;
  final String firstName;
  final String lastName;
  final String primaryEmail;
  final String passwordExpired;

  const LoginUserData({
    required this.userId,
    required this.userGuid,
    required this.enterpriseId,
    required this.userCode,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.primaryEmail,
    required this.passwordExpired,
  });

  factory LoginUserData.fromJson(Map<String, dynamic> json) => LoginUserData(
    userId: json['user_id'] as int,
    userGuid: json['user_guid'] as String,
    enterpriseId: json['enterprise_id'] as int,
    userCode: json['user_code'] as String,
    username: json['username'] as String,
    firstName: json['first_name'] as String,
    lastName: json['last_name'] as String,
    primaryEmail: json['primary_email'] as String,
    passwordExpired: json['password_expired'] as String,
  );
}

/// Represents the full login API response envelope.
class LoginApiResponse {
  final bool success;
  final String message;
  final String? accessToken;
  final LoginUserData data;

  const LoginApiResponse({required this.success, required this.message, this.accessToken, required this.data});

  factory LoginApiResponse.fromJson(Map<String, dynamic> json) => LoginApiResponse(
    success: json['success'] as bool,
    message: json['message'] as String,
    accessToken: json['access_token'] as String?,
    data: LoginUserData.fromJson(json['data'] as Map<String, dynamic>),
  );
}
