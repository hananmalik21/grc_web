import 'package:grc/features/security_manager/domain/models/data_role.dart';
import 'package:grc/features/security_manager/domain/models/security_lookup_value.dart';

class DataRoleItem {
  const DataRoleItem({
    required this.id,
    required this.dataRoleGuid,
    required this.name,
    required this.code,
    required this.description,
    required this.dataType,
    required this.iconPath,
    this.inheritedDataRoleGuids = const [],
    this.isActive = true,
    this.createdBy,
    this.creationDate,
    this.orgUnits = const [],
    this.positions = const [],
    this.positionIds = const [],
    this.grades = const [],
    this.gradeIds = const [],
    this.jobFamilies = const [],
    this.jobFamilyIds = const [],
    this.jobLevels = const [],
    this.jobLevelIds = const [],
    this.orgUnitIds = const [],
  });

  final String id;
  final String dataRoleGuid;
  final String name;
  final String code;
  final String description;
  final String dataType;
  final String iconPath;
  final List<String> inheritedDataRoleGuids;
  final bool isActive;
  final String? createdBy;
  final DateTime? creationDate;
  final List<String> orgUnits;
  final List<String> positions;
  final List<String> positionIds;
  final List<String> grades;
  final List<int> gradeIds;
  final List<String> jobFamilies;
  final List<int> jobFamilyIds;
  final List<String> jobLevels;
  final List<int> jobLevelIds;
  final List<String> orgUnitIds;

  factory DataRoleItem.fromDataRole(DataRole role) {
    return DataRoleItem(
      id: role.dataRoleId.toString(),
      dataRoleGuid: role.dataRoleGuid,
      name: role.roleName,
      code: role.roleCode,
      description: role.description ?? '',
      dataType: role.dataTypeCode,
      iconPath: '',
      inheritedDataRoleGuids: role.inheritedDataRoleGuids,
      isActive: role.isActive,
      createdBy: role.createdBy,
      creationDate: role.creationDate,
      orgUnits: role.orgUnits,
      positions: role.positions,
      positionIds: role.positionIds,
      grades: role.grades,
      gradeIds: role.gradeIds,
      jobFamilies: role.jobFamilies,
      jobFamilyIds: role.jobFamilyIds,
      jobLevels: role.jobLevels,
      jobLevelIds: role.jobLevelIds,
      orgUnitIds: role.orgUnitIds,
    );
  }

  DataRoleItem copyWith({
    String? id,
    String? dataRoleGuid,
    String? name,
    String? code,
    String? description,
    String? dataType,
    String? iconPath,
    List<String>? inheritedDataRoleGuids,
    bool? isActive,
    String? createdBy,
    DateTime? creationDate,
    List<String>? orgUnits,
    List<String>? positions,
    List<String>? positionIds,
    List<String>? grades,
    List<int>? gradeIds,
    List<String>? jobFamilies,
    List<int>? jobFamilyIds,
    List<String>? jobLevels,
    List<int>? jobLevelIds,
    List<String>? orgUnitIds,
  }) {
    return DataRoleItem(
      id: id ?? this.id,
      dataRoleGuid: dataRoleGuid ?? this.dataRoleGuid,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      dataType: dataType ?? this.dataType,
      iconPath: iconPath ?? this.iconPath,
      inheritedDataRoleGuids: inheritedDataRoleGuids ?? this.inheritedDataRoleGuids,
      isActive: isActive ?? this.isActive,
      createdBy: createdBy ?? this.createdBy,
      creationDate: creationDate ?? this.creationDate,
      orgUnits: orgUnits ?? this.orgUnits,
      positions: positions ?? this.positions,
      positionIds: positionIds ?? this.positionIds,
      grades: grades ?? this.grades,
      gradeIds: gradeIds ?? this.gradeIds,
      jobFamilies: jobFamilies ?? this.jobFamilies,
      jobFamilyIds: jobFamilyIds ?? this.jobFamilyIds,
      jobLevels: jobLevels ?? this.jobLevels,
      jobLevelIds: jobLevelIds ?? this.jobLevelIds,
      orgUnitIds: orgUnitIds ?? this.orgUnitIds,
    );
  }
}

class DataRolesState {
  static const int maxPageSize = 10;

  const DataRolesState({
    this.searchQuery = '',
    this.selectedDataTypeCode = '',
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
    this.deletingDataRoleGuid,
  });

  final String searchQuery;
  final String selectedDataTypeCode;
  final int currentPage;
  final int pageSize;

  /// Server-reported totals.
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  /// Current page's roles from the API.
  final List<DataRoleItem> roles;
  final bool isLoading;
  final bool isCreating;
  final String? error;
  final String? deletingDataRoleGuid;

  int get effectivePageSize => pageSize.clamp(1, maxPageSize).toInt();

  int get safeCurrentPage {
    final safeTotalPages = totalPages < 1 ? 1 : totalPages;
    return currentPage.clamp(1, safeTotalPages);
  }

  List<String> scopeOptionsForDataType(String? dataTypeCode) {
    if (dataTypeCode == null || dataTypeCode.isEmpty) return const [];
    return roles
        .where((r) => r.dataType == dataTypeCode)
        .expand((r) => [...r.orgUnits, ...r.positions, ...r.grades, ...r.jobFamilies, ...r.jobLevels])
        .toSet()
        .toList()
      ..sort();
  }

  DataRolesState copyWith({
    String? searchQuery,
    String? selectedDataTypeCode,
    int? currentPage,
    int? pageSize,
    int? totalItems,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
    List<DataRoleItem>? roles,
    bool? isLoading,
    bool? isCreating,
    String? error,
    bool clearError = false,
    String? deletingDataRoleGuid,
    bool clearDeletingDataRoleGuid = false,
  }) {
    return DataRolesState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDataTypeCode: selectedDataTypeCode ?? this.selectedDataTypeCode,
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
      deletingDataRoleGuid: clearDeletingDataRoleGuid ? null : (deletingDataRoleGuid ?? this.deletingDataRoleGuid),
    );
  }

  SecurityLookupValue? selectedDataTypeLookup(List<SecurityLookupValue> lookups) {
    if (selectedDataTypeCode.isEmpty) return null;
    return lookups.where((l) => l.valueCode == selectedDataTypeCode).firstOrNull;
  }
}
