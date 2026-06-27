import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveManagementTabState {
  final int currentTabIndex;

  const LeaveManagementTabState({this.currentTabIndex = 0});

  LeaveManagementTabState copyWith({int? currentTabIndex}) {
    return LeaveManagementTabState(currentTabIndex: currentTabIndex ?? this.currentTabIndex);
  }
}

class LeaveManagementTabNotifier extends StateNotifier<LeaveManagementTabState> {
  LeaveManagementTabNotifier() : super(const LeaveManagementTabState());

  void setTabIndex(int index) {
    if (index >= 0 && state.currentTabIndex != index) {
      state = state.copyWith(currentTabIndex: index);
    }
  }
}

final leaveManagementTabStateProvider = StateNotifierProvider<LeaveManagementTabNotifier, LeaveManagementTabState>((
  ref,
) {
  return LeaveManagementTabNotifier();
});
