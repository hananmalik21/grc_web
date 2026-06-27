import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompensationTabState {
  final int currentTabIndex;

  const CompensationTabState({this.currentTabIndex = 0});

  CompensationTabState copyWith({int? currentTabIndex}) {
    return CompensationTabState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }
}

class CompensationTabNotifier extends StateNotifier<CompensationTabState> {
  CompensationTabNotifier() : super(const CompensationTabState());

  void setTabIndex(int index) {
    if (index >= 0 && state.currentTabIndex != index) {
      state = state.copyWith(currentTabIndex: index);
    }
  }
}

final compensationTabStateProvider =
    StateNotifierProvider<CompensationTabNotifier, CompensationTabState>((ref) {
      return CompensationTabNotifier();
    });
