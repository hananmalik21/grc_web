import 'package:grc/features/security_manager/presentation/providers/role_delegation/role_delegation_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoleDelegationNotifier extends StateNotifier<RoleDelegationState> {
  RoleDelegationNotifier() : super(const RoleDelegationState()) {
    state = state.copyWith(delegations: _mockDelegations);
  }

  static final _mockDelegations = <RoleDelegationItem>[
    RoleDelegationItem(
      id: 'DEL_001',
      status: RoleDelegationStatus.pendingApproval,
      delegator: RoleDelegationUser(name: 'Sarah Johnson', title: 'HR Director'),
      delegatee: RoleDelegationUser(name: 'Ahmed Al-Mutairi', title: 'HR Specialist'),
      delegatedRoles: ['ROLE_HR_DIRECTOR'],
      startDate: DateTime(2026, 3, 10),
      endDate: DateTime(2026, 3, 20),
      reason: 'Annual Leave',
    ),
    RoleDelegationItem(
      id: 'DEL_002',
      status: RoleDelegationStatus.active,
      delegator: RoleDelegationUser(name: 'Omar Khalid', title: 'Security Administrator'),
      delegatee: RoleDelegationUser(name: 'Fatima Noor', title: 'Security Analyst'),
      delegatedRoles: ['ROLE_SECURITY_ADMIN'],
      startDate: DateTime(2026, 3, 1),
      endDate: DateTime(2026, 3, 31),
      reason: 'Vacation Coverage',
    ),
    RoleDelegationItem(
      id: 'DEL_003',
      status: RoleDelegationStatus.active,
      delegator: RoleDelegationUser(name: 'Aisha Rahman', title: 'Payroll Manager'),
      delegatee: RoleDelegationUser(name: 'Bilal Hussain', title: 'Payroll Specialist'),
      delegatedRoles: ['ROLE_PAYROLL_MANAGER'],
      startDate: DateTime(2026, 3, 5),
      endDate: DateTime(2026, 4, 5),
      reason: 'Project Handover',
    ),
    RoleDelegationItem(
      id: 'DEL_004',
      status: RoleDelegationStatus.active,
      delegator: RoleDelegationUser(name: 'Zain Ali', title: 'Finance Controller'),
      delegatee: RoleDelegationUser(name: 'Hira Ahmed', title: 'Finance Officer'),
      delegatedRoles: ['ROLE_FINANCE_CONTROLLER'],
      startDate: DateTime(2026, 3, 12),
      endDate: DateTime(2026, 4, 12),
      reason: 'Temporary Authority',
    ),
    RoleDelegationItem(
      id: 'DEL_005',
      status: RoleDelegationStatus.active,
      delegator: RoleDelegationUser(name: 'Michael Chen', title: 'IT Manager'),
      delegatee: RoleDelegationUser(name: 'Leila Khan', title: 'IT Support Lead'),
      delegatedRoles: ['ROLE_IT_MANAGER'],
      startDate: DateTime(2026, 3, 15),
      endDate: DateTime(2026, 4, 15),
      reason: 'Emergency Access',
    ),
    RoleDelegationItem(
      id: 'DEL_006',
      status: RoleDelegationStatus.active,
      delegator: RoleDelegationUser(name: 'Nora Saleh', title: 'Compliance Lead'),
      delegatee: RoleDelegationUser(name: 'Hassan Raza', title: 'Compliance Specialist'),
      delegatedRoles: ['ROLE_COMPLIANCE_LEAD'],
      startDate: DateTime(2026, 3, 2),
      endDate: DateTime(2026, 3, 29),
      reason: 'Audit Coverage',
    ),
    RoleDelegationItem(
      id: 'DEL_007',
      status: RoleDelegationStatus.active,
      delegator: RoleDelegationUser(name: 'Priya Sharma', title: 'Operations Manager'),
      delegatee: RoleDelegationUser(name: 'Arif Mehmood', title: 'Operations Coordinator'),
      delegatedRoles: ['ROLE_OPERATIONS_MANAGER'],
      startDate: DateTime(2026, 3, 8),
      endDate: DateTime(2026, 4, 8),
      reason: 'Planned Absence',
    ),
    RoleDelegationItem(
      id: 'DEL_008',
      status: RoleDelegationStatus.expired,
      delegator: RoleDelegationUser(name: 'David Park', title: 'HR Manager'),
      delegatee: RoleDelegationUser(name: 'Sana Iqbal', title: 'HR Associate'),
      delegatedRoles: ['ROLE_HR_MANAGER'],
      startDate: DateTime(2026, 2, 10),
      endDate: DateTime(2026, 3, 5),
      reason: 'Temporary Coverage',
    ),
  ];

  void setQuery(String query) {
    state = state.copyWith(query: query, currentPage: 1);
  }

  void setStatusFilter(RoleDelegationStatus? status) {
    if (status == null) {
      state = state.copyWith(clearStatusFilter: true, currentPage: 1);
      return;
    }
    state = state.copyWith(statusFilter: status, currentPage: 1);
  }

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  List<RoleDelegationItem> get filteredDelegations {
    final query = state.query.trim().toLowerCase();
    final status = state.statusFilter;

    return state.delegations.where((d) {
      final matchesStatus = status == null || d.status == status;
      if (!matchesStatus) return false;

      if (query.isEmpty) return true;
      final haystack = [
        d.id,
        d.status.label,
        d.delegator.name,
        d.delegator.title,
        d.delegatee.name,
        d.delegatee.title,
        d.reason,
        ...d.delegatedRoles,
      ].join(' ').toLowerCase();
      return haystack.contains(query);
    }).toList();
  }

  List<RoleDelegationItem> get pageDelegations {
    final items = filteredDelegations;
    final start = (state.currentPage - 1) * state.pageSize;
    if (start >= items.length) return const [];
    final end = (start + state.pageSize).clamp(0, items.length);
    return items.sublist(start, end);
  }

  int get activeCount => state.delegations.where((d) => d.status == RoleDelegationStatus.active).length;
  int get pendingCount => state.delegations.where((d) => d.status == RoleDelegationStatus.pendingApproval).length;
  int get expiredCount => state.delegations.where((d) => d.status == RoleDelegationStatus.expired).length;
  int get totalCount => state.delegations.length;

  int get filteredCount => filteredDelegations.length;
  int get totalPages => filteredCount == 0 ? 1 : (filteredCount / state.pageSize).ceil();
  bool get hasNext => state.currentPage < totalPages;
  bool get hasPrevious => state.currentPage > 1;

  void approve(String delegationId) {
    _updateStatus(delegationId, RoleDelegationStatus.active);
  }

  void revoke(String delegationId) {
    _updateStatus(delegationId, RoleDelegationStatus.revoked);
  }

  void createDelegation({
    required RoleDelegationUser delegator,
    required RoleDelegationUser delegatee,
    required List<String> delegatedRoles,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) {
    final nextNumber = state.delegations.length + 1;
    final newItem = RoleDelegationItem(
      id: 'DEL_${nextNumber.toString().padLeft(3, '0')}',
      status: RoleDelegationStatus.pendingApproval,
      delegator: delegator,
      delegatee: delegatee,
      delegatedRoles: delegatedRoles,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
    );

    state = state.copyWith(delegations: [newItem, ...state.delegations], currentPage: 1);
  }

  void _updateStatus(String delegationId, RoleDelegationStatus status) {
    final updated = [
      for (final item in state.delegations)
        if (item.id == delegationId) item.copyWith(status: status) else item,
    ];
    state = state.copyWith(delegations: updated);
  }
}

final roleDelegationProvider = StateNotifierProvider<RoleDelegationNotifier, RoleDelegationState>(
  (ref) => RoleDelegationNotifier(),
);
