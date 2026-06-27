import 'grade_step.dart';

/// Represents a grade with a list of steps.
class GradeStructure {
  final String gradeLabel;
  final String gradeCategory;
  final String description;
  final List<GradeStep> steps;

  const GradeStructure({
    required this.gradeLabel,
    required this.gradeCategory,
    required this.description,
    required this.steps,
  });
}

