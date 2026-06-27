import 'package:grc/features/security_manager/domain/models/duty_role.dart';
import 'package:grc/features/security_manager/domain/models/security_lookup_value.dart';
import 'package:flutter/material.dart';

class DutyRoleItem {
  const DutyRoleItem({
    required this.id,
    required this.dutyRoleGuid,
    required this.name,
    required this.code,
    required this.description,
    required this.category,
    required this.usersAssignedLabel,
    required this.includedFunctionRoles,
    this.inheritedFunctionRoleCodes = const [],
    this.inheritedDutyRoleGuids = const [],
    this.isActive = true,
    this.requiresApproval = false,
    this.effectiveFrom,
    this.expirationDate,
    this.categoryBackgroundColor,
    this.categoryTextColor,
    this.categoryBorderColor,
  });

  final String id;
  final String dutyRoleGuid;
  final String name;
  final String code;
  final String description;
  final String category;
  final String usersAssignedLabel;
  final List<String> includedFunctionRoles;
  final List<String> inheritedFunctionRoleCodes;
  final List<String> inheritedDutyRoleGuids;
  final bool isActive;
  final bool requiresApproval;
  final DateTime? effectiveFrom;
  final DateTime? expirationDate;
  final Color? categoryBackgroundColor;
  final Color? categoryTextColor;
  final Color? categoryBorderColor;

  factory DutyRoleItem.fromDutyRole(DutyRole role) {
    final theme = _DutyRoleThemeResolver.resolve(role.categoryCode);

    return DutyRoleItem(
      id: role.dutyRoleId.toString(),
      dutyRoleGuid: role.dutyRoleGuid,
      name: role.dutyRoleName,
      code: role.dutyRoleCode,
      description: role.description ?? '',
      category: role.categoryCode,
      usersAssignedLabel: '',
      includedFunctionRoles: role.directFunctionRoleCodes,
      inheritedFunctionRoleCodes: role.inheritedFunctionRoleCodes,
      inheritedDutyRoleGuids: role.inheritedDutyRoleGuids,
      isActive: role.isActive,
      requiresApproval: role.requiresManagerApproval,
      effectiveFrom: role.effectiveDate,
      expirationDate: role.expirationDate,
      categoryBackgroundColor: theme.$1,
      categoryTextColor: theme.$2,
      categoryBorderColor: theme.$3,
    );
  }

  DutyRoleItem copyWith({
    String? id,
    String? dutyRoleGuid,
    String? name,
    String? code,
    String? description,
    String? category,
    String? usersAssignedLabel,
    List<String>? includedFunctionRoles,
    List<String>? inheritedFunctionRoleCodes,
    List<String>? inheritedDutyRoleGuids,
    bool? isActive,
    bool? requiresApproval,
    Object? effectiveFrom = _sentinel,
    Object? expirationDate = _sentinel,
    Color? categoryBackgroundColor,
    Color? categoryTextColor,
    Color? categoryBorderColor,
  }) {
    return DutyRoleItem(
      id: id ?? this.id,
      dutyRoleGuid: dutyRoleGuid ?? this.dutyRoleGuid,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      category: category ?? this.category,
      usersAssignedLabel: usersAssignedLabel ?? this.usersAssignedLabel,
      includedFunctionRoles: includedFunctionRoles ?? this.includedFunctionRoles,
      inheritedFunctionRoleCodes: inheritedFunctionRoleCodes ?? this.inheritedFunctionRoleCodes,
      inheritedDutyRoleGuids: inheritedDutyRoleGuids ?? this.inheritedDutyRoleGuids,
      isActive: isActive ?? this.isActive,
      requiresApproval: requiresApproval ?? this.requiresApproval,
      effectiveFrom: identical(effectiveFrom, _sentinel) ? this.effectiveFrom : effectiveFrom as DateTime?,
      expirationDate: identical(expirationDate, _sentinel) ? this.expirationDate : expirationDate as DateTime?,
      categoryBackgroundColor: categoryBackgroundColor ?? this.categoryBackgroundColor,
      categoryTextColor: categoryTextColor ?? this.categoryTextColor,
      categoryBorderColor: categoryBorderColor ?? this.categoryBorderColor,
    );
  }
}

const Object _sentinel = Object();

class _DutyRoleThemeResolver {
  static (Color, Color, Color) resolve(String category) {
    final normalized = category.trim().toLowerCase();

    if (normalized.contains('payroll')) {
      return (const Color(0xFFFFF4E8), const Color(0xFFB65A00), const Color(0xFFFFD3A1));
    }

    return (const Color(0xFFEAF3FF), const Color(0xFF1D5BD1), const Color(0xFFBED6FF));
  }
}

class DutyRolesState {
  static const int maxPageSize = 10;

  const DutyRolesState({
    this.searchQuery = '',
    this.selectedCategoryCode = '',
    this.currentPage = 1,
    this.pageSize = 10,
    this.roles = const [],
    this.totalItems = 0,
    this.totalPages = 1,
    this.hasNext = false,
    this.hasPrevious = false,
    this.categoryLookups = const [],
    this.categoriesLoading = false,
    this.isLoading = false,
    this.isCreating = false,
    this.isUpdating = false,
    this.error,
    this.deletingDutyRoleGuid,
    this.selectedRoleGuids = const {},
  });

  final String searchQuery;

  /// Empty string means "All Categories".
  final String selectedCategoryCode;
  final int currentPage;
  final int pageSize;
  final List<DutyRoleItem> roles;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  final List<SecurityLookupValue> categoryLookups;
  final bool categoriesLoading;
  final bool isLoading;
  final bool isCreating;
  final bool isUpdating;
  final String? error;

  /// When set, the duty role card with this GUID shows delete loading.
  final String? deletingDutyRoleGuid;

  final Set<String> selectedRoleGuids;

  List<DutyRoleItem> get selectedRoles => roles.where((r) => selectedRoleGuids.contains(r.dutyRoleGuid)).toList();

  SecurityLookupValue? get selectedCategoryLookup => selectedCategoryCode.isEmpty
      ? null
      : categoryLookups.where((l) => l.valueCode == selectedCategoryCode).firstOrNull;

  int get effectivePageSize => pageSize.clamp(1, maxPageSize).toInt();

  int get safeCurrentPage => currentPage.clamp(1, totalPages < 1 ? 1 : totalPages);

  List<DutyRoleItem> get paginatedRoles => roles;

  DutyRolesState copyWith({
    String? searchQuery,
    String? selectedCategoryCode,
    int? currentPage,
    int? pageSize,
    List<DutyRoleItem>? roles,
    int? totalItems,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
    List<SecurityLookupValue>? categoryLookups,
    bool? categoriesLoading,
    bool? isLoading,
    bool? isCreating,
    bool? isUpdating,
    String? error,
    bool clearError = false,
    String? deletingDutyRoleGuid,
    bool clearDeletingDutyRoleGuid = false,
    Set<String>? selectedRoleGuids,
  }) {
    return DutyRolesState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryCode: selectedCategoryCode ?? this.selectedCategoryCode,
      currentPage: currentPage ?? this.currentPage,
      pageSize: (pageSize ?? this.pageSize).clamp(1, maxPageSize).toInt(),
      roles: roles ?? this.roles,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      categoryLookups: categoryLookups ?? this.categoryLookups,
      categoriesLoading: categoriesLoading ?? this.categoriesLoading,
      isLoading: isLoading ?? this.isLoading,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      error: clearError ? null : (error ?? this.error),
      deletingDutyRoleGuid: clearDeletingDutyRoleGuid ? null : (deletingDutyRoleGuid ?? this.deletingDutyRoleGuid),
      selectedRoleGuids: selectedRoleGuids ?? this.selectedRoleGuids,
    );
  }
}
