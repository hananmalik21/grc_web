import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkforceTabState {
  final int currentTabIndex;

  const WorkforceTabState({this.currentTabIndex = 0});

  WorkforceTabState copyWith({int? currentTabIndex}) {
    return WorkforceTabState(currentTabIndex: currentTabIndex ?? this.currentTabIndex);
  }
}

class WorkforceTabNotifier extends StateNotifier<WorkforceTabState> {
  WorkforceTabNotifier() : super(const WorkforceTabState());

  void setTabIndex(int index) {
    if (index >= 0 && state.currentTabIndex != index) {
      state = state.copyWith(currentTabIndex: index);
    }
  }
}

final workforceTabStateProvider = StateNotifierProvider<WorkforceTabNotifier, WorkforceTabState>((ref) {
  return WorkforceTabNotifier();
});
