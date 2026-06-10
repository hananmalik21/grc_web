import 'package:grc_web/features/assessments/domain/entities/assessment_entities.dart';

abstract class AssessmentsRemoteDataSource {
  Future<AssessmentsData> getAssessments();
  Future<FrameworkDetail> getFrameworkDetail(String frameworkName);
}
