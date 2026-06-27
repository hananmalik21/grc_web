import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';

import '../../domain/models/employee_details.dart';
import '../../domain/models/system_user.dart';
import '../../domain/models/user_detail_data.dart';
import '../../domain/models/users_paginated_result.dart';

abstract class UserManagementRemoteDataSource {
  Future<UsersPaginatedResult> getUsers({required int enterpriseId, int page = 1, int limit = 10, String? searchQuery});

  Future<EmployeeDetails> getEmployeeDetails({required String employeeGuid, int? enterpriseId});

  Future<UserDetailData> getUserDetail({required String userGuid});

  Future<void> createUser({required Map<String, dynamic> body});

  Future<void> updateUser({required Map<String, dynamic> body});

  Future<void> deleteUser({required String userGuid});
}

class UserManagementRemoteDataSourceImpl implements UserManagementRemoteDataSource {
  const UserManagementRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<UsersPaginatedResult> getUsers({
    required int enterpriseId,
    int page = 1,
    int limit = 10,
    String? searchQuery,
  }) async {
    try {
      final query = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        query['search'] = searchQuery.trim();
      }

      final response = await _client.get(ApiEndpoints.securityUsers, queryParameters: query);
      final data = response['data'] as List<dynamic>? ?? [];
      final users = data.whereType<Map<String, dynamic>>().map(_mapSecurityUserFromJson).toList();

      final meta = response['meta'] as Map<String, dynamic>? ?? {};
      final pagination = meta['pagination'] as Map<String, dynamic>? ?? {};

      return UsersPaginatedResult(
        users: users,
        total: (pagination['total'] as num?)?.toInt() ?? users.length,
        totalPages: (pagination['total_pages'] as num?)?.toInt() ?? 1,
        hasNext: pagination['has_next'] as bool? ?? false,
        hasPrevious: pagination['has_previous'] as bool? ?? false,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch users: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<EmployeeDetails> getEmployeeDetails({required String employeeGuid, int? enterpriseId}) async {
    try {
      final response = await _client.get(
        ApiEndpoints.employeeFullDetails(employeeGuid),
        queryParameters: enterpriseId == null ? null : {'enterprise_id': enterpriseId.toString()},
      );
      final data = response['data'] as Map<String, dynamic>? ?? {};
      final employee = data['employee'] as Map<String, dynamic>? ?? {};
      final assignment = data['assignment'] as Map<String, dynamic>? ?? {};

      final id = (employee['employee_id'] as num?)?.toInt() ?? 0;
      final firstName = (employee['first_name_en'] ?? employee['first_name']) as String? ?? '';
      final middleName = (employee['middle_name_en'] ?? employee['middle_name']) as String?;
      final lastName = (employee['last_name_en'] ?? employee['last_name']) as String? ?? '';
      final fullName = [
        firstName,
        middleName,
        lastName,
      ].where((part) => part != null && part.trim().isNotEmpty).join(' ').trim();

      final position = assignment['position'] as Map<String, dynamic>?;
      final workLocationObj = assignment['workLocationObj'] as Map<String, dynamic>?;
      final workLocationId = (assignment['work_location_id'] as num?)?.toInt();
      final statusValue = (employee['employee_is_active'] ?? employee['is_active']) as String?;
      final isActive = (statusValue ?? '').toUpperCase() == 'Y';
      final reportsToEmployeeId = (assignment['reporting_to_emp_id'] as num?)?.toInt();

      return EmployeeDetails(
        id: id,
        name: fullName,
        email: employee['email'] as String? ?? '',
        employeeNumber: assignment['employee_number'] as String? ?? '',
        department: _extractDepartmentNameFromOrgList(assignment['org_structure_list']),
        designation: (position?['position_title_en'] as String?) ?? (assignment['position_title_en'] as String?) ?? '',
        status: isActive ? SystemUserStatus.active : SystemUserStatus.locked,
        secondaryEmail: employee['secondary_email'] as String?,
        workPhone: employee['phone_number'] as String?,
        mobilePhone: employee['mobile_number'] as String?,
        extension: assignment['extension'] as String?,
        officeLocation: assignment['office_location'] as String?,
        mailingAddress: assignment['mailing_address'] as String?,
        employeeType: assignment['contract_type_code'] as String?,
        reportToManager: assignment['reporting_to_emp_id']?.toString(),
        workLocationId: workLocationId,
        workLocation: (workLocationObj?['meaning_en'] as String?) ?? assignment['work_location'] as String?,
        hireDate: _parseDate(assignment['enterprise_hire_date']),
        startDate: _parseDate(assignment['effective_start_date']),
        endDate: _parseDate(assignment['effective_end_date']),
        departmentId: _extractDepartmentIdFromOrgList(assignment['org_structure_list']),
        jobTitleId: position?['position_id']?.toString(),
        reportsToEmployeeId: reportsToEmployeeId,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch employee details: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<UserDetailData> getUserDetail({required String userGuid}) async {
    try {
      final response = await _client.get(ApiEndpoints.securityUserByGuid(userGuid));
      final data = response['data'] as Map<String, dynamic>? ?? {};
      return _mapUserDetailFromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch user detail: ${e.toString()}', originalError: e);
    }
  }

  UserDetailData _mapUserDetailFromJson(Map<String, dynamic> data) {
    final userInfo = data['user_info'] as Map<String, dynamic>? ?? {};
    final contactInfo = data['contact_info'] as Map<String, dynamic>? ?? {};
    final employee = data['employee'] as Map<String, dynamic>? ?? {};
    final department = data['department'] as Map<String, dynamic>? ?? {};
    final position = data['position'] as Map<String, dynamic>? ?? {};
    final reportingManager = data['reporting_manager'] as Map<String, dynamic>? ?? {};
    final workLocation = data['work_location'] as Map<String, dynamic>? ?? {};
    final employment = data['employment'] as Map<String, dynamic>? ?? {};
    final rawRoles = data['roles'] as List<dynamic>? ?? [];
    final rawPermissionKeys = data['permission_keys'] as List<dynamic>? ?? [];
    final preferences = data['preferences'] as Map<String, dynamic>? ?? {};
    final security = data['security'] as Map<String, dynamic>? ?? {};

    final permissionKeys = rawPermissionKeys
        .map((pk) {
          if (pk is String) return pk.trim();
          if (pk is Map<String, dynamic>) {
            return (pk['permission_key'] as String? ?? '').trim();
          }
          return '';
        })
        .where((key) => key.isNotEmpty)
        .toSet()
        .toList();

    final roleNames = rawRoles
        .whereType<Map<String, dynamic>>()
        .map((r) => r['role_name'] as String? ?? '')
        .where((name) => name.trim().isNotEmpty)
        .toList();

    final assignedRoleIds = rawRoles
        .whereType<Map<String, dynamic>>()
        .map((r) => (r['role_id'] as num?)?.toInt())
        .whereType<int>()
        .toList();

    return UserDetailData(
      userGuid: data['user_guid'] as String? ?? '',
      userCode: userInfo['user_code'] as String?,
      username: userInfo['username'] as String? ?? '',
      fullName: userInfo['full_name'] as String? ?? '',
      firstName: userInfo['first_name'] as String?,
      lastName: userInfo['last_name'] as String?,
      primaryEmail: userInfo['primary_email'] as String? ?? '',
      secondaryEmail: userInfo['secondary_email'] as String?,
      accountStatus: userInfo['account_status'] as String? ?? '',
      isActiveFlagY: (userInfo['active_flag'] as String? ?? 'N').toUpperCase() == 'Y',
      isLocked: (userInfo['locked_flag'] as String? ?? 'N').toUpperCase() == 'Y',
      lockedDate: _parseDate(userInfo['locked_date']),
      failedLoginAttempts: (userInfo['failed_login_attempts'] as num?)?.toInt() ?? 0,
      passwordExpirationDate: _parseDate(userInfo['password_expiration_date']),
      accountExpirationDate: _parseDate(userInfo['account_expiration_date']),
      workPhone: contactInfo['work_phone'] as String?,
      mobilePhone: contactInfo['mobile_phone'] as String?,
      phoneExtension: contactInfo['phone_extension'] as String?,
      mailingAddress: contactInfo['mailing_address'] as String?,
      employeeNumber: employee['employee_number'] as String?,
      employeeId: (employee['employee_id'] as num?)?.toInt(),
      employeeFullName: employee['full_name'] as String?,
      departmentName: department['name'] as String?,
      departmentId: department['id']?.toString() ?? department['department_id']?.toString(),
      positionTitle: position['title'] as String?,
      jobTitleId: position['id']?.toString() ?? position['job_title_id']?.toString(),
      reportingManagerName: reportingManager['name'] as String?,
      reportsToEmployeeId: (reportingManager['employee_id'] as num?)?.toInt(),
      workLocationName: workLocation['location_name_en'] as String?,
      workLocationId: (workLocation['id'] as num?)?.toInt() ?? (workLocation['location_id'] as num?)?.toInt(),
      employeeType: employment['employee_type'] as String?,
      hireDate: _parseDate(employment['hire_date']),
      startDate: _parseDate(employment['start_date']),
      endDate: _parseDate(employment['end_date']),
      assignedRoleIds: assignedRoleIds,
      roleNames: roleNames,
      mfaRequired: (security['mfa_required_flag'] as String? ?? 'N').toUpperCase() == 'Y',
      forcePasswordChange: (security['force_password_change_flag'] as String? ?? 'N').toUpperCase() == 'Y',
      accountLockout: (security['account_lockout_flag'] as String? ?? 'N').toUpperCase() == 'Y',
      failedAttemptsBeforeLockout: (security['failed_attempts_before_lockout'] as num?)?.toInt() ?? 5,
      sessionTimeoutMinutes: (security['session_timeout_minutes'] as num?)?.toInt() ?? 30,
      concurrentSessions: (security['concurrent_sessions_flag'] as String? ?? 'N').toUpperCase() == 'Y',
      ipRestrictionFlag: (security['ip_restriction_flag'] as String? ?? 'N').toUpperCase() == 'Y',
      auditUserActionsFlag: (security['audit_user_actions_flag'] as String? ?? 'N').toUpperCase() == 'Y',
      dataAccessLoggingFlag: (security['data_access_logging_flag'] as String? ?? 'N').toUpperCase() == 'Y',
      complianceAlertsFlag: (security['compliance_alerts_flag'] as String? ?? 'N').toUpperCase() == 'Y',
      permissionKeys: permissionKeys,
      preferredLanguage: preferences['preferred_language'] as String?,
      timeZone: preferences['time_zone'] as String?,
      dateFormat: preferences['date_format'] as String?,
      currencyCode: preferences['currency_code'] as String?,
      workflowAlertsFlag: (preferences['workflow_alerts_flag'] as String? ?? 'N').toUpperCase() == 'Y',
      itemsPerPage: (preferences['items_per_page'] as num?)?.toInt() ?? 10,
      compactViewFlag: (preferences['compact_view_flag'] as String? ?? 'N').toUpperCase() == 'Y',
      showTooltipsFlag: (preferences['show_tooltips_flag'] as String? ?? 'N').toUpperCase() == 'Y',
      emailNotificationsFlag: (preferences['email_notifications_flag'] as String? ?? 'N').toUpperCase() == 'Y',
      smsNotificationsFlag: (preferences['sms_notifications_flag'] as String? ?? 'N').toUpperCase() == 'Y',
      inappNotificationsFlag: (preferences['inapp_notifications_flag'] as String? ?? 'N').toUpperCase() == 'Y',
    );
  }

  @override
  Future<void> createUser({required Map<String, dynamic> body}) async {
    try {
      await _client.post(ApiEndpoints.securityCreateUser, body: body);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create user: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> updateUser({required Map<String, dynamic> body}) async {
    try {
      await _client.put(ApiEndpoints.securityUpdateUser, body: body);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update user: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteUser({required String userGuid}) async {
    try {
      await _client.delete(ApiEndpoints.securityUserByGuid(userGuid), body: const {'deleted_by': 'SYSTEM'});
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete user: ${e.toString()}', originalError: e);
    }
  }

  SystemUser _mapSecurityUserFromJson(Map<String, dynamic> json) {
    final firstName = json['first_name'] as String? ?? '';
    final lastName = json['last_name'] as String? ?? '';
    final name = [firstName, lastName].where((p) => p.trim().isNotEmpty).join(' ').trim();

    final accountStatus = json['account_status'] as String? ?? '';
    final status = accountStatus.toUpperCase() == 'ACTIVE' ? SystemUserStatus.active : SystemUserStatus.locked;

    final rawRoles = json['roles'] as List<dynamic>? ?? [];
    final userRoles = rawRoles.whereType<Map<String, dynamic>>().map((r) {
      return AssignedRole(
        roleId: (r['role_id'] as num?)?.toInt() ?? 0,
        roleCode: r['role_code'] as String? ?? '',
        roleName: r['role_name'] as String? ?? '',
        jobTitle: r['job_title'] as String? ?? '',
      );
    }).toList();

    return SystemUser(
      id: (json['user_id'] as num?)?.toInt() ?? 0,
      userGuid: json['user_guid'] as String? ?? '',
      username: json['username'] as String? ?? '',
      name: name,
      email: json['primary_email'] as String? ?? '',
      employeeNumber: json['employee_number'] as String? ?? '',
      department: _extractDepartmentNameFromOrgList(json['org_structure_list']),
      designation: userRoles.isNotEmpty ? userRoles.first.jobTitle : '',
      roles: userRoles.map((r) => r.roleName).toList(),
      status: status,
      is2FAEnabled: false,
      employeeId: (json['employee_id'] as num?)?.toInt(),
      employeeGuid: json['employee_guid'] as String?,
    );
  }

  String _extractDepartmentNameFromOrgList(dynamic orgList) {
    if (orgList is List) {
      for (final item in orgList) {
        if (item is Map<String, dynamic>) {
          final levelCode = (item['level_code'] as String?) ?? '';
          if (levelCode.toUpperCase() == 'DEPARTMENT') {
            return item['org_unit_name_en'] as String? ?? '';
          }
        }
      }
    }
    return '';
  }

  String? _extractDepartmentIdFromOrgList(dynamic orgList) {
    if (orgList is List) {
      for (final item in orgList) {
        if (item is Map<String, dynamic>) {
          final levelCode = (item['level_code'] as String?) ?? '';
          if (levelCode.toUpperCase() == 'DEPARTMENT') {
            return item['org_unit_id'] as String?;
          }
        }
      }
    }
    return null;
  }

  DateTime? _parseDate(dynamic value) {
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
