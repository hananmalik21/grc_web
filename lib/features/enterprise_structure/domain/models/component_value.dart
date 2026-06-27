/// Component value domain model
class ComponentValue {
  final String id;
  final String code;
  final String name;
  final String arabicName;
  final ComponentType type;
  final String? parentId;
  final String? managerId;
  final String? location;
  final bool status; // true = Active, false = Inactive
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;

  ComponentValue({
    required this.id,
    required this.code,
    required this.name,
    required this.arabicName,
    required this.type,
    this.parentId,
    this.managerId,
    this.location,
    this.status = true,
    this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  ComponentValue copyWith({
    String? id,
    String? code,
    String? name,
    String? arabicName,
    ComponentType? type,
    String? parentId,
    String? managerId,
    String? location,
    bool? status,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ComponentValue(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      arabicName: arabicName ?? this.arabicName,
      type: type ?? this.type,
      parentId: parentId ?? this.parentId,
      managerId: managerId ?? this.managerId,
      location: location ?? this.location,
      status: status ?? this.status,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ComponentValue && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Component type enum
enum ComponentType {
  company,
  division,
  businessUnit,
  department,
  section,
}

extension ComponentTypeExtension on ComponentType {
  String get displayName {
    switch (this) {
      case ComponentType.company:
        return 'Company';
      case ComponentType.division:
        return 'Division';
      case ComponentType.businessUnit:
        return 'Business Unit';
      case ComponentType.department:
        return 'Department';
      case ComponentType.section:
        return 'Section';
    }
  }
}

