import 'package:grc/features/employee_management/domain/models/create_employee_basic_info_request.dart';

class UpdateEmployeeBasicInfoRequest {
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
  final String? mobileNumber;
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

  const UpdateEmployeeBasicInfoRequest({
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
    this.mobileNumber,
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
    this.employeeStatus,
    this.reportingToEmpId,
    this.enterpriseId,
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

  factory UpdateEmployeeBasicInfoRequest.fromCreateRequest(CreateEmployeeBasicInfoRequest request) {
    return UpdateEmployeeBasicInfoRequest(
      firstNameEn: request.firstNameEn,
      lastNameEn: request.lastNameEn,
      middleNameEn: request.middleNameEn,
      fourthNameEn: request.fourthNameEn,
      firstNameAr: request.firstNameAr,
      lastNameAr: request.lastNameAr,
      middleNameAr: request.middleNameAr,
      fourthNameAr: request.fourthNameAr,
      email: request.email,
      phoneNumber: request.fullPhoneNumber,
      mobileNumber: request.fullMobileNumber,
      dateOfBirth: request.dateOfBirth,
      addressLine1: request.addressLine1,
      addressLine2: request.addressLine2,
      city: request.city,
      area: request.area,
      countryCode: request.countryCode,
      emergAddress: request.emergAddress,
      emergPhone: request.emergPhone,
      emergEmail: request.emergEmail,
      emergRelationship: request.emergRelationship,
      contactName: request.contactName,
      workScheduleId: request.workScheduleId,
      wsStart: request.wsStart,
      wsEnd: request.wsEnd,
      orgUnitIdHex: request.orgUnitIdHex,
      asgStart: request.asgStart,
      asgEnd: request.asgEnd,
      lookupCodesByTypeCode: request.lookupCodesByTypeCode,
      civilIdNumber: request.civilIdNumber,
      passportNumber: request.passportNumber,
      workLocation: request.workLocation,
      workLocationId: request.workLocationId,
      positionIdHex: request.positionIdHex,
      enterpriseHireDate: request.enterpriseHireDate,
      jobFamilyId: request.jobFamilyId,
      jobLevelId: request.jobLevelId,
      gradeId: request.gradeId,
      probationDays: request.probationDays,
      contractTypeCode: request.contractTypeCode,
      employmentStatusCode: request.employmentStatusCode,
      employeeStatus: request.employeeStatus,
      reportingToEmpId: request.reportingToEmpId,
      enterpriseId: request.enterpriseId,
      bankName: request.bankName,
      bankCode: request.bankCode,
      accountNumber: request.accountNumber,
      iban: request.iban,
      civilIdExpiry: request.civilIdExpiry,
      passportExpiry: request.passportExpiry,
      visaNumber: request.visaNumber,
      visaExpiry: request.visaExpiry,
      workPermitNumber: request.workPermitNumber,
      workPermitExpiry: request.workPermitExpiry,
    );
  }

  static String formatDateOfBirth(DateTime d) => CreateEmployeeBasicInfoRequest.formatDateOfBirth(d);
}
