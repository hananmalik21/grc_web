import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeveloperToolsTabState {
  final int currentTabIndex;

  const DeveloperToolsTabState({this.currentTabIndex = 0});

  DeveloperToolsTabState copyWith({int? currentTabIndex}) {
    return DeveloperToolsTabState(currentTabIndex: currentTabIndex ?? this.currentTabIndex);
  }
}

class DeveloperToolsTabNotifier extends StateNotifier<DeveloperToolsTabState> {
  DeveloperToolsTabNotifier() : super(const DeveloperToolsTabState());

  void setTabIndex(int index) {
    if (index >= 0 && state.currentTabIndex != index) {
      state = state.copyWith(currentTabIndex: index);
    }
  }
}

final developerToolsTabStateProvider = StateNotifierProvider<DeveloperToolsTabNotifier, DeveloperToolsTabState>((ref) {
  return DeveloperToolsTabNotifier();
});
