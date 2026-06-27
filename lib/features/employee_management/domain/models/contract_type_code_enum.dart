enum ContractTypeCode {
  fullTime('FULL_TIME'),
  partTime('PART_TIME'),
  permanent('PERMANENT'),
  temporary('TEMPORARY'),
  contract('CONTRACT'),
  unknown('');

  const ContractTypeCode(this.raw);
  final String raw;

  static ContractTypeCode fromRaw(String? value) {
    if (value == null || value.trim().isEmpty) return ContractTypeCode.unknown;
    final upper = value.trim().toUpperCase();
    for (final e in ContractTypeCode.values) {
      if (e.raw == upper) return e;
    }
    return ContractTypeCode.unknown;
  }
}
