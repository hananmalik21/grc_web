enum PositionStatus {
  active('Active'),
  inactive('InActive');

  final String label;
  const PositionStatus(this.label);

  @override
  String toString() => label;
}
