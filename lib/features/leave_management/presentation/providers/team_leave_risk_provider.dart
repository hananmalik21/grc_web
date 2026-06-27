import 'package:grc/features/leave_management/domain/models/team_leave_risk_employee.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamLeaveRiskState {
  final List<TeamLeaveRiskEmployee> employees;
  final TeamLeaveRiskStats stats;
  final bool isLoading;
  final String? error;

  const TeamLeaveRiskState({required this.employees, required this.stats, this.isLoading = false, this.error});

  TeamLeaveRiskState copyWith({
    List<TeamLeaveRiskEmployee>? employees,
    TeamLeaveRiskStats? stats,
    bool? isLoading,
    String? error,
  }) {
    return TeamLeaveRiskState(
      employees: employees ?? this.employees,
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class TeamLeaveRiskNotifier extends StateNotifier<TeamLeaveRiskState> {
  TeamLeaveRiskNotifier() : super(_initialState);

  static const _initialState = TeamLeaveRiskState(
    employees: [],
    stats: TeamLeaveRiskStats(teamMembers: 0, employeesAtRisk: 0, totalAtRiskDays: 0, avgAtRiskPerEmployee: 0),
    isLoading: false,
  );

  void _loadData() {
    // Mock data matching the Figma design
    final employees = [
      TeamLeaveRiskEmployee(
        id: '1',
        employeeId: 'EMP001',
        name: 'Ahmed Al-Mansour',
        nameArabic: 'أحمد المنصور',
        department: 'Engineering',
        leaveType: 'Annual Leave',
        totalBalance: 24.5,
        atRiskDays: 4.5,
        carryForwardLimit: 10,
        expiryDate: DateTime(2024, 3, 31),
        riskLevel: RiskLevel.high,
      ),
      TeamLeaveRiskEmployee(
        id: '2',
        employeeId: 'EMP002',
        name: 'Fatima Al-Rashid',
        nameArabic: 'فاطمة الراشد',
        department: 'Finance',
        leaveType: 'Annual Leave',
        totalBalance: 28,
        atRiskDays: 8,
        carryForwardLimit: 10,
        expiryDate: DateTime(2024, 3, 31),
        riskLevel: RiskLevel.high,
      ),
      TeamLeaveRiskEmployee(
        id: '3',
        employeeId: 'EMP003',
        name: 'Mohammed Al-Salem',
        nameArabic: 'محمد السالم',
        department: 'Engineering',
        leaveType: 'Compassionate Leave',
        totalBalance: 7,
        atRiskDays: 4,
        carryForwardLimit: 3,
        expiryDate: DateTime(2024, 12, 31),
        riskLevel: RiskLevel.low,
      ),
      TeamLeaveRiskEmployee(
        id: '4',
        employeeId: 'EMP004',
        name: 'Sara Al-Khaled',
        nameArabic: 'سارة الخالد',
        department: 'HR',
        leaveType: 'Annual Leave',
        totalBalance: 22,
        atRiskDays: 2,
        carryForwardLimit: 10,
        expiryDate: DateTime(2024, 3, 31),
        riskLevel: RiskLevel.high,
      ),
    ];

    final stats = TeamLeaveRiskStats(
      teamMembers: 3,
      employeesAtRisk: 4,
      totalAtRiskDays: 18.5,
      avgAtRiskPerEmployee: 4.6,
    );

    state = state.copyWith(employees: employees, stats: stats, isLoading: false);
  }

  void refresh() {
    state = state.copyWith(isLoading: true);
    _loadData();
  }
}

final teamLeaveRiskProvider = StateNotifierProvider<TeamLeaveRiskNotifier, TeamLeaveRiskState>((ref) {
  return TeamLeaveRiskNotifier();
});
