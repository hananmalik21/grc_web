import 'package:grc/core/enums/position_status.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';

abstract class WorkPatternRepository {
  Future<PaginatedWorkPatterns> getWorkPatterns({int page = 1, int pageSize = 10});
  Future<WorkPattern> createWorkPattern({
    required String patternCode,
    required String patternNameEn,
    required String patternNameAr,
    required String patternType,
    required int totalHoursPerWeek,
    required PositionStatus status,
    required List<WorkPatternDay> days,
  });
  Future<WorkPattern> updateWorkPattern({
    required int workPatternId,
    required String patternNameEn,
    required String patternNameAr,
    required String patternType,
    required int totalHoursPerWeek,
    required PositionStatus status,
    required List<WorkPatternDay> days,
  });
  Future<void> deleteWorkPattern({required int workPatternId, required bool hard});
}
