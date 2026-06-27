/// Job Family domain model (Entity)
/// Represents a job family grouping positions by function
/// This is a pure domain entity with no serialization logic
class JobFamily {
  final int id;
  final String code;
  final String nameEnglish;
  final String nameArabic;
  final String description;
  final int totalPositions;
  final int filledPositions;
  final double fillRate;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const JobFamily({
    required this.id,
    required this.code,
    required this.nameEnglish,
    required this.nameArabic,
    required this.description,
    required this.totalPositions,
    required this.filledPositions,
    required this.fillRate,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  int get vacantPositions => totalPositions - filledPositions;

  JobFamily copyWith({
    int? id,
    String? code,
    String? nameEnglish,
    String? nameArabic,
    String? description,
    int? totalPositions,
    int? filledPositions,
    double? fillRate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return JobFamily(
      id: id ?? this.id,
      code: code ?? this.code,
      nameEnglish: nameEnglish ?? this.nameEnglish,
      nameArabic: nameArabic ?? this.nameArabic,
      description: description ?? this.description,
      totalPositions: totalPositions ?? this.totalPositions,
      filledPositions: filledPositions ?? this.filledPositions,
      fillRate: fillRate ?? this.fillRate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is JobFamily && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() {
    return 'JobFamily(code: $code, nameEnglish: $nameEnglish, nameArabic: $nameArabic)';
  }
}
