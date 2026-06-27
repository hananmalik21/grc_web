/// Domain model for Forfeit Policy
class ForfeitPolicy {
  final String id;
  final String name;
  final String nameArabic;
  final List<String> tags;
  final bool isActive;
  final bool isSelected;

  const ForfeitPolicy({
    required this.id,
    required this.name,
    required this.nameArabic,
    this.tags = const [],
    this.isActive = true,
    this.isSelected = false,
  });

  ForfeitPolicy copyWith({
    String? id,
    String? name,
    String? nameArabic,
    List<String>? tags,
    bool? isActive,
    bool? isSelected,
  }) {
    return ForfeitPolicy(
      id: id ?? this.id,
      name: name ?? this.name,
      nameArabic: nameArabic ?? this.nameArabic,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
