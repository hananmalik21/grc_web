import 'package:grc/core/utils/form_validators.dart';
import 'package:grc/core/utils/phone_number_utils.dart';
import 'package:grc/features/employee_management/domain/models/create_employee_compensation_component.dart';

class CreateEmployeeBasicInfoRequest {
  final String? firstNameEn;
  final String? lastNameEn;
  final String? middleNameEn;
  final String? fourthNameEn;
  final String? firstNameAr;
  final String? lastNameAr;
  final String? middleNameAr;
  final String? fourthNameAr;
  final String? email;
  final String? phoneNumber;
  final String? phoneDialCode;
  final String? mobileNumber;
  final String? mobileDialCode;
  final DateTime? dateOfBirth;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? area;
  final String? countryCode;
  final String? emergAddress;
  final String? emergPhone;
  final String? emergEmail;
  final String? emergRelationship;
  final String? contactName;
  final int? workScheduleId;
  final DateTime? wsStart;
  final DateTime? wsEnd;
  final String? orgUnitIdHex;
  final DateTime? asgStart;
  final DateTime? asgEnd;
  final Map<String, String?>? lookupCodesByTypeCode;
  final String? civilIdNumber;
  final String? passportNumber;
  final String? workLocation;
  final int? workLocationId;
  final String? positionIdHex;
  final DateTime? enterpriseHireDate;
  final int? jobFamilyId;
  final int? jobLevelId;
  final int? gradeId;
  final int? probationDays;
  final String? contractTypeCode;
  final String? employmentStatusCode;
  final String? employeeStatus;
  final int? reportingToEmpId;
  final int? enterpriseId;
  final List<CreateEmployeeCompensationComponent>? compensationComponents;
  final String? bankName;
  final String? bankCode;
  final String? accountNumber;
  final String? iban;
  final DateTime? civilIdExpiry;
  final DateTime? passportExpiry;
  final String? visaNumber;
  final DateTime? visaExpiry;
  final String? workPermitNumber;
  final DateTime? workPermitExpiry;

  const CreateEmployeeBasicInfoRequest({
    this.firstNameEn,
    this.lastNameEn,
    this.middleNameEn,
    this.fourthNameEn,
    this.firstNameAr,
    this.lastNameAr,
    this.middleNameAr,
    this.fourthNameAr,
    this.email,
    this.phoneNumber,
    this.phoneDialCode = PhoneNumberUtils.defaultDialCode,
    this.mobileNumber,
    this.mobileDialCode = PhoneNumberUtils.defaultDialCode,
    this.dateOfBirth,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.area,
    this.countryCode,
    this.emergAddress,
    this.emergPhone,
    this.emergEmail,
    this.emergRelationship,
    this.contactName,
    this.workScheduleId,
    this.wsStart,
    this.wsEnd,
    this.orgUnitIdHex,
    this.asgStart,
    this.asgEnd,
    this.lookupCodesByTypeCode,
    this.civilIdNumber,
    this.passportNumber,
    this.workLocation,
    this.workLocationId,
    this.positionIdHex,
    this.enterpriseHireDate,
    this.jobFamilyId,
    this.jobLevelId,
    this.gradeId,
    this.probationDays,
    this.contractTypeCode,
    this.employmentStatusCode,
    this.employeeStatus = 'ACTIVE',
    this.reportingToEmpId,
    this.enterpriseId,
    this.compensationComponents,
    this.bankName,
    this.bankCode,
    this.accountNumber,
    this.iban,
    this.civilIdExpiry,
    this.passportExpiry,
    this.visaNumber,
    this.visaExpiry,
    this.workPermitNumber,
    this.workPermitExpiry,
  });

  CreateEmployeeBasicInfoRequest copyWith({
    String? firstNameEn,
    String? lastNameEn,
    String? middleNameEn,
    String? fourthNameEn,
    String? firstNameAr,
    String? lastNameAr,
    String? middleNameAr,
    String? fourthNameAr,
    String? email,
    String? phoneNumber,
    String? phoneDialCode,
    String? mobileNumber,
    String? mobileDialCode,
    DateTime? dateOfBirth,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? area,
    String? countryCode,
    String? emergAddress,
    String? emergPhone,
    String? emergEmail,
    String? emergRelationship,
    String? contactName,
    int? workScheduleId,
    String? orgUnitIdHex,
    bool clearFirstNameEn = false,
    bool clearLastNameEn = false,
    bool clearMiddleNameEn = false,
    bool clearFourthNameEn = false,
    bool clearFirstNameAr = false,
    bool clearLastNameAr = false,
    bool clearMiddleNameAr = false,
    bool clearFourthNameAr = false,
    bool clearEmail = false,
    bool clearPhoneNumber = false,
    bool clearMobileNumber = false,
    bool clearDateOfBirth = false,
    bool clearAddressLine1 = false,
    bool clearAddressLine2 = false,
    bool clearCity = false,
    bool clearArea = false,
    bool clearCountryCode = false,
    bool clearEmergAddress = false,
    bool clearEmergPhone = false,
    bool clearEmergEmail = false,
    bool clearEmergRelationship = false,
    bool clearContactName = false,
    bool clearWorkScheduleId = false,
    DateTime? wsStart,
    DateTime? wsEnd,
    bool clearWsStart = false,
    bool clearWsEnd = false,
    bool clearOrgUnitIdHex = false,
    DateTime? asgStart,
    DateTime? asgEnd,
    bool clearAsgStart = false,
    bool clearAsgEnd = false,
    Map<String, String?>? lookupCodesByTypeCode,
    String? civilIdNumber,
    String? passportNumber,
    bool clearLookupCodesByTypeCode = false,
    bool clearCivilIdNumber = false,
    bool clearPassportNumber = false,
    String? workLocation,
    bool clearWorkLocation = false,
    int? workLocationId,
    bool clearWorkLocationId = false,
    String? positionIdHex,
    DateTime? enterpriseHireDate,
    int? jobFamilyId,
    int? jobLevelId,
    int? gradeId,
    int? probationDays,
    String? contractTypeCode,
    String? employmentStatusCode,
    String? employeeStatus,
    bool clearPositionIdHex = false,
    bool clearEnterpriseHireDate = false,
    bool clearJobFamilyId = false,
    bool clearJobLevelId = false,
    bool clearGradeId = false,
    bool clearProbationDays = false,
    bool clearContractTypeCode = false,
    bool clearEmploymentStatusCode = false,
    bool clearEmployeeStatus = false,
    int? reportingToEmpId,
    bool clearReportingToEmpId = false,
    int? enterpriseId,
    bool clearEnterpriseId = false,
    List<CreateEmployeeCompensationComponent>? compensationComponents,
    bool clearCompensationComponents = false,
    String? bankName,
    String? bankCode,
    String? accountNumber,
    String? iban,
    bool clearBankName = false,
    bool clearBankCode = false,
    bool clearAccountNumber = false,
    bool clearIban = false,
    DateTime? civilIdExpiry,
    DateTime? passportExpiry,
    String? visaNumber,
    DateTime? visaExpiry,
    String? workPermitNumber,
    DateTime? workPermitExpiry,
    bool clearCivilIdExpiry = false,
    bool clearPassportExpiry = false,
    bool clearVisaNumber = false,
    bool clearVisaExpiry = false,
    bool clearWorkPermitNumber = false,
    bool clearWorkPermitExpiry = false,
  }) {
    return CreateEmployeeBasicInfoRequest(
      firstNameEn: clearFirstNameEn ? null : (firstNameEn ?? this.firstNameEn),
      lastNameEn: clearLastNameEn ? null : (lastNameEn ?? this.lastNameEn),
      middleNameEn: clearMiddleNameEn ? null : (middleNameEn ?? this.middleNameEn),
      fourthNameEn: clearFourthNameEn ? null : (fourthNameEn ?? this.fourthNameEn),
      firstNameAr: clearFirstNameAr ? null : (firstNameAr ?? this.firstNameAr),
      lastNameAr: clearLastNameAr ? null : (lastNameAr ?? this.lastNameAr),
      middleNameAr: clearMiddleNameAr ? null : (middleNameAr ?? this.middleNameAr),
      fourthNameAr: clearFourthNameAr ? null : (fourthNameAr ?? this.fourthNameAr),
      email: clearEmail ? null : (email ?? this.email),
      phoneNumber: clearPhoneNumber ? null : (phoneNumber ?? this.phoneNumber),
      phoneDialCode: phoneDialCode ?? this.phoneDialCode,
      mobileNumber: clearMobileNumber ? null : (mobileNumber ?? this.mobileNumber),
      mobileDialCode: mobileDialCode ?? this.mobileDialCode,
      dateOfBirth: clearDateOfBirth ? null : (dateOfBirth ?? this.dateOfBirth),
      addressLine1: clearAddressLine1 ? null : (addressLine1 ?? this.addressLine1),
      addressLine2: clearAddressLine2 ? null : (addressLine2 ?? this.addressLine2),
      city: clearCity ? null : (city ?? this.city),
      area: clearArea ? null : (area ?? this.area),
      countryCode: clearCountryCode ? null : (countryCode ?? this.countryCode),
      emergAddress: clearEmergAddress ? null : (emergAddress ?? this.emergAddress),
      emergPhone: clearEmergPhone ? null : (emergPhone ?? this.emergPhone),
      emergEmail: clearEmergEmail ? null : (emergEmail ?? this.emergEmail),
      emergRelationship: clearEmergRelationship ? null : (emergRelationship ?? this.emergRelationship),
      contactName: clearContactName ? null : (contactName ?? this.contactName),
      workScheduleId: clearWorkScheduleId ? null : (workScheduleId ?? this.workScheduleId),
      wsStart: clearWsStart ? null : (wsStart ?? this.wsStart),
      wsEnd: clearWsEnd ? null : (wsEnd ?? this.wsEnd),
      orgUnitIdHex: clearOrgUnitIdHex ? null : (orgUnitIdHex ?? this.orgUnitIdHex),
      asgStart: clearAsgStart ? null : (asgStart ?? this.asgStart),
      asgEnd: clearAsgEnd ? null : (asgEnd ?? this.asgEnd),
      lookupCodesByTypeCode: clearLookupCodesByTypeCode ? null : (lookupCodesByTypeCode ?? this.lookupCodesByTypeCode),
      civilIdNumber: clearCivilIdNumber ? null : (civilIdNumber ?? this.civilIdNumber),
      passportNumber: clearPassportNumber ? null : (passportNumber ?? this.passportNumber),
      workLocation: clearWorkLocation ? null : (workLocation ?? this.workLocation),
      workLocationId: clearWorkLocationId ? null : (workLocationId ?? this.workLocationId),
      positionIdHex: clearPositionIdHex ? null : (positionIdHex ?? this.positionIdHex),
      enterpriseHireDate: clearEnterpriseHireDate ? null : (enterpriseHireDate ?? this.enterpriseHireDate),
      jobFamilyId: clearJobFamilyId ? null : (jobFamilyId ?? this.jobFamilyId),
      jobLevelId: clearJobLevelId ? null : (jobLevelId ?? this.jobLevelId),
      gradeId: clearGradeId ? null : (gradeId ?? this.gradeId),
      probationDays: clearProbationDays ? null : (probationDays ?? this.probationDays),
      contractTypeCode: clearContractTypeCode ? null : (contractTypeCode ?? this.contractTypeCode),
      employmentStatusCode: clearEmploymentStatusCode ? null : (employmentStatusCode ?? this.employmentStatusCode),
      employeeStatus: clearEmployeeStatus ? null : (employeeStatus ?? this.employeeStatus),
      reportingToEmpId: clearReportingToEmpId ? null : (reportingToEmpId ?? this.reportingToEmpId),
      enterpriseId: clearEnterpriseId ? null : (enterpriseId ?? this.enterpriseId),
      compensationComponents: clearCompensationComponents
          ? null
          : (compensationComponents ?? this.compensationComponents),
      bankName: clearBankName ? null : (bankName ?? this.bankName),
      bankCode: clearBankCode ? null : (bankCode ?? this.bankCode),
      accountNumber: clearAccountNumber ? null : (accountNumber ?? this.accountNumber),
      iban: clearIban ? null : (iban ?? this.iban),
      civilIdExpiry: clearCivilIdExpiry ? null : (civilIdExpiry ?? this.civilIdExpiry),
      passportExpiry: clearPassportExpiry ? null : (passportExpiry ?? this.passportExpiry),
      visaNumber: clearVisaNumber ? null : (visaNumber ?? this.visaNumber),
      visaExpiry: clearVisaExpiry ? null : (visaExpiry ?? this.visaExpiry),
      workPermitNumber: clearWorkPermitNumber ? null : (workPermitNumber ?? this.workPermitNumber),
      workPermitExpiry: clearWorkPermitExpiry ? null : (workPermitExpiry ?? this.workPermitExpiry),
    );
  }

  static String typeCodeToApiKey(String typeCode) {
    switch (typeCode.toUpperCase()) {
      case 'NATIONALITY':
        return 'nationality';
      case 'BANK_NAME_CODE':
      case 'BANK_NAME':
      case 'BANK':
        return 'bank_code';
      default:
        return '${typeCode.toLowerCase()}_code';
    }
  }

  static String formatDateOfBirth(DateTime d) {
    final y = d.year;
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  bool get isEmailValid => FormValidators.email(email) == null;

  String? get fullPhoneNumber => PhoneNumberUtils.combine(phoneDialCode, phoneNumber);

  String? get fullMobileNumber => PhoneNumberUtils.combine(mobileDialCode, mobileNumber);

  bool get isPhoneValid {
    final phone = fullPhoneNumber?.trim() ?? '';
    if (phone.isEmpty) return true;
    return FormValidators.phone(phone) == null;
  }

  bool get isMobileValid {
    final mobile = fullMobileNumber?.trim() ?? '';
    if (mobile.isEmpty) return true;
    return FormValidators.phone(mobile) == null;
  }

  bool get isStep1Valid =>
      (firstNameEn?.trim().isNotEmpty ?? false) &&
      (middleNameEn?.trim().isNotEmpty ?? false) &&
      (lastNameEn?.trim().isNotEmpty ?? false) &&
      (fourthNameEn?.trim().isNotEmpty ?? false) &&
      isEmailValid &&
      isPhoneValid &&
      isMobileValid &&
      dateOfBirth != null &&
      (employeeStatus?.trim().isNotEmpty ?? false);
}
