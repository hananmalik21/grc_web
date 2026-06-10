class LibraryFramework {
  const LibraryFramework({
    required this.id,
    required this.title,
    required this.questionCount,
  });

  final String id;
  final String title;
  final int questionCount;
}

class LibrarySection {
  const LibrarySection({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.questionCount,
    required this.weightPercent,
    required this.questions,
  });

  final String id;
  final String title;
  final String subtitle;
  final int questionCount;
  final int weightPercent;
  final List<LibraryQuestion> questions;
}

class LibraryQuestion {
  const LibraryQuestion({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.weight,
    required this.requiresEvidence,
    required this.typeChip,
    required this.categoryChips,
    required this.tags,
    required this.evaluationCriteria,
    required this.relatedControls,
    this.guidanceNotes = '',
  });

  final String id;
  final String code;
  final String title;
  final String description;
  final int weight;
  final bool requiresEvidence;
  final String typeChip;
  final List<String> categoryChips;
  final List<String> tags;
  final List<EvaluationCriterion> evaluationCriteria;
  final List<String> relatedControls;
  final String guidanceNotes;
}

class EvaluationCriterion {
  const EvaluationCriterion({
    required this.title,
    required this.weightPercent,
    required this.iconAsset,
  });

  final String title;
  final int weightPercent;
  final String iconAsset;
}

class LibraryData {
  const LibraryData({
    required this.frameworks,
    required this.selectedFrameworkId,
    required this.totalQuestions,
    required this.categories,
    required this.requireEvidence,
    required this.version,
    required this.sections,
  });

  final List<LibraryFramework> frameworks;
  final String selectedFrameworkId;
  final int totalQuestions;
  final int categories;
  final int requireEvidence;
  final String version;
  final List<LibrarySection> sections;
}

