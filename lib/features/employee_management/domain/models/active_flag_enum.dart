enum ActiveFlag {
  yes('Y'),
  no('N'),
  unknown('');

  const ActiveFlag(this.raw);
  final String raw;

  static ActiveFlag fromRaw(String? value) {
    if (value == null || value.trim().isEmpty) return ActiveFlag.unknown;
    final upper = value.trim().toUpperCase();
    for (final e in ActiveFlag.values) {
      if (e.raw == upper) return e;
    }
    return ActiveFlag.unknown;
  }

  bool get isActive => this == ActiveFlag.yes;
}
