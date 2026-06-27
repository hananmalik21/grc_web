import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum RoleDelegationStatus { active, pendingApproval, expired, revoked }

extension RoleDelegationStatusX on RoleDelegationStatus {
  String get label => switch (this) {
    RoleDelegationStatus.active => 'Active',
    RoleDelegationStatus.pendingApproval => 'Pending',
    RoleDelegationStatus.expired => 'Expired',
    RoleDelegationStatus.revoked => 'Revoked',
  };

  Color capsuleBackgroundColor({required bool isDark}) => switch (this) {
    RoleDelegationStatus.active => isDark ? AppColors.successBgDark : AppColors.successBg,
    RoleDelegationStatus.pendingApproval => isDark ? AppColors.warningBgDark : AppColors.pendingStatusBackground,
    RoleDelegationStatus.expired => isDark ? AppColors.errorBgDark : AppColors.errorBg,
    RoleDelegationStatus.revoked => isDark ? AppColors.grayBgDark : AppColors.grayBg,
  };

  Color capsuleBorderColor({required bool isDark}) => switch (this) {
    RoleDelegationStatus.active => isDark ? AppColors.successBorderDark : AppColors.successBorder,
    RoleDelegationStatus.pendingApproval => isDark ? AppColors.warningBorderDark : AppColors.warningBorder,
    RoleDelegationStatus.expired => isDark ? AppColors.errorBorderDark : AppColors.errorBorder,
    RoleDelegationStatus.revoked => isDark ? AppColors.grayBorderDark : AppColors.grayBorder,
  };

  Color capsuleTextColor({required bool isDark}) => switch (this) {
    RoleDelegationStatus.active => isDark ? AppColors.successTextDark : AppColors.successText,
    RoleDelegationStatus.pendingApproval => isDark ? AppColors.warningTextDark : AppColors.pendingStatucColor,
    RoleDelegationStatus.expired => isDark ? AppColors.errorTextDark : AppColors.errorText,
    RoleDelegationStatus.revoked => isDark ? AppColors.grayTextDark : AppColors.grayText,
  };
}

class RoleDelegationUser {
  final String name;
  final String title;

  const RoleDelegationUser({required this.name, required this.title});

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '';
    final first = parts.first.characters.isEmpty ? '' : parts.first.characters.first;
    final last = parts.length == 1 ? '' : (parts.last.characters.isEmpty ? '' : parts.last.characters.first);
    return (first + last).toUpperCase();
  }
}

class RoleDelegationItem {
  final String id;
  final RoleDelegationStatus status;
  final RoleDelegationUser delegator;
  final RoleDelegationUser delegatee;
  final List<String> delegatedRoles;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;

  const RoleDelegationItem({
    required this.id,
    required this.status,
    required this.delegator,
    required this.delegatee,
    required this.delegatedRoles,
    required this.startDate,
    required this.endDate,
    required this.reason,
  });

  RoleDelegationItem copyWith({RoleDelegationStatus? status}) {
    return RoleDelegationItem(
      id: id,
      status: status ?? this.status,
      delegator: delegator,
      delegatee: delegatee,
      delegatedRoles: delegatedRoles,
      startDate: startDate,
      endDate: endDate,
      reason: reason,
    );
  }
}

class RoleDelegationState {
  final String query;
  final RoleDelegationStatus? statusFilter;
  final int currentPage;
  final int pageSize;
  final List<RoleDelegationItem> delegations;

  const RoleDelegationState({
    this.query = '',
    this.statusFilter,
    this.currentPage = 1,
    this.pageSize = 3,
    this.delegations = const [],
  });

  RoleDelegationState copyWith({
    String? query,
    RoleDelegationStatus? statusFilter,
    bool clearStatusFilter = false,
    int? currentPage,
    int? pageSize,
    List<RoleDelegationItem>? delegations,
  }) {
    return RoleDelegationState(
      query: query ?? this.query,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      delegations: delegations ?? this.delegations,
    );
  }
}

const List<RoleDelegationStatus?> roleDelegationStatusFilterItems = <RoleDelegationStatus?>[
  null,
  RoleDelegationStatus.active,
  RoleDelegationStatus.pendingApproval,
  RoleDelegationStatus.expired,
  RoleDelegationStatus.revoked,
];
