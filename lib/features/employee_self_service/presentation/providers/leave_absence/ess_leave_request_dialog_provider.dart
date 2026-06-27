import 'package:grc/features/employee_self_service/presentation/providers/leave_absence/ess_leave_request_dialog_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EssLeaveRequestDialogNotifier extends StateNotifier<EssLeaveRequestDialogState> {
  EssLeaveRequestDialogNotifier() : super(const EssLeaveRequestDialogState());

  static const leaveTypes = [
    'Annual Leave',
    'Sick Leave',
    'Casual Leave',
    'Compassionate Leave',
    'Maternity Leave',
    'Unpaid Leave',
  ];

  void setLeaveType(String? value) {
    state = state.copyWith(leaveType: value, clearValidationMessage: true);
  }

  void setStartDate(DateTime value) {
    DateTime? endDate = state.endDate;
    if (endDate != null && endDate.isBefore(value)) {
      endDate = value;
    }

    state = state.copyWith(startDate: value, endDate: endDate, clearValidationMessage: true);
  }

  void setEndDate(DateTime value) {
    state = state.copyWith(endDate: value, clearValidationMessage: true);
  }

  void setReason(String value) {
    state = state.copyWith(reason: value, clearValidationMessage: true);
  }

  void addMockAttachment() {
    final nextIndex = state.attachments.length + 1;
    state = state.copyWith(attachments: [...state.attachments, 'supporting_document_$nextIndex.pdf']);
  }

  void removeAttachment(String name) {
    state = state.copyWith(attachments: state.attachments.where((attachment) => attachment != name).toList());
  }

  bool validate() {
    String? message;

    if (state.leaveType == null || state.leaveType!.trim().isEmpty) {
      message = 'Please select a leave type.';
    } else if (state.startDate == null) {
      message = 'Please select a start date.';
    } else if (state.endDate == null) {
      message = 'Please select an end date.';
    } else if (state.startDate != null && state.endDate != null && state.endDate!.isBefore(state.startDate!)) {
      message = 'End date cannot be before start date.';
    } else if (state.reason.trim().isEmpty) {
      message = 'Please enter a reason for your leave request.';
    }

    state = state.copyWith(validationMessage: message, clearValidationMessage: message == null);

    return message == null;
  }

  void reset() {
    state = const EssLeaveRequestDialogState();
  }
}

final essLeaveRequestDialogProvider =
    StateNotifierProvider.autoDispose<EssLeaveRequestDialogNotifier, EssLeaveRequestDialogState>((ref) {
      return EssLeaveRequestDialogNotifier();
    });
