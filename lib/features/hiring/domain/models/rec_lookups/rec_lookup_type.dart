abstract final class RecLookupTypeCodes {
  RecLookupTypeCodes._();

  static const String workMode = 'WORK_MODE';
  static const String priority = 'PRIORITY';
  static const String location = 'LOCATION';
  static const String positionType = 'POSITION_TYPE';
  static const String travelReq = 'TRAVEL_REQ';
  static const String reqCert = 'REQ_CERT';
  static const String physicalReq = 'PHYSICAL_REQ';
  static const String skills = 'SKILLS';
  static const String minEduLevel = 'MIN_EDU_LEVEL';
  static const String expYear = 'EXP_YEAR';
  static const String prefField = 'PREF_FIELD';
  static const String managExp = 'MANAG_EXP';
  static const String currency = 'CURRENCY';
  static const String source = 'JOB_SOURCE';
  static const String compType = 'COMP_TYPE';
  static const String interviewType = 'INTERVIEW_TYPE';
  static const String assessmentType = 'ASSESSMENT_TYPE';
  static const String difficulty = 'DIFFICULTY';
  static const String platform = 'PLATFORM';
  static const String assessmentStatus = 'ASSESSMENT_STATUS';
}

class RecLookupType {
  const RecLookupType({
    required this.lookupTypeGuid,
    required this.lookupTypeId,
    required this.typeCode,
    required this.typeName,
    required this.isActive,
  });

  final String lookupTypeGuid;
  final int lookupTypeId;
  final String typeCode;
  final String typeName;
  final String isActive;
}
