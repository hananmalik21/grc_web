import 'package:flutter_riverpod/flutter_riverpod.dart';

class CyberSecurityTabState {
  final int currentTabIndex;

  const CyberSecurityTabState({this.currentTabIndex = 0});

  CyberSecurityTabState copyWith({int? currentTabIndex}) {
    return CyberSecurityTabState(
      currentTabIndex: currentTabIndex ?? this.currentTabIndex,
    );
  }
}

class CyberSecurityTabStateNotifier
    extends StateNotifier<CyberSecurityTabState> {
  CyberSecurityTabStateNotifier() : super(const CyberSecurityTabState());

  void setTabIndex(int index) {
    state = state.copyWith(currentTabIndex: index);
  }
}

final cyberSecurityTabStateProvider =
    StateNotifierProvider<CyberSecurityTabStateNotifier, CyberSecurityTabState>(
      (ref) => CyberSecurityTabStateNotifier(),
    );
