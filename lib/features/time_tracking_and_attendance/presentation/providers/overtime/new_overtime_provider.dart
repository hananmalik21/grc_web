import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OvertimeTypeOption {
  final int id;
  final String label;
  final String multiplier;

  const OvertimeTypeOption({required this.id, required this.label, required this.multiplier});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OvertimeTypeOption &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          multiplier == other.multiplier;

  @override
  int get hashCode => Object.hash(id, label, multiplier);
}

class NewOvertimeRequestFormState {
  final Employee? selectedEmployee;
  final DateTime? date;
  final OvertimeTypeOption? overtimeType;
  final String? numberOfHours;
  final String? reason;

  final bool isLoading;
  final bool isDraftLoading;

  const NewOvertimeRequestFormState({
    this.selectedEmployee,
    this.date,
    this.overtimeType,
    this.numberOfHours,
    this.reason,
    this.isLoading = false,
    this.isDraftLoading = false,
  });

  String? get estimatedRate => overtimeType?.multiplier;
}

class NewOvertimeRequestNotifier extends StateNotifier<NewOvertimeRequestFormState> {
  NewOvertimeRequestNotifier() : super(const NewOvertimeRequestFormState());

  void setEmployeeFromSelection(Employee? employee) {
    final employeeChanged = employee?.id != state.selectedEmployee?.id;
    state = state.copyWith(selectedEmployee: employee, clearDate: employeeChanged);
  }

  void setDate(DateTime? date) {
    state = state.copyWith(date: date, clearNumberOfHours: true);
  }

  void setOvertimeType(OvertimeTypeOption? type) {
    state = state.copyWith(overtimeType: type);
  }

  void setNumberOfHours(String? value) {
    state = state.copyWith(numberOfHours: value);
  }

  void setReason(String? value) {
    state = state.copyWith(reason: value);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setDraftLoading(bool loading) {
    state = state.copyWith(isDraftLoading: loading);
  }

  void reset() {
    state = const NewOvertimeRequestFormState();
  }

  bool validate() {
    if (state.selectedEmployee == null) return false;
    if (state.date == null) return false;
    if (state.overtimeType == null) return false;
    final hours = state.numberOfHours?.trim();
    if (hours == null || hours.isEmpty) return false;
    if (double.tryParse(hours) == null || double.parse(hours) <= 0) return false;
    final reason = state.reason?.trim();
    if (reason == null || reason.isEmpty) return false;
    return true;
  }

  String? get validationError {
    if (state.selectedEmployee == null) return 'Please select an employee';
    if (state.date == null) return 'Please select overtime date';
    if (state.overtimeType == null) return 'Please select overtime type';
    final hours = state.numberOfHours?.trim();
    if (hours == null || hours.isEmpty) return 'Please enter number of hours';
    final parsed = double.tryParse(hours);
    if (parsed == null || parsed <= 0) return 'Please enter a valid number of hours';
    final reason = state.reason?.trim();
    if (reason == null || reason.isEmpty) return 'Please enter justification/reason';
    return null;
  }
}

extension _CopyWith on NewOvertimeRequestFormState {
  NewOvertimeRequestFormState copyWith({
    Employee? selectedEmployee,
    DateTime? date,
    bool clearDate = false,
    OvertimeTypeOption? overtimeType,
    String? numberOfHours,
    bool clearNumberOfHours = false,
    String? reason,
    bool? isLoading,
    bool? isDraftLoading,
  }) {
    return NewOvertimeRequestFormState(
      selectedEmployee: selectedEmployee ?? this.selectedEmployee,
      date: clearDate ? null : (date ?? this.date),
      overtimeType: overtimeType ?? this.overtimeType,
      numberOfHours: clearNumberOfHours ? null : (numberOfHours ?? this.numberOfHours),
      reason: reason ?? this.reason,
      isLoading: isLoading ?? this.isLoading,
      isDraftLoading: isDraftLoading ?? this.isDraftLoading,
    );
  }
}

final newOvertimeRequestProvider = StateNotifierProvider<NewOvertimeRequestNotifier, NewOvertimeRequestFormState>(
  (ref) => NewOvertimeRequestNotifier(),
);
