/// Domain model for Structure Level
/// This represents the business entity in the domain layer
class StructureLevel {
  final String id;
  final String name;
  final String icon;
  final int level;
  final bool isMandatory;
  final bool isActive;
  final String previewIcon;

  const StructureLevel({
    required this.id,
    required this.name,
    required this.icon,
    required this.level,
    required this.isMandatory,
    required this.isActive,
    required this.previewIcon,
  });

  StructureLevel copyWith({
    String? id,
    String? name,
    String? icon,
    int? level,
    bool? isMandatory,
    bool? isActive,
    String? previewIcon,
  }) {
    return StructureLevel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      level: level ?? this.level,
      isMandatory: isMandatory ?? this.isMandatory,
      isActive: isActive ?? this.isActive,
      previewIcon: previewIcon ?? this.previewIcon,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StructureLevel &&
        other.id == id &&
        other.name == name &&
        other.icon == icon &&
        other.level == level &&
        other.isMandatory == isMandatory &&
        other.isActive == isActive &&
        other.previewIcon == previewIcon;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        icon.hashCode ^
        level.hashCode ^
        isMandatory.hashCode ^
        isActive.hashCode ^
        previewIcon.hashCode;
  }
}

