import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeavePoliciesFilterState {
  final String? status;
  final String? kuwaitLaborCompliant;
  final String? type;

  const LeavePoliciesFilterState({this.status, this.kuwaitLaborCompliant, this.type});

  LeavePoliciesFilterState copyWith({String? status, String? kuwaitLaborCompliant, String? type}) {
    return LeavePoliciesFilterState(
      status: status ?? this.status,
      kuwaitLaborCompliant: kuwaitLaborCompliant ?? this.kuwaitLaborCompliant,
      type: type ?? this.type,
    );
  }
}

class LeavePoliciesFilterNotifier extends StateNotifier<LeavePoliciesFilterState> {
  LeavePoliciesFilterNotifier() : super(const LeavePoliciesFilterState());

  void setStatus(String? value) {
    state = LeavePoliciesFilterState(status: value, kuwaitLaborCompliant: state.kuwaitLaborCompliant, type: state.type);
  }

  void setKuwaitLaborCompliant(String? value) {
    state = LeavePoliciesFilterState(status: state.status, kuwaitLaborCompliant: value, type: state.type);
  }

  void setType(String? value) {
    state = LeavePoliciesFilterState(
      status: state.status,
      kuwaitLaborCompliant: state.kuwaitLaborCompliant,
      type: value,
    );
  }
}

final leavePoliciesFilterProvider = StateNotifierProvider<LeavePoliciesFilterNotifier, LeavePoliciesFilterState>((ref) {
  return LeavePoliciesFilterNotifier();
});
