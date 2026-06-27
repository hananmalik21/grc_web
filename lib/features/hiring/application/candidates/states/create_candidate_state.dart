import 'package:grc/core/models/document_attachment_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/create_candidate_education_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/create_candidate_work_experience_input.dart';

class CreateCandidateState {
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String phone;
  final String phoneDialCode;
  final String phoneNumber;
  final String currentTitle;
  final String currentEmployer;
  final String yearsOfExperience;
  final String currentLocation;
  final String? source;
  final String expectedSalary;
  final String? salaryCurrency;
  final String noticePeriod;
  final String linkedinProfile;
  final DocumentAttachmentInput? resume;
  final String? existingResumeFileName;
  final List<CreateCandidateEducationInput> educationEntries;
  final List<CreateCandidateWorkExperienceInput> workExperienceEntries;
  final Map<String, String> fieldErrors;
  final String? submitError;
  final bool isSubmitting;

  String? get resumeFileName => resume?.name;

  String? get displayResumeFileName => resume?.name ?? existingResumeFileName;

  const CreateCandidateState({
    this.firstName = '',
    this.middleName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.phoneDialCode = '+965',
    this.phoneNumber = '',
    this.currentTitle = '',
    this.currentEmployer = '',
    this.yearsOfExperience = '',
    this.currentLocation = '',
    this.source,
    this.expectedSalary = '',
    this.salaryCurrency,
    this.noticePeriod = '30 days',
    this.linkedinProfile = '',
    this.resume,
    this.existingResumeFileName,
    this.educationEntries = const [],
    this.workExperienceEntries = const [],
    this.fieldErrors = const {},
    this.submitError,
    this.isSubmitting = false,
  });

  CreateCandidateState copyWith({
    String? firstName,
    String? middleName,
    String? lastName,
    String? email,
    String? phone,
    String? phoneDialCode,
    String? phoneNumber,
    String? currentTitle,
    String? currentEmployer,
    String? yearsOfExperience,
    String? currentLocation,
    String? source,
    String? expectedSalary,
    String? salaryCurrency,
    String? noticePeriod,
    String? linkedinProfile,
    DocumentAttachmentInput? resume,
    bool clearResume = false,
    String? existingResumeFileName,
    bool clearExistingResumeFileName = false,
    List<CreateCandidateEducationInput>? educationEntries,
    List<CreateCandidateWorkExperienceInput>? workExperienceEntries,
    Map<String, String>? fieldErrors,
    String? submitError,
    bool clearSubmitError = false,
    bool? isSubmitting,
  }) {
    return CreateCandidateState(
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      phoneDialCode: phoneDialCode ?? this.phoneDialCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      currentTitle: currentTitle ?? this.currentTitle,
      currentEmployer: currentEmployer ?? this.currentEmployer,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      currentLocation: currentLocation ?? this.currentLocation,
      source: source ?? this.source,
      expectedSalary: expectedSalary ?? this.expectedSalary,
      salaryCurrency: salaryCurrency ?? this.salaryCurrency,
      noticePeriod: noticePeriod ?? this.noticePeriod,
      linkedinProfile: linkedinProfile ?? this.linkedinProfile,
      resume: clearResume ? null : (resume ?? this.resume),
      existingResumeFileName: clearExistingResumeFileName
          ? null
          : (existingResumeFileName ?? this.existingResumeFileName),
      educationEntries: educationEntries ?? this.educationEntries,
      workExperienceEntries: workExperienceEntries ?? this.workExperienceEntries,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}
