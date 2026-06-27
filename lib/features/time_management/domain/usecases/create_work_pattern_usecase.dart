import 'package:grc/core/enums/position_status.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/domain/repositories/work_pattern_repository.dart';

/// Use case for creating a work pattern
class CreateWorkPatternUseCase {
  final WorkPatternRepository repository;

  const CreateWorkPatternUseCase({required this.repository});

  Future<WorkPattern> execute({
    required String patternCode,
    required String patternNameEn,
    required String patternNameAr,
    required String patternType,
    required int totalHoursPerWeek,
    required PositionStatus status,
    required List<WorkPatternDay> days,
  }) async {
    return await repository.createWorkPattern(
      patternCode: patternCode,
      patternNameEn: patternNameEn,
      patternNameAr: patternNameAr,
      patternType: patternType,
      totalHoursPerWeek: totalHoursPerWeek,
      status: status,
      days: days,
    );
  }
}
