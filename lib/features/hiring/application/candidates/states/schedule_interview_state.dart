import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:flutter/material.dart';

class ScheduleInterviewState {
  const ScheduleInterviewState({
    required this.candidateGuid,
    this.interviewTypeCode,
    this.interviewRound = '1',
    this.interviewModeCode,
    this.interviewDate,
    this.startTime,
    this.endTime,
    this.meetingLink = '',
    this.additionalNotes = '',
    this.interviewers = const <Employee?>[null],
    this.isSubmitting = false,
    this.submitError,
    this.fieldErrors = const {},
  });

  final String candidateGuid;
  final String? interviewTypeCode;
  final String interviewRound;
  final String? interviewModeCode;
  final DateTime? interviewDate;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final String meetingLink;
  final String additionalNotes;
  final List<Employee?> interviewers;
  final bool isSubmitting;
  final String? submitError;
  final Map<String, String> fieldErrors;

  List<Employee> get selectedInterviewers => interviewers.whereType<Employee>().toList();

  ScheduleInterviewState copyWith({
    String? candidateGuid,
    String? interviewTypeCode,
    String? interviewRound,
    String? interviewModeCode,
    DateTime? interviewDate,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    String? meetingLink,
    String? additionalNotes,
    List<Employee?>? interviewers,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
    Map<String, String>? fieldErrors,
    bool clearFieldErrors = false,
  }) {
    return ScheduleInterviewState(
      candidateGuid: candidateGuid ?? this.candidateGuid,
      interviewTypeCode: interviewTypeCode ?? this.interviewTypeCode,
      interviewRound: interviewRound ?? this.interviewRound,
      interviewModeCode: interviewModeCode ?? this.interviewModeCode,
      interviewDate: interviewDate ?? this.interviewDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      meetingLink: meetingLink ?? this.meetingLink,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      interviewers: interviewers ?? this.interviewers,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      fieldErrors: clearFieldErrors ? const {} : (fieldErrors ?? this.fieldErrors),
    );
  }
}
