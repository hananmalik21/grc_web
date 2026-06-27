import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeManagementTabState {
  final int currentTabIndex;

  const TimeManagementTabState({this.currentTabIndex = 0});

  TimeManagementTabState copyWith({int? currentTabIndex}) {
    return TimeManagementTabState(currentTabIndex: currentTabIndex ?? this.currentTabIndex);
  }
}

class TimeManagementTabNotifier extends StateNotifier<TimeManagementTabState> {
  TimeManagementTabNotifier() : super(const TimeManagementTabState());

  void setTabIndex(int index) {
    if (index >= 0 && state.currentTabIndex != index) {
      state = state.copyWith(currentTabIndex: index);
    }
  }
}

final timeManagementTabStateProvider = StateNotifierProvider<TimeManagementTabNotifier, TimeManagementTabState>((ref) {
  return TimeManagementTabNotifier();
});
