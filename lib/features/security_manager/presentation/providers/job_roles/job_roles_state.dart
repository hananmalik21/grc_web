import 'package:grc/core/enums/security_enums.dart';
import 'package:grc/features/security_manager/domain/models/job_role.dart';
import 'package:flutter/material.dart';

class JobRoleItem {
  const JobRoleItem({
    required this.id,
    required this.jobRoleGuid,
    required this.name,
    required this.code,
    required this.description,
    required this.jobTitle,
    required this.dutyRoles,
    required this.dutyRoleCodes,
    required this.functionRoles,
    required this.functionRoleCodes,
    required this.dataRoles,
    required this.dataRoleCodes,
    this.inheritedJobRoleGuids = const [],
    this.isActive = true,
    this.department = '',
    this.usersAssignedLabel = '',
    this.isAutoAssign = false,
    this.requiresApproval = false,
    this.effectiveFrom,
    this.expirationDate,
    this.jobTitleBackgroundColor,
    this.jobTitleTextColor,
    this.jobTitleBorderColor,
    this.lockedDutyRoleCodes = const {},
    this.lockedFunctionRoleCodes = const {},
    this.lockedDataRoleCodes = const {},
  });

  final String id;
  final String jobRoleGuid;
  final String name;
  final String code;
  final String description;
  final String jobTitle;
  final List<String> dutyRoles;
  final List<String> dutyRoleCodes;
  final List<String> functionRoles;
  final List<String> functionRoleCodes;
  final List<String> dataRoles;
  final List<String> dataRoleCodes;
  final List<String> inheritedJobRoleGuids;
  final bool isActive;
  final String department;
  final String usersAssignedLabel;
  final bool isAutoAssign;
  final bool requiresApproval;
  final DateTime? effectiveFrom;
  final DateTime? expirationDate;
  final Color? jobTitleBackgroundColor;
  final Color? jobTitleTextColor;
  final Color? jobTitleBorderColor;

  final Set<String> lockedDutyRoleCodes;
  final Set<String> lockedFunctionRoleCodes;
  final Set<String> lockedDataRoleCodes;

  factory JobRoleItem.fromJobRole(JobRole role) {
    final lockedDuty = {
      for (final d in role.dutyRoles)
        if (d.assignmentType == FunctionAssignmentType.inherited) d.dutyRoleCode,
    };
    final lockedFn = {
      for (final f in role.functionRoles)
        if (f.assignmentType == FunctionAssignmentType.inherited) f.functionRoleCode,
    };
    final lockedData = {
      for (final d in role.dataRoles)
        if (d.assignmentType == FunctionAssignmentType.inherited) d.dataRoleCode,
    };
    return JobRoleItem(
      id: role.jobRoleId.toString(),
      jobRoleGuid: role.jobRoleGuid,
      name: role.roleName,
      code: role.roleCode,
      description: role.description ?? '',
      jobTitle: role.jobTitle,
      dutyRoles: role.dutyRoles.map((d) => d.dutyRoleName).toList(),
      dutyRoleCodes: role.dutyRoles.map((d) => d.dutyRoleCode).toList(),
      functionRoles: role.functionRoles.map((f) => f.functionRoleName).toList(),
      functionRoleCodes: role.functionRoles.map((f) => f.functionRoleCode).toList(),
      dataRoles: role.dataRoles.map((d) => d.dataRoleName).toList(),
      dataRoleCodes: role.dataRoles.map((d) => d.dataRoleCode).toList(),
      inheritedJobRoleGuids: role.inheritedJobRoleGuids,
      isActive: role.isActive,
      lockedDutyRoleCodes: lockedDuty,
      lockedFunctionRoleCodes: lockedFn,
      lockedDataRoleCodes: lockedData,
    );
  }
}

class JobRolesState {
  static const int maxPageSize = 10;

  const JobRolesState({
    this.searchQuery = '',
    this.currentPage = 1,
    this.pageSize = 10,
    this.totalItems = 0,
    this.totalPages = 1,
    this.hasNext = false,
    this.hasPrevious = false,
    this.roles = const [],
    this.isLoading = false,
    this.isCreating = false,
    this.error,
    this.deletingJobRoleGuid,
  });

  final String searchQuery;
  final int currentPage;
  final int pageSize;

  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  final List<JobRoleItem> roles;
  final bool isLoading;
  final bool isCreating;
  final String? error;

  final String? deletingJobRoleGuid;

  int get effectivePageSize => pageSize.clamp(1, maxPageSize).toInt();

  List<JobRoleItem> get filteredRoles => roles;

  JobRolesState copyWith({
    String? searchQuery,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
    List<JobRoleItem>? roles,
    bool? isLoading,
    bool? isCreating,
    String? error,
    bool clearError = false,
    String? deletingJobRoleGuid,
    bool clearDeletingJobRoleGuid = false,
  }) {
    return JobRolesState(
      searchQuery: searchQuery ?? this.searchQuery,
      currentPage: currentPage ?? this.currentPage,
      pageSize: (pageSize ?? this.pageSize).clamp(1, maxPageSize).toInt(),
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      roles: roles ?? this.roles,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      error: clearError ? null : (error ?? this.error),
      deletingJobRoleGuid: clearDeletingJobRoleGuid ? null : (deletingJobRoleGuid ?? this.deletingJobRoleGuid),
    );
  }
}
