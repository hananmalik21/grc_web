import 'package:grc/features/security_manager/domain/models/active_session.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActiveSessionsState {
  final String query;
  final ActiveSessionStatus? statusFilter;
  final int currentPage;
  final int pageSize;
  final List<ActiveSession> sessions;

  const ActiveSessionsState({
    this.query = '',
    this.statusFilter,
    this.currentPage = 1,
    this.pageSize = 10,
    this.sessions = const [],
  });

  ActiveSessionsState copyWith({
    String? query,
    ActiveSessionStatus? statusFilter,
    bool clearStatusFilter = false,
    int? currentPage,
    int? pageSize,
    List<ActiveSession>? sessions,
  }) {
    return ActiveSessionsState(
      query: query ?? this.query,
      statusFilter: clearStatusFilter ? null : (statusFilter ?? this.statusFilter),
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      sessions: sessions ?? this.sessions,
    );
  }
}

class ActiveSessionsNotifier extends StateNotifier<ActiveSessionsState> {
  ActiveSessionsNotifier() : super(ActiveSessionsState(sessions: _mockSessions));

  static const _mockSessions = <ActiveSession>[
    ActiveSession(
      sessionId: 'SES_001',
      userName: 'Ahmed Al-Mutairi',
      userEmail: 'ahmed.mutairi@digify.com',
      employeeId: 'EMP001',
      city: 'Kuwait City',
      country: 'Kuwait',
      ipAddress: '192.168.1.45',
      deviceName: 'Windows 11',
      deviceType: 'Desktop',
      browser: 'Chrome 120',
      loginAt: '2026-03-05 09:15',
      lastActiveAt: '2026-03-05 10:32',
      status: ActiveSessionStatus.active,
      isCurrent: true,
    ),
    ActiveSession(
      sessionId: 'SES_002',
      userName: 'John Smith',
      userEmail: 'john.smith@digify.com',
      employeeId: 'EMP002',
      city: 'Kuwait City',
      country: 'Kuwait',
      ipAddress: '192.168.1.10',
      deviceName: 'MacBook Pro',
      deviceType: 'Desktop',
      browser: 'Safari',
      loginAt: '2026-03-05 08:30',
      lastActiveAt: '2026-03-05 10:28',
      status: ActiveSessionStatus.active,
    ),
    ActiveSession(
      sessionId: 'SES_014',
      userName: 'Fatima Al-Sabah',
      userEmail: 'fatima.sabah@digify.com',
      employeeId: 'EMP014',
      city: 'Kuwait City',
      country: 'Kuwait',
      ipAddress: '10.10.18.21',
      deviceName: 'iPhone 15 Pro',
      deviceType: 'Mobile',
      browser: 'Safari',
      loginAt: '2026-03-05 07:05',
      lastActiveAt: '2026-03-05 07:20',
      status: ActiveSessionStatus.idle,
    ),
    ActiveSession(
      sessionId: 'SES_021',
      userName: 'Omar Khan',
      userEmail: 'omar.khan@digify.com',
      employeeId: 'EMP021',
      city: 'Kuwait City',
      country: 'Kuwait',
      ipAddress: '10.10.22.90',
      deviceName: 'Samsung S24',
      deviceType: 'Mobile',
      browser: 'Chrome 120',
      loginAt: '2026-03-04 22:10',
      lastActiveAt: '2026-03-04 22:12',
      status: ActiveSessionStatus.locked,
    ),
  ];

  void setQuery(String query) {
    state = state.copyWith(query: query, currentPage: 1);
  }

  void setStatusFilter(ActiveSessionStatus? status) {
    state = state.copyWith(statusFilter: status, currentPage: 1);
  }

  void clearFilters() {
    state = state.copyWith(query: '', clearStatusFilter: true, currentPage: 1);
  }

  void setPage(int page) {
    state = state.copyWith(currentPage: page);
  }

  void setPageSize(int size) {
    state = state.copyWith(pageSize: size, currentPage: 1);
  }

  List<ActiveSession> get filteredSessions {
    final q = state.query.trim().toLowerCase();
    return state.sessions.where((s) {
      final matchesStatus = state.statusFilter == null || s.status == state.statusFilter;
      if (!matchesStatus) return false;
      if (q.isEmpty) return true;
      final haystack = [
        s.userName,
        s.userEmail,
        s.employeeId,
        s.city,
        s.country,
        s.ipAddress,
        s.deviceName,
        s.deviceType,
        s.browser,
      ].join(' ').toLowerCase();
      return haystack.contains(q);
    }).toList();
  }

  int get totalItems => filteredSessions.length;

  int get totalPages => totalItems == 0 ? 1 : (totalItems / state.pageSize).ceil();

  bool get hasNext => state.currentPage < totalPages;

  bool get hasPrevious => state.currentPage > 1;

  List<ActiveSession> get pageItems {
    final items = filteredSessions;
    final start = (state.currentPage - 1) * state.pageSize;
    if (start >= items.length) return const [];
    final end = (start + state.pageSize).clamp(0, items.length);
    return items.sublist(start, end);
  }

  int countByStatus(ActiveSessionStatus status) => state.sessions.where((s) => s.status == status).length;
}

final activeSessionsProvider = StateNotifierProvider<ActiveSessionsNotifier, ActiveSessionsState>((ref) {
  return ActiveSessionsNotifier();
});
