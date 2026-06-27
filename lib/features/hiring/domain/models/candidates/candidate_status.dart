enum CandidateStatus {
  all('ALL'),
  active('ACTIVE'),
  hired('HIRED'),
  rejected('REJECTED'),
  blacklisted('BLACKLISTED');

  const CandidateStatus(this.raw);
  final String raw;

  static CandidateStatus fromRaw(String? value) {
    if (value == null || value.trim().isEmpty) return CandidateStatus.all;
    final upper = value.trim().toUpperCase();
    for (final e in CandidateStatus.values) {
      if (e.raw == upper) return e;
    }
    return CandidateStatus.all;
  }
}
