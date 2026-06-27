import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/features/employee_management/data/dto/employee_full_details_dto.dart';
import 'package:grc/features/employee_management/data/dto/employees_response_dto.dart';
import 'package:grc/features/employee_management/domain/models/create_employee_basic_info_request.dart';
import 'package:grc/features/employee_management/domain/models/update_employee_basic_info_request.dart';
import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/leave_management/domain/models/document.dart';

abstract class ManageEmployeesRemoteDataSource {
  Future<EmployeesResponseDto> getEmployees({
    required int enterpriseId,
    int page = 1,
    int pageSize = 10,
    String? search,
    String? assignmentStatus,
    String? positionId,
    int? jobFamilyId,
    int? jobLevelId,
    int? gradeId,
    String? orgUnitId,
    String? levelCode,
  });

  Future<EmployeeFullDetails?> getEmployeeFullDetails(String employeeGuid, {required int enterpriseId});

  Future<Map<String, dynamic>> createEmployee(
    CreateEmployeeBasicInfoRequest request, {
    Document? document,
    String? documentTypeCode,
  });

  Future<Map<String, dynamic>> updateEmployee(
    String employeeGuid,
    UpdateEmployeeBasicInfoRequest request, {
    Document? document,
    String? documentTypeCode,
    String? docAction,
    int? replaceDocumentId,
  });
}

class ManageEmployeesRemoteDataSourceImpl implements ManageEmployeesRemoteDataSource {
  ManageEmployeesRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<EmployeesResponseDto> getEmployees({
    required int enterpriseId,
    int page = 1,
    int pageSize = 10,
    String? search,
    String? assignmentStatus,
    String? positionId,
    int? jobFamilyId,
    int? jobLevelId,
    int? gradeId,
    String? orgUnitId,
    String? levelCode,
  }) async {
    final queryParameters = <String, String>{
      'enterpriseId': enterpriseId.toString(),
      'page': page.toString(),
      'page_size': pageSize.toString(),
    };
    if (search != null && search.trim().isNotEmpty) {
      queryParameters['search'] = search.trim();
    }
    if (assignmentStatus != null && assignmentStatus.trim().isNotEmpty) {
      queryParameters['employee_status'] = assignmentStatus.trim();
    }
    if (positionId != null && positionId.isNotEmpty) queryParameters['position_id'] = positionId;
    if (jobFamilyId != null) queryParameters['job_family_id'] = jobFamilyId.toString();
    if (jobLevelId != null) queryParameters['job_level_id'] = jobLevelId.toString();
    if (gradeId != null) queryParameters['grade_id'] = gradeId.toString();
    if (orgUnitId != null && orgUnitId.isNotEmpty) queryParameters['org_unit_id'] = orgUnitId;
    if (levelCode != null && levelCode.isNotEmpty) queryParameters['level_code'] = levelCode;
    final response = await apiClient.get(ApiEndpoints.employees, queryParameters: queryParameters);
    return EmployeesResponseDto.fromJson(response);
  }

  @override
  Future<EmployeeFullDetails?> getEmployeeFullDetails(String employeeGuid, {required int enterpriseId}) async {
    final headers = {'x-enterprise-id': enterpriseId.toString()};
    final response = await apiClient.get(ApiEndpoints.employeeFullDetails(employeeGuid), headers: headers);
    return EmployeeFullDetailsResponseDto.fromJson(response).toDomain();
  }

  @override
  Future<Map<String, dynamic>> createEmployee(
    CreateEmployeeBasicInfoRequest request, {
    Document? document,
    String? documentTypeCode,
  }) async {
    final map = <String, dynamic>{
      'first_name_en': request.firstNameEn?.trim() ?? '',
      'last_name_en': request.lastNameEn?.trim() ?? '',
      'middle_name_en': request.middleNameEn?.trim() ?? '',
      'first_name_ar': request.firstNameAr?.trim().isNotEmpty == true ? request.firstNameAr!.trim() : '',
      'last_name_ar': request.lastNameAr?.trim().isNotEmpty == true ? request.lastNameAr!.trim() : '',
      'middle_name_ar': request.middleNameAr?.trim().isNotEmpty == true ? request.middleNameAr!.trim() : '',
      'fourth_name_en': request.fourthNameEn?.trim() ?? '',
      'fourth_name_ar': request.fourthNameAr?.trim().isNotEmpty == true ? request.fourthNameAr!.trim() : '',
      'email': request.email?.trim() ?? '',
      'phone_number': request.fullPhoneNumber?.trim() ?? '',
      if (request.fullMobileNumber != null && request.fullMobileNumber!.trim().isNotEmpty)
        'mobile_number': request.fullMobileNumber!.trim(),
      'date_of_birth': request.dateOfBirth != null
          ? CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.dateOfBirth!)
          : '',
      'emerg_address': request.emergAddress?.trim() ?? '',
      'emerg_phone': request.emergPhone?.trim() ?? '',
      'emerg_email': request.emergEmail?.trim() ?? '',
      'relationship': request.emergRelationship?.trim() ?? '',
      'contact_name': request.contactName?.trim() ?? '',
      if (request.workScheduleId != null) 'work_schedule_id': request.workScheduleId!,
      if (request.wsStart != null) 'ws_start': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.wsStart!),
      if (request.wsEnd != null) 'ws_end': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.wsEnd!),
      if (request.enterpriseId != null) 'enterprise_id': request.enterpriseId!,
      if (request.orgUnitIdHex != null && request.orgUnitIdHex!.isNotEmpty)
        'org_unit_id_hex': request.orgUnitIdHex!.trim(),
      if (request.asgStart != null) 'asg_start': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.asgStart!),
      if (request.asgEnd != null) 'asg_end': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.asgEnd!),
      'actor': 'admin',
      'address_line1': request.addressLine1?.trim() ?? '',
      'address_line2': request.addressLine2?.trim() ?? '',
      'city': request.city?.trim() ?? '',
      'area': request.area?.trim() ?? '',
      'country_code': request.countryCode?.trim() ?? '',
      'civil_id_number': request.civilIdNumber?.trim() ?? '',
      'passport_number': request.passportNumber?.trim() ?? '',
      if (request.positionIdHex != null && request.positionIdHex!.isNotEmpty)
        'position_id_hex': request.positionIdHex!.trim(),
      if (request.enterpriseHireDate != null)
        'enterprise_hire_date': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.enterpriseHireDate!),
      if (request.jobFamilyId != null) 'job_family_id': request.jobFamilyId!,
      if (request.jobLevelId != null) 'job_level_id': request.jobLevelId!,
      if (request.gradeId != null) 'grade_id': request.gradeId!,
      if (request.probationDays != null) 'probation_days': request.probationDays!,
      if (request.contractTypeCode != null && request.contractTypeCode!.isNotEmpty)
        'contract_type_code': request.contractTypeCode!.trim(),
      if (request.employmentStatusCode != null && request.employmentStatusCode!.isNotEmpty)
        'employment_status': request.employmentStatusCode!.trim(),
      if (request.employeeStatus != null && request.employeeStatus!.trim().isNotEmpty)
        'employee_status': request.employeeStatus!.trim(),
      if (request.reportingToEmpId != null) 'reporting_to_emp_id': request.reportingToEmpId!,
      'work_location_id': request.workLocationId?.toString() ?? request.workLocation?.trim() ?? '',
      if (request.compensationComponents != null && request.compensationComponents!.isNotEmpty)
        'compensation_components': request.compensationComponents!.map((c) => c.toJson()).toList(),
      if (request.bankName != null && request.bankName!.trim().isNotEmpty) 'bank_name': request.bankName!.trim(),
      if (request.bankCode != null && request.bankCode!.trim().isNotEmpty) 'bank_code': request.bankCode!.trim(),
      if (request.accountNumber != null && request.accountNumber!.trim().isNotEmpty)
        'account_number': request.accountNumber!.trim(),
      if (request.iban != null && request.iban!.trim().isNotEmpty) 'iban': request.iban!.trim(),
      if (request.civilIdExpiry != null)
        'civil_id_expiry': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.civilIdExpiry!),
      if (request.passportExpiry != null)
        'passport_expiry': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.passportExpiry!),
      if (request.visaNumber != null && request.visaNumber!.trim().isNotEmpty)
        'visa_number': request.visaNumber!.trim(),
      if (request.visaExpiry != null)
        'visa_expiry': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.visaExpiry!),
      if (request.workPermitNumber != null && request.workPermitNumber!.trim().isNotEmpty)
        'work_permit_number': request.workPermitNumber!.trim(),
      if (request.workPermitExpiry != null)
        'work_permit_expiry': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.workPermitExpiry!),
      ..._lookupCodesToFormFields(request.lookupCodesByTypeCode),
    };
    if (document != null && documentTypeCode != null && documentTypeCode.trim().isNotEmpty) {
      map['doc_action'] = 'ADD';
      map['document_type_code'] = documentTypeCode.trim();
    }
    final formData = FormData.fromMap(map);
    if (document != null && documentTypeCode != null && documentTypeCode.trim().isNotEmpty) {
      if (document.bytes != null) {
        formData.files.add(MapEntry('document', MultipartFile.fromBytes(document.bytes!, filename: document.name)));
      } else if (!kIsWeb && document.path.trim().isNotEmpty) {
        try {
          final multipartFile = await MultipartFile.fromFile(document.path, filename: document.name);
          formData.files.add(MapEntry('document', multipartFile));
        } catch (_) {}
      }
    }
    return apiClient.postMultipart(ApiEndpoints.createEmployee, formData: formData);
  }

  @override
  Future<Map<String, dynamic>> updateEmployee(
    String employeeGuid,
    UpdateEmployeeBasicInfoRequest request, {
    Document? document,
    String? documentTypeCode,
    String? docAction,
    int? replaceDocumentId,
  }) async {
    final map = <String, dynamic>{
      'first_name_en': request.firstNameEn?.trim() ?? '',
      'last_name_en': request.lastNameEn?.trim() ?? '',
      'middle_name_en': request.middleNameEn?.trim() ?? '',
      'first_name_ar': request.firstNameAr?.trim().isNotEmpty == true ? request.firstNameAr!.trim() : '',
      'last_name_ar': request.lastNameAr?.trim().isNotEmpty == true ? request.lastNameAr!.trim() : '',
      'middle_name_ar': request.middleNameAr?.trim().isNotEmpty == true ? request.middleNameAr!.trim() : '',
      'fourth_name_en': request.fourthNameEn?.trim() ?? '',
      'fourth_name_ar': request.fourthNameAr?.trim().isNotEmpty == true ? request.fourthNameAr!.trim() : '',
      'email': request.email?.trim() ?? '',
      'phone_number': request.phoneNumber?.trim() ?? '',
      if (request.mobileNumber != null && request.mobileNumber!.trim().isNotEmpty)
        'mobile_number': request.mobileNumber!.trim(),
      'date_of_birth': request.dateOfBirth != null
          ? UpdateEmployeeBasicInfoRequest.formatDateOfBirth(request.dateOfBirth!)
          : '',
      'emerg_address': request.emergAddress?.trim() ?? '',
      'emerg_phone': request.emergPhone?.trim() ?? '',
      'emerg_email': request.emergEmail?.trim() ?? '',
      'relationship': request.emergRelationship?.trim() ?? '',
      'contact_name': request.contactName?.trim() ?? '',
      if (request.workScheduleId != null) 'work_schedule_id': request.workScheduleId!,
      if (request.wsStart != null) 'ws_start': UpdateEmployeeBasicInfoRequest.formatDateOfBirth(request.wsStart!),
      if (request.wsEnd != null) 'ws_end': UpdateEmployeeBasicInfoRequest.formatDateOfBirth(request.wsEnd!),
      if (request.enterpriseId != null) 'enterprise_id': request.enterpriseId!,
      if (request.orgUnitIdHex != null && request.orgUnitIdHex!.isNotEmpty)
        'org_unit_id_hex': request.orgUnitIdHex!.trim(),
      if (request.asgStart != null) 'asg_start': UpdateEmployeeBasicInfoRequest.formatDateOfBirth(request.asgStart!),
      if (request.asgEnd != null) 'asg_end': UpdateEmployeeBasicInfoRequest.formatDateOfBirth(request.asgEnd!),
      'actor': 'admin',
      'address_line1': request.addressLine1?.trim() ?? '',
      'address_line2': request.addressLine2?.trim() ?? '',
      'city': request.city?.trim() ?? '',
      'area': request.area?.trim() ?? '',
      'country_code': request.countryCode?.trim() ?? '',
      'civil_id_number': request.civilIdNumber?.trim() ?? '',
      'passport_number': request.passportNumber?.trim() ?? '',
      if (request.positionIdHex != null && request.positionIdHex!.isNotEmpty)
        'position_id_hex': request.positionIdHex!.trim(),
      if (request.enterpriseHireDate != null)
        'enterprise_hire_date': UpdateEmployeeBasicInfoRequest.formatDateOfBirth(request.enterpriseHireDate!),
      if (request.jobFamilyId != null) 'job_family_id': request.jobFamilyId!,
      if (request.jobLevelId != null) 'job_level_id': request.jobLevelId!,
      if (request.gradeId != null) 'grade_id': request.gradeId!,
      if (request.probationDays != null) 'probation_days': request.probationDays!,
      if (request.contractTypeCode != null && request.contractTypeCode!.isNotEmpty)
        'contract_type_code': request.contractTypeCode!.trim(),
      if (request.employmentStatusCode != null && request.employmentStatusCode!.isNotEmpty)
        'employment_status': request.employmentStatusCode!.trim(),
      if (request.employeeStatus != null && request.employeeStatus!.trim().isNotEmpty)
        'employee_status': request.employeeStatus!.trim(),
      if (request.reportingToEmpId != null) 'reporting_to_emp_id': request.reportingToEmpId!,
      'work_location_id': request.workLocationId?.toString() ?? request.workLocation?.trim() ?? '',
      if (request.bankName != null && request.bankName!.trim().isNotEmpty) 'bank_name': request.bankName!.trim(),
      if (request.bankCode != null && request.bankCode!.trim().isNotEmpty) 'bank_code': request.bankCode!.trim(),
      if (request.accountNumber != null && request.accountNumber!.trim().isNotEmpty)
        'account_number': request.accountNumber!.trim(),
      if (request.iban != null && request.iban!.trim().isNotEmpty) 'iban': request.iban!.trim(),
      if (request.civilIdExpiry != null)
        'civil_id_expiry': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.civilIdExpiry!),
      if (request.passportExpiry != null)
        'passport_expiry': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.passportExpiry!),
      if (request.visaNumber != null && request.visaNumber!.trim().isNotEmpty)
        'visa_number': request.visaNumber!.trim(),
      if (request.visaExpiry != null)
        'visa_expiry': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.visaExpiry!),
      if (request.workPermitNumber != null && request.workPermitNumber!.trim().isNotEmpty)
        'work_permit_number': request.workPermitNumber!.trim(),
      if (request.workPermitExpiry != null)
        'work_permit_expiry': CreateEmployeeBasicInfoRequest.formatDateOfBirth(request.workPermitExpiry!),
      ...ManageEmployeesRemoteDataSourceImpl._lookupCodesToFormFields(request.lookupCodesByTypeCode),
    };
    if (document != null &&
        documentTypeCode != null &&
        documentTypeCode.trim().isNotEmpty &&
        docAction != null &&
        docAction.trim().isNotEmpty) {
      map['doc_action'] = docAction.trim();
      map['document_type_code'] = documentTypeCode.trim();
      if (replaceDocumentId != null && docAction.trim().toUpperCase() == 'REPLACE') {
        map['replace_document_id'] = replaceDocumentId;
      }
    }
    final formData = FormData.fromMap(map);
    if (document != null && documentTypeCode != null && documentTypeCode.trim().isNotEmpty) {
      if (document.bytes != null) {
        formData.files.add(MapEntry('document', MultipartFile.fromBytes(document.bytes!, filename: document.name)));
      } else if (!kIsWeb && document.path.trim().isNotEmpty) {
        try {
          final multipartFile = await MultipartFile.fromFile(document.path, filename: document.name);
          formData.files.add(MapEntry('document', multipartFile));
        } catch (_) {}
      }
    }
    return apiClient.putMultipart(ApiEndpoints.updateEmployee(employeeGuid), formData: formData);
  }

  static Map<String, dynamic> _lookupCodesToFormFields(Map<String, String?>? lookupCodesByTypeCode) {
    if (lookupCodesByTypeCode == null || lookupCodesByTypeCode.isEmpty) return {};
    final result = <String, dynamic>{};
    for (final entry in lookupCodesByTypeCode.entries) {
      final value = entry.value?.trim();
      if (value != null && value.isNotEmpty) {
        final apiKey = CreateEmployeeBasicInfoRequest.typeCodeToApiKey(entry.key);
        result[apiKey] = value;
      }
    }
    return result;
  }
}
