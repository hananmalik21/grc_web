class PayLookupValue {
  const PayLookupValue({
    required this.lookupValueGuid,
    required this.typeCode,
    required this.valueCode,
    required this.valueName,
    this.displaySequence = 0,
    this.activeFlag = 'Y',
  });

  final String lookupValueGuid;
  final String typeCode;
  final String valueCode;
  final String valueName;
  final int displaySequence;
  final String activeFlag;

  bool get isActive {
    final normalized = activeFlag.trim().toUpperCase();
    return normalized == 'Y' || normalized == 'TRUE';
  }
}
