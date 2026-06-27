import 'package:grc/core/enums/position_status.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/domain/repositories/work_pattern_repository.dart';

/// Use case for updating a work pattern
class UpdateWorkPatternUseCase {
  final WorkPatternRepository repository;

  const UpdateWorkPatternUseCase({required this.repository});

  Future<WorkPattern> execute({
    required int workPatternId,
    required String patternNameEn,
    required String patternNameAr,
    required String patternType,
    required int totalHoursPerWeek,
    required PositionStatus status,
    required List<WorkPatternDay> days,
  }) async {
    return await repository.updateWorkPattern(
      workPatternId: workPatternId,
      patternNameEn: patternNameEn,
      patternNameAr: patternNameAr,
      patternType: patternType,
      totalHoursPerWeek: totalHoursPerWeek,
      status: status,
      days: days,
    );
  }
}
