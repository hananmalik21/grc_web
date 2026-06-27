import 'package:intl/intl.dart';

class CreateCandidateEducationInput {
  const CreateCandidateEducationInput({
    required this.id,
    required this.degreeName,
    required this.institutionName,
    required this.fieldOfStudy,
    required this.startDate,
    required this.endDate,
    required this.grade,
    this.description = '',
  });

  final String id;
  final String degreeName;
  final String institutionName;
  final String fieldOfStudy;
  final DateTime startDate;
  final DateTime endDate;
  final String grade;
  final String description;

  String get displayTitle => degreeName;

  String get displaySubtitle {
    final years = '${startDate.year} – ${endDate.year}';
    return '$institutionName · $fieldOfStudy · $years';
  }

  CreateCandidateEducationInput copyWith({
    String? id,
    String? degreeName,
    String? institutionName,
    String? fieldOfStudy,
    DateTime? startDate,
    DateTime? endDate,
    String? grade,
    String? description,
  }) {
    return CreateCandidateEducationInput(
      id: id ?? this.id,
      degreeName: degreeName ?? this.degreeName,
      institutionName: institutionName ?? this.institutionName,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      grade: grade ?? this.grade,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toApiJson() {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return {
      'degree_name': degreeName,
      'institution_name': institutionName,
      'field_of_study': fieldOfStudy,
      'start_date': dateFormat.format(startDate),
      'end_date': dateFormat.format(endDate),
      'grade': grade,
      if (description.trim().isNotEmpty) 'description': description.trim(),
    };
  }
}
