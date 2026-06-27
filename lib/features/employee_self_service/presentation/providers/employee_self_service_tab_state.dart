class EmployeeSelfServiceTabState {
  final int currentTabIndex;

  const EmployeeSelfServiceTabState({this.currentTabIndex = 0});

  EmployeeSelfServiceTabState copyWith({int? currentTabIndex}) {
    return EmployeeSelfServiceTabState(currentTabIndex: currentTabIndex ?? this.currentTabIndex);
  }
}
