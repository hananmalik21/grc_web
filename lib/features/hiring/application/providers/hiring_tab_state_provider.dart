import 'package:flutter_riverpod/flutter_riverpod.dart';

class HiringTabState {
  final int currentTabIndex;

  const HiringTabState({this.currentTabIndex = 0});

  HiringTabState copyWith({int? currentTabIndex}) {
    return HiringTabState(currentTabIndex: currentTabIndex ?? this.currentTabIndex);
  }
}

class HiringTabNotifier extends StateNotifier<HiringTabState> {
  HiringTabNotifier() : super(const HiringTabState());

  void setTabIndex(int index) {
    if (index >= 0 && state.currentTabIndex != index) {
      state = state.copyWith(currentTabIndex: index);
    }
  }
}

final hiringTabStateProvider = StateNotifierProvider<HiringTabNotifier, HiringTabState>((ref) {
  return HiringTabNotifier();
});
