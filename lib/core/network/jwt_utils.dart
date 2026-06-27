bool looksLikeJwt(String value) {
  final parts = value.split('.');
  return parts.length == 3 && parts.every((p) => p.isNotEmpty);
}
