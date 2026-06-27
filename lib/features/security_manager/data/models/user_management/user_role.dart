class UserRole {
  final int id;
  final String title;
  final String description;
  final String type;
  final int userCount;

  UserRole({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.userCount,
  });

  UserRole copyWith({
    int? id,
    String? title,
    String? description,
    String? type,
    int? userCount,
  }) {
    return UserRole(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      userCount: userCount ?? this.userCount,
    );
  }
}
