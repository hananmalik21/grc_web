enum ActiveSessionStatus { active, idle, locked }

extension ActiveSessionStatusX on ActiveSessionStatus {
  String get label {
    switch (this) {
      case ActiveSessionStatus.active:
        return 'Active';
      case ActiveSessionStatus.idle:
        return 'Idle';
      case ActiveSessionStatus.locked:
        return 'Locked';
    }
  }
}

class ActiveSession {
  final String sessionId;
  final String userName;
  final String userEmail;
  final String employeeId;
  final String city;
  final String country;
  final String ipAddress;
  final String deviceName;
  final String deviceType; // e.g. Desktop, Mobile, Tablet
  final String browser;
  final String loginAt;
  final String lastActiveAt;
  final ActiveSessionStatus status;
  final bool isCurrent;

  const ActiveSession({
    required this.sessionId,
    required this.userName,
    required this.userEmail,
    required this.employeeId,
    required this.city,
    required this.country,
    required this.ipAddress,
    required this.deviceName,
    required this.deviceType,
    required this.browser,
    required this.loginAt,
    required this.lastActiveAt,
    required this.status,
    this.isCurrent = false,
  });
}
