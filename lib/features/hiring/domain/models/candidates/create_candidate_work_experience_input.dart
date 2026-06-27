import 'package:intl/intl.dart';

class CreateCandidateWorkExperienceInput {
  const CreateCandidateWorkExperienceInput({
    required this.id,
    required this.companyName,
    required this.jobTitle,
    required this.location,
    required this.startDate,
    this.endDate,
    required this.isCurrentJob,
    this.description = '',
  });

  final String id;
  final String companyName;
  final String jobTitle;
  final String location;
  final DateTime startDate;
  final DateTime? endDate;
  final bool isCurrentJob;
  final String description;

  String get displayTitle => jobTitle;

  String get displaySubtitle {
    final endLabel = isCurrentJob ? 'Present' : (endDate?.year.toString() ?? '—');
    return '$companyName · $location · ${startDate.year} – $endLabel';
  }

  CreateCandidateWorkExperienceInput copyWith({
    String? id,
    String? companyName,
    String? jobTitle,
    String? location,
    DateTime? startDate,
    DateTime? endDate,
    bool clearEndDate = false,
    bool? isCurrentJob,
    String? description,
  }) {
    return CreateCandidateWorkExperienceInput(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      jobTitle: jobTitle ?? this.jobTitle,
      location: location ?? this.location,
      startDate: startDate ?? this.startDate,
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      isCurrentJob: isCurrentJob ?? this.isCurrentJob,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toApiJson() {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return {
      'company_name': companyName,
      'job_title': jobTitle,
      'location': location,
      'start_date': dateFormat.format(startDate),
      'end_date': endDate != null ? dateFormat.format(endDate!) : null,
      'current_job_flag': isCurrentJob ? 'Y' : 'N',
      if (description.trim().isNotEmpty) 'description': description.trim(),
    };
  }
}
