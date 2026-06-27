import 'package:flutter_riverpod/flutter_riverpod.dart';

class EmployeeManagementTabState {
  final int currentTabIndex;

  const EmployeeManagementTabState({this.currentTabIndex = 0});

  EmployeeManagementTabState copyWith({int? currentTabIndex}) {
    return EmployeeManagementTabState(currentTabIndex: currentTabIndex ?? this.currentTabIndex);
  }
}

class EmployeeManagementTabNotifier extends StateNotifier<EmployeeManagementTabState> {
  EmployeeManagementTabNotifier() : super(const EmployeeManagementTabState());

  void setTabIndex(int index) {
    if (index >= 0 && state.currentTabIndex != index) {
      state = state.copyWith(currentTabIndex: index);
    }
  }
}

final employeeManagementTabStateProvider =
    StateNotifierProvider<EmployeeManagementTabNotifier, EmployeeManagementTabState>((ref) {
      return EmployeeManagementTabNotifier();
    });
