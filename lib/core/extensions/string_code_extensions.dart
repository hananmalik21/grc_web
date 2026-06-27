extension StringCodeExtensions on String {
  /// Formats API codes such as `NOT_IMPLEMENTED` to `Not Implemented`.
  String toDisplayLabel({String fallback = '-'}) {
    final normalized = trim();
    if (normalized.isEmpty) return fallback;

    return normalized
        .split('_')
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
