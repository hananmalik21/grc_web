import 'package:grc/features/hiring/application/candidates/states/create_candidate_state.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/domain/models/candidates/candidate.dart';
import 'package:grc/features/hiring/domain/models/candidates/create_candidate_education_input.dart';
import 'package:grc/features/hiring/domain/models/candidates/create_candidate_work_experience_input.dart';

class CandidateFormSeedMapper {
  CandidateFormSeedMapper._();

  static CreateCandidateState fromCandidate(Candidate candidate) {
    final phoneParts = _splitPhone(candidate.phone);
    final noticePeriod = _resolveNoticePeriod(candidate.noticePeriod);

    return CreateCandidateState(
      firstName: candidate.firstName,
      middleName: candidate.middleName ?? '',
      lastName: candidate.lastName,
      email: candidate.email,
      phone: candidate.phone,
      phoneDialCode: phoneParts.dialCode,
      phoneNumber: phoneParts.number,
      currentTitle: candidate.currentTitle ?? '',
      currentEmployer: candidate.currentEmployer ?? '',
      yearsOfExperience: candidate.yearsExperience?.toString() ?? '',
      currentLocation: candidate.currentLocation ?? '',
      source: candidate.source,
      expectedSalary: candidate.expectedSalary?.toString() ?? '',
      salaryCurrency: candidate.salaryCurrency,
      noticePeriod: noticePeriod,
      linkedinProfile: candidate.linkedinProfile ?? '',
      existingResumeFileName: candidate.primaryResume?.fileName,
      educationEntries: candidate.education.map(_mapEducation).toList(),
      workExperienceEntries: candidate.experience.map(_mapExperience).toList(),
    );
  }

  static CreateCandidateEducationInput _mapEducation(CandidateEducation education) {
    final now = DateTime.now();
    return CreateCandidateEducationInput(
      id: education.educationGuid.isNotEmpty ? education.educationGuid : 'edu-${education.educationId}',
      degreeName: education.degreeName,
      institutionName: education.institutionName,
      fieldOfStudy: education.fieldOfStudy,
      startDate: education.startDate ?? now,
      endDate: education.endDate ?? now,
      grade: education.grade,
      description: education.description,
    );
  }

  static CreateCandidateWorkExperienceInput _mapExperience(CandidateExperience experience) {
    final now = DateTime.now();
    final isCurrent = experience.currentJobFlag == 'Y';
    return CreateCandidateWorkExperienceInput(
      id: experience.experienceGuid.isNotEmpty ? experience.experienceGuid : 'exp-${experience.experienceId}',
      companyName: experience.companyName,
      jobTitle: experience.jobTitle,
      location: experience.location,
      startDate: experience.startDate ?? now,
      endDate: isCurrent ? null : experience.endDate,
      isCurrentJob: isCurrent,
      description: experience.description,
    );
  }

  static String _resolveNoticePeriod(String? noticePeriod) {
    final value = noticePeriod?.trim();
    if (value == null || value.isEmpty) {
      return HiringConfig.noticePeriodOptions[2];
    }
    if (HiringConfig.noticePeriodOptions.contains(value)) {
      return value;
    }
    return HiringConfig.noticePeriodOptions[2];
  }

  static _PhoneParts _splitPhone(String phone) {
    const defaultDialCode = '+965';
    final trimmed = phone.trim();
    if (trimmed.isEmpty) {
      return const _PhoneParts(dialCode: defaultDialCode, number: '');
    }
    if (trimmed.startsWith('+')) {
      for (final dialCode in ['+965', '+971', '+966', '+974', '+973', '+968']) {
        if (trimmed.startsWith(dialCode)) {
          return _PhoneParts(dialCode: dialCode, number: trimmed.substring(dialCode.length));
        }
      }
      final spaceIndex = trimmed.indexOf(' ');
      if (spaceIndex > 1) {
        return _PhoneParts(dialCode: trimmed.substring(0, spaceIndex), number: trimmed.substring(spaceIndex + 1));
      }
    }
    return _PhoneParts(dialCode: defaultDialCode, number: trimmed);
  }
}

class _PhoneParts {
  const _PhoneParts({required this.dialCode, required this.number});

  final String dialCode;
  final String number;
}
