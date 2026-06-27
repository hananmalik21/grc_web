class FunctionalPrivileges {
  final int id;
  final String name;
  final String description;
  final String type;

  FunctionalPrivileges({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
  });

  FunctionalPrivileges copyWith({
    int? id,
    String? name,
    String? description,
    String? type,
  }) {
    return FunctionalPrivileges(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
    );
  }
}
