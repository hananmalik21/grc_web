import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:flutter/material.dart';

abstract interface class UpdateInterviewFormActions {
  void setInterviewType(String? code);

  void setInterviewRound(String round);

  void setInterviewMode(String? code);

  void setInterviewDate(DateTime date);

  void setStartTime(TimeOfDay time);

  void setEndTime(TimeOfDay time);

  void setMeetingLink(String value);

  void setAdditionalNotes(String value);

  void addInterviewerSlot();

  void removeInterviewerSlot(int index);

  void setInterviewer(int index, Employee employee);

  Future<bool> submit();
}
