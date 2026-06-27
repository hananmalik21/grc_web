import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimeTrackingAndAttendanceTabState {
  final int currentTabIndex;

  const TimeTrackingAndAttendanceTabState({this.currentTabIndex = 0});

  TimeTrackingAndAttendanceTabState copyWith({int? currentTabIndex}) {
    return TimeTrackingAndAttendanceTabState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }
}

class TimeTrackingAndAttendanceTabNotifier
    extends StateNotifier<TimeTrackingAndAttendanceTabState> {
  TimeTrackingAndAttendanceTabNotifier()
    : super(const TimeTrackingAndAttendanceTabState());

  void setTabIndex(int index) {
    if (index >= 0 && state.currentTabIndex != index) {
      state = state.copyWith(currentTabIndex: index);
    }
  }
}

final timeTrackingAndAttendanceTabStateProvider =
    StateNotifierProvider<
      TimeTrackingAndAttendanceTabNotifier,
      TimeTrackingAndAttendanceTabState
    >((ref) {
      return TimeTrackingAndAttendanceTabNotifier();
    });
