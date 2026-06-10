import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/assessments/domain/entities/assessment_entities.dart';
import 'package:grc_web/features/assessments/domain/repositories/assessments_repository.dart';

class GetAssessmentsUseCase {
  const GetAssessmentsUseCase(this._repository);

  final AssessmentsRepository _repository;

  Future<Result<AssessmentsData>> call() => _repository.getAssessments();
}

class GetFrameworkDetailUseCase {
  const GetFrameworkDetailUseCase(this._repository);

  final AssessmentsRepository _repository;

  Future<Result<FrameworkDetail>> call(String frameworkName) =>
      _repository.getFrameworkDetail(frameworkName);
}
