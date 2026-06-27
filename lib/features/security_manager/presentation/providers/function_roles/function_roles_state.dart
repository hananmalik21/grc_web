import 'package:grc/core/enums/active_inactive_status.dart';
import 'package:grc/core/enums/security_enums.dart';
import 'package:grc/features/security_manager/domain/models/function_role.dart';

class FunctionRoleItem {
  const FunctionRoleItem({
    required this.id,
    required this.functionRoleGuid,
    required this.name,
    required this.code,
    required this.description,
    required this.moduleName,
    required this.usersAssignedLabel,
    required this.includedFunctions,
    required this.includedFunctionGuids,
    required this.inheritedFunctionGuids,
    required this.inheritedParentRoleIds,
    this.functionGuidToIdMap = const {},
    this.isActive = true,
  });

  final String id;
  final String functionRoleGuid;
  final String name;
  final String code;
  final String description;
  final String moduleName;
  final String usersAssignedLabel;
  final List<String> includedFunctions;
  final List<String> includedFunctionGuids;
  final List<String> inheritedFunctionGuids;
  final List<int> inheritedParentRoleIds;

  final Map<String, int> functionGuidToIdMap;
  final bool isActive;

  factory FunctionRoleItem.fromFunctionRole(FunctionRole role) {
    final inheritedFunctions = role.functions
        .where((f) => f.assignmentType == FunctionAssignmentType.inherited)
        .toList();
    return FunctionRoleItem(
      id: role.functionRoleId.toString(),
      functionRoleGuid: role.functionRoleGuid,
      name: role.roleName,
      code: role.roleCode,
      description: role.description ?? '',
      moduleName: role.moduleName,
      usersAssignedLabel: '',
      includedFunctions: role.functions.map((f) => f.functionName).toList(),
      includedFunctionGuids: role.functions.map((f) => f.functionGuid).toList(),
      inheritedFunctionGuids: inheritedFunctions.map((f) => f.functionGuid).toList(),
      inheritedParentRoleIds: inheritedFunctions.map((f) => f.sourceParentRoleId).whereType<int>().toSet().toList(),
      functionGuidToIdMap: {for (final f in role.functions) f.functionGuid: f.functionId},
      isActive: role.isActive,
    );
  }

  FunctionRoleItem copyWith({
    String? id,
    String? functionRoleGuid,
    String? name,
    String? code,
    String? description,
    String? moduleName,
    String? usersAssignedLabel,
    List<String>? includedFunctions,
    List<String>? includedFunctionGuids,
    List<String>? inheritedFunctionGuids,
    List<int>? inheritedParentRoleIds,
    Map<String, int>? functionGuidToIdMap,
    bool? isActive,
  }) {
    return FunctionRoleItem(
      id: id ?? this.id,
      functionRoleGuid: functionRoleGuid ?? this.functionRoleGuid,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      moduleName: moduleName ?? this.moduleName,
      usersAssignedLabel: usersAssignedLabel ?? this.usersAssignedLabel,
      includedFunctions: includedFunctions ?? this.includedFunctions,
      includedFunctionGuids: includedFunctionGuids ?? this.includedFunctionGuids,
      inheritedFunctionGuids: inheritedFunctionGuids ?? this.inheritedFunctionGuids,
      inheritedParentRoleIds: inheritedParentRoleIds ?? this.inheritedParentRoleIds,
      functionGuidToIdMap: functionGuidToIdMap ?? this.functionGuidToIdMap,
      isActive: isActive ?? this.isActive,
    );
  }
}

class FunctionRolesState {
  static const int maxPageSize = 10;

  const FunctionRolesState({
    this.searchQuery = '',
    this.selectedModuleId,
    this.currentPage = 1,
    this.pageSize = 10,
    this.roles = const [],
    this.totalItems = 0,
    this.totalPages = 1,
    this.hasNext = false,
    this.hasPrevious = false,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isSubmitting = false,
    this.error,
    this.formModule = '',
    this.formStatus = ActiveInactiveStatus.active,
    this.formSelectedFunctions = const {},
    this.formInheritedFunctions = const {},
    this.formFunctionSearch = '',
    this.formStep = 0,
    this.deletingFunctionRoleGuid,
    this.formFunctionGuidToId = const {},
  });

  final String searchQuery;

  final int? selectedModuleId;
  final int currentPage;
  final int pageSize;
  final List<FunctionRoleItem> roles;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  final bool isLoading;
  final bool isRefreshing;
  final bool isSubmitting;
  final String? error;

  final String? deletingFunctionRoleGuid;

  final String formModule;
  final ActiveInactiveStatus formStatus;
  final Set<String> formSelectedFunctions;
  final Set<String> formInheritedFunctions;
  final String formFunctionSearch;

  /// Current step index in the multi-step form (0 = details, 1 = inherited roles).
  final int formStep;

  /// Accumulated guid→id cache for all functions the user has selected or that
  /// were pre-loaded from an existing role. Used at submit time to resolve IDs
  /// without depending on the currently visible page of securityFunctionsProvider.
  final Map<String, int> formFunctionGuidToId;

  int get effectivePageSize => pageSize.clamp(1, maxPageSize).toInt();

  int get safeCurrentPage => currentPage.clamp(1, totalPages < 1 ? 1 : totalPages);

  List<FunctionRoleItem> get paginatedRoles {
    return roles;
  }

  int get startItem => roles.isEmpty ? 0 : ((safeCurrentPage - 1) * effectivePageSize) + 1;

  int get endItem => roles.isEmpty ? 0 : (startItem + paginatedRoles.length - 1);

  FunctionRolesState copyWith({
    String? searchQuery,
    int? selectedModuleId,
    bool clearSelectedModuleId = false,
    int? currentPage,
    int? pageSize,
    List<FunctionRoleItem>? roles,
    int? totalItems,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
    bool? isLoading,
    bool? isRefreshing,
    bool? isSubmitting,
    String? error,
    bool clearError = false,
    String? formModule,
    ActiveInactiveStatus? formStatus,
    Set<String>? formSelectedFunctions,
    Set<String>? formInheritedFunctions,
    String? formFunctionSearch,
    int? formStep,
    String? deletingFunctionRoleGuid,
    bool clearDeletingFunctionRoleGuid = false,
    Map<String, int>? formFunctionGuidToId,
  }) {
    return FunctionRolesState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedModuleId: clearSelectedModuleId ? null : (selectedModuleId ?? this.selectedModuleId),
      currentPage: currentPage ?? this.currentPage,
      pageSize: (pageSize ?? this.pageSize).clamp(1, maxPageSize).toInt(),
      roles: roles ?? this.roles,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : (error ?? this.error),
      formModule: formModule ?? this.formModule,
      formStatus: formStatus ?? this.formStatus,
      formSelectedFunctions: formSelectedFunctions ?? this.formSelectedFunctions,
      formInheritedFunctions: formInheritedFunctions ?? this.formInheritedFunctions,
      formFunctionSearch: formFunctionSearch ?? this.formFunctionSearch,
      formStep: formStep ?? this.formStep,
      deletingFunctionRoleGuid: clearDeletingFunctionRoleGuid
          ? null
          : (deletingFunctionRoleGuid ?? this.deletingFunctionRoleGuid),
      formFunctionGuidToId: formFunctionGuidToId ?? this.formFunctionGuidToId,
    );
  }
}
