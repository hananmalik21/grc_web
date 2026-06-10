import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/assessments/domain/entities/assessment_entities.dart';

abstract class AssessmentsRepository {
  Future<Result<AssessmentsData>> getAssessments();
  Future<Result<FrameworkDetail>> getFrameworkDetail(String frameworkName);
}
