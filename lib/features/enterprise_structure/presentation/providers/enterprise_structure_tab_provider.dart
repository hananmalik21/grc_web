import 'package:flutter_riverpod/flutter_riverpod.dart';

class EnterpriseStructureTabState {
  final int currentTabIndex;

  const EnterpriseStructureTabState({this.currentTabIndex = 0});

  EnterpriseStructureTabState copyWith({int? currentTabIndex}) {
    return EnterpriseStructureTabState(currentTabIndex: currentTabIndex ?? this.currentTabIndex);
  }
}

class EnterpriseStructureTabNotifier extends StateNotifier<EnterpriseStructureTabState> {
  EnterpriseStructureTabNotifier() : super(const EnterpriseStructureTabState());

  void setTabIndex(int index) {
    if (index >= 0 && state.currentTabIndex != index) {
      state = state.copyWith(currentTabIndex: index);
    }
  }
}

final enterpriseStructureTabStateProvider =
    StateNotifierProvider<EnterpriseStructureTabNotifier, EnterpriseStructureTabState>((ref) {
      return EnterpriseStructureTabNotifier();
    });
