import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for all positions
final positionListProvider = StateProvider<List<Position>>((ref) {
  // Mock data - Replace with actual data source
  return [
    Position(
      id: '1',
      code: 'FIN-MGR-001',
      titleEnglish: 'Finance Manager',
      titleArabic: 'مدير المالية',
      department: 'Finance',
      jobFamily: 'Finance & Accounting',
      level: 'Manager',
      grade: 'Grade 8',
      step: 'Step 3',
      reportsTo: 'CFO',
      division: 'Finance Division',
      costCenter: 'CC-1000',
      location: 'Kuwait City HQ',
      budgetedMin: '2000 KD',
      budgetedMax: '2800 KD',
      actualAverage: '2400 KD',
      headcount: 2,
      filled: 2,
      vacant: 0,
      isActive: true,
    ),
    Position(
      id: '2',
      code: 'FIN-ACC-001',
      titleEnglish: 'Senior Accountant',
      titleArabic: 'محاسب أول',
      department: 'Finance',
      jobFamily: 'Finance & Accounting',
      level: 'Senior Professional',
      grade: 'Grade 6',
      step: 'Step 2',
      reportsTo: 'Finance Manager',
      division: 'Finance Division',
      costCenter: 'CC-1000',
      location: 'Kuwait City HQ',
      budgetedMin: '1850 KD',
      budgetedMax: '2250 KD',
      actualAverage: '2100 KD',
      headcount: 5,
      filled: 4,
      vacant: 1,
      isActive: true,
    ),
    Position(
      id: '3',
      code: 'FIN-ACC-002',
      titleEnglish: 'Accountant',
      titleArabic: 'محاسب',
      department: 'Finance',
      jobFamily: 'Finance & Accounting',
      level: 'Professional',
      grade: 'Grade 5',
      step: 'Step 1',
      reportsTo: 'Senior Accountant',
      division: 'Finance Division',
      costCenter: 'CC-1000',
      location: 'Kuwait City HQ',
      budgetedMin: '1650 KD',
      budgetedMax: '2000 KD',
      actualAverage: '1850 KD',
      headcount: 8,
      filled: 6,
      vacant: 2,
      isActive: true,
    ),
    Position(
      id: '4',
      code: 'HR-MGR-001',
      titleEnglish: 'HR Manager',
      titleArabic: 'مدير الموارد البشرية',
      department: 'Human Resources',
      jobFamily: 'Human Resources',
      level: 'Manager',
      grade: 'Grade 8',
      step: 'Step 2',
      reportsTo: 'CHRO',
      division: 'People & Culture',
      costCenter: 'CC-2000',
      location: 'Kuwait City HQ',
      budgetedMin: '1900 KD',
      budgetedMax: '2300 KD',
      actualAverage: '2150 KD',
      headcount: 1,
      filled: 1,
      vacant: 0,
      isActive: true,
    ),
    Position(
      id: '5',
      code: 'HR-REC-001',
      titleEnglish: 'Recruitment Specialist',
      titleArabic: 'أخصائي توظيف',
      department: 'Human Resources',
      jobFamily: 'Human Resources',
      level: 'Professional',
      grade: 'Grade 5',
      step: 'Step 3',
      reportsTo: 'HR Manager',
      division: 'People & Culture',
      costCenter: 'CC-2000',
      location: 'Kuwait City HQ',
      budgetedMin: '1450 KD',
      budgetedMax: '1700 KD',
      actualAverage: '1600 KD',
      headcount: 3,
      filled: 2,
      vacant: 1,
      isActive: true,
    ),
    Position(
      id: '6',
      code: 'IT-MGR-001',
      titleEnglish: 'IT Manager',
      titleArabic: 'مدير تقنية المعلومات',
      department: 'Information Technology',
      jobFamily: 'Information Technology',
      level: 'Manager',
      grade: 'Grade 8',
      step: 'Step 4',
      reportsTo: 'CIO',
      division: 'Technology Services',
      costCenter: 'CC-3000',
      location: 'Kuwait City HQ',
      budgetedMin: '2100 KD',
      budgetedMax: '2900 KD',
      actualAverage: '2550 KD',
      headcount: 1,
      filled: 1,
      vacant: 0,
      isActive: true,
    ),
    Position(
      id: '7',
      code: 'SAL-REP-001',
      titleEnglish: 'Sales Representative',
      titleArabic: 'مندوب مبيعات',
      department: 'Sales',
      jobFamily: 'Sales & Marketing',
      level: 'Professional',
      grade: 'Grade 4',
      step: 'Step 2',
      reportsTo: 'Sales Manager',
      division: 'Commercial',
      costCenter: 'CC-4000',
      location: 'Kuwait City HQ',
      budgetedMin: '1200 KD',
      budgetedMax: '1500 KD',
      actualAverage: '1350 KD',
      headcount: 10,
      filled: 7,
      vacant: 3,
      isActive: true,
    ),
    Position(
      id: '8',
      code: 'OPS-SUP-001',
      titleEnglish: 'Operations Supervisor',
      titleArabic: 'مشرف العمليات',
      department: 'Operations',
      jobFamily: 'Operations',
      level: 'Supervisor',
      grade: 'Grade 6',
      step: 'Step 1',
      reportsTo: 'Operations Manager',
      division: 'Operations',
      costCenter: 'CC-5000',
      location: 'Kuwait City HQ',
      budgetedMin: '1400 KD',
      budgetedMax: '1800 KD',
      actualAverage: '1650 KD',
      headcount: 4,
      filled: 4,
      vacant: 0,
      isActive: true,
    ),
  ];
});

/// Provider for search query
final positionSearchQueryProvider = StateProvider<String>((ref) => '');

/// Provider for selected department filter
final selectedDepartmentFilterProvider = StateProvider<String?>((ref) => null);

/// Provider for selected status filter
final selectedStatusFilterProvider = StateProvider<String?>((ref) => null);

/// Provider for filtered positions based on search and filters
final filteredPositionsProvider = Provider<List<Position>>((ref) {
  final positions = ref.watch(positionListProvider);
  final searchQuery = ref.watch(positionSearchQueryProvider).toLowerCase();
  final departmentFilter = ref.watch(selectedDepartmentFilterProvider);
  final statusFilter = ref.watch(selectedStatusFilterProvider);

  return positions.where((position) {
    // Search filter
    final matchesSearch =
        searchQuery.isEmpty ||
        position.titleEnglish.toLowerCase().contains(searchQuery) ||
        position.titleArabic.contains(searchQuery) ||
        position.code.toLowerCase().contains(searchQuery);

    // Department filter
    final matchesDepartment = departmentFilter == null || position.department == departmentFilter;

    // Status filter
    final matchesStatus =
        statusFilter == null ||
        (statusFilter == 'Active' && position.isActive) ||
        (statusFilter == 'Inactive' && !position.isActive);

    return matchesSearch && matchesDepartment && matchesStatus;
  }).toList();
});

/// Provider for storing the position selected for detail view
final selectedPositionProvider = StateProvider<Position?>((ref) => null);

/// Provider for workforce statistics
final workforceStatsProvider = Provider<WorkforceStats>((ref) {
  final positions = ref.watch(positionListProvider);

  final totalPositions = positions.fold<int>(0, (sum, position) => sum + position.headcount);

  final filledPositions = positions.fold<int>(0, (sum, position) => sum + position.filled);

  final vacantPositions = positions.fold<int>(0, (sum, position) => sum + position.vacant);

  final fillRate = totalPositions > 0 ? (filledPositions / totalPositions) * 100 : 0.0;

  return WorkforceStats(
    totalPositions: totalPositions,
    filledPositions: filledPositions,
    vacantPositions: vacantPositions,
    fillRate: fillRate,
  );
});

/// Workforce statistics data class
class WorkforceStats {
  final int totalPositions;
  final int filledPositions;
  final int vacantPositions;
  final double fillRate;

  const WorkforceStats({
    required this.totalPositions,
    required this.filledPositions,
    required this.vacantPositions,
    required this.fillRate,
  });
}
