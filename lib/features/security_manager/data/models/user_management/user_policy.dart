class UserPolicy {
  final int id;
  final String title;
  final String description;
  final String type;

  UserPolicy({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
  });

  UserPolicy copyWith({
    int? id,
    String? title,
    String? description,
    String? type,
  }) {
    return UserPolicy(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
    );
  }
}
