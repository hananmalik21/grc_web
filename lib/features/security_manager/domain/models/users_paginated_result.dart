import 'system_user.dart';

class UsersPaginatedResult {
  final List<SystemUser> users;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const UsersPaginatedResult({
    required this.users,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  static const empty = UsersPaginatedResult(users: [], total: 0, totalPages: 1, hasNext: false, hasPrevious: false);
}
