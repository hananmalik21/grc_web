class PayrollTabState {
  const PayrollTabState({this.currentTabIndex = 0});

  final int currentTabIndex;

  PayrollTabState copyWith({int? currentTabIndex}) {
    return PayrollTabState(currentTabIndex: currentTabIndex ?? this.currentTabIndex);
  }
}
