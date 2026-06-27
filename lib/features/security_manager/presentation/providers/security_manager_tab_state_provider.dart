import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecurityManagerTabState {
  final int currentTabIndex;

  const SecurityManagerTabState({this.currentTabIndex = 0});

  SecurityManagerTabState copyWith({int? currentTabIndex}) {
    return SecurityManagerTabState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }
}

class SecurityManagerTabNotifier
    extends StateNotifier<SecurityManagerTabState> {
  SecurityManagerTabNotifier() : super(const SecurityManagerTabState());

  void setTabIndex(int index) {
    if (index >= 0 && state.currentTabIndex != index) {
      state = state.copyWith(currentTabIndex: index);
    }
  }
}

final securityManagerTabStateProvider =
    StateNotifierProvider<SecurityManagerTabNotifier, SecurityManagerTabState>((
      ref,
    ) {
      return SecurityManagerTabNotifier();
    });
