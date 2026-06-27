enum AbsLookupCode {
  empCategory('EMP_CATEGORY'),
  contractType('CONTRACT_TYPE'),
  empType('EMP_TYPE'),
  gender('GENDER'),
  maritalStatus('MARITAL_STATUS'),
  nationality('NATIONALITY'),
  religion('RELIGION'),
  religionCode('RELIGION_CODE'),
  accrualMethod('ACCURAL_METHOD'),
  shiftTime('SHIFT_TIME');

  const AbsLookupCode(this.code);
  final String code;
}
