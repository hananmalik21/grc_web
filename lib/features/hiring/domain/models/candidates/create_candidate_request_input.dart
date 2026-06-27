import 'package:grc/core/models/document_attachment_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/create_candidate_education_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/create_candidate_work_experience_input.dart';

class CreateCandidateRequestInput {
  const CreateCandidateRequestInput({
    required this.enterpriseId,
    required this.createdBy,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.source,
    this.middleName,
    this.currentTitle,
    this.currentEmployer,
    this.yearsExperience,
    this.currentLocation,
    this.expectedSalary,
    this.salaryCurrency,
    this.noticePeriod,
    this.linkedinProfile,
    this.resume,
    this.educationEntries = const [],
    this.workExperienceEntries = const [],
  });

  final int enterpriseId;
  final String createdBy;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String source;
  final String? middleName;
  final String? currentTitle;
  final String? currentEmployer;
  final String? yearsExperience;
  final String? currentLocation;
  final String? expectedSalary;
  final String? salaryCurrency;
  final String? noticePeriod;
  final String? linkedinProfile;
  final DocumentAttachmentInput? resume;
  final List<CreateCandidateEducationInput> educationEntries;
  final List<CreateCandidateWorkExperienceInput> workExperienceEntries;
}
