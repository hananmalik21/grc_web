enum ActiveInactiveStatus {
  active('Active'),
  inactive('Inactive');

  const ActiveInactiveStatus(this.label);

  final String label;

  bool get isActive => this == ActiveInactiveStatus.active;

  @override
  String toString() => label;
}
