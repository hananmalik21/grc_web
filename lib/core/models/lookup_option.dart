class LookupOption {
  const LookupOption({
    required this.lookupCode,
    required this.lookupGuid,
    required this.meaningEn,
    required this.meaningAr,
  });

  final String lookupCode;
  final String lookupGuid;
  final String meaningEn;
  final String meaningAr;

  String labelForLocale({required bool isRtl}) => isRtl ? meaningAr : meaningEn;
}
