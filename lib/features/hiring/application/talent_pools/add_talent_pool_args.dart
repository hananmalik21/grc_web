class AddTalentPoolArgs {
  const AddTalentPoolArgs({required this.candidateGuid, this.initialSelectedPoolGuids = const {}});

  final String candidateGuid;
  final Set<String> initialSelectedPoolGuids;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AddTalentPoolArgs &&
        other.candidateGuid == candidateGuid &&
        _setEquals(other.initialSelectedPoolGuids, initialSelectedPoolGuids);
  }

  @override
  int get hashCode => Object.hash(candidateGuid, Object.hashAllUnordered(initialSelectedPoolGuids));

  static bool _setEquals(Set<String> a, Set<String> b) {
    if (a.length != b.length) return false;
    for (final value in a) {
      if (!b.contains(value)) return false;
    }
    return true;
  }
}

String normalizeTalentPoolGuid(String poolGuid) => poolGuid.trim().toUpperCase();
