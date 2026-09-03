import 'package:grc/features/cyber_security/data/datasources/compliance_remote_data_source.dart';
import 'package:grc/features/cyber_security/data/models/compliance_dto.dart';

abstract class ComplianceRepository {
  Future<List<FrameworkComplianceItem>> getFrameworkCompliance();
  Future<List<ComplianceFrameworkDto>> getFrameworks();
  Future<List<Map<String, dynamic>>> getFrameworkControls(String frameworkId);
  Future<List<ComplianceAssessmentDto>> getAssessments();
  Future<Map<String, dynamic>> getAssessment(String id);
  Future<List<Map<String, dynamic>>> getAssessmentControls(String id);
  Future<Map<String, dynamic>> createAssessment({
    required String frameworkVersionId,
    required String name,
  });
  Future<Map<String, dynamic>> updateAssessmentControl(
    String assessmentId,
    String controlId,
    Map<String, dynamic> body,
  );
}

class ComplianceRepositoryImpl implements ComplianceRepository {
  const ComplianceRepositoryImpl({
    required ComplianceRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final ComplianceRemoteDataSource _remoteDataSource;

  @override
  Future<List<ComplianceFrameworkDto>> getFrameworks() =>
      _remoteDataSource.getFrameworks();

  @override
  Future<List<Map<String, dynamic>>> getFrameworkControls(String frameworkId) =>
      _remoteDataSource.getFrameworkControls(frameworkId);

  @override
  Future<List<ComplianceAssessmentDto>> getAssessments() =>
      _remoteDataSource.getAssessments();

  @override
  Future<Map<String, dynamic>> getAssessment(String id) =>
      _remoteDataSource.getAssessment(id);

  @override
  Future<List<Map<String, dynamic>>> getAssessmentControls(String id) =>
      _remoteDataSource.getAssessmentControls(id);

  @override
  Future<Map<String, dynamic>> createAssessment({
    required String frameworkVersionId,
    required String name,
  }) => _remoteDataSource.createAssessment(
    frameworkVersionId: frameworkVersionId,
    name: name,
  );

  @override
  Future<Map<String, dynamic>> updateAssessmentControl(
    String assessmentId,
    String controlId,
    Map<String, dynamic> body,
  ) => _remoteDataSource.updateAssessmentControl(assessmentId, controlId, body);

  @override
  Future<List<FrameworkComplianceItem>> getFrameworkCompliance() async {
    final frameworks = await _remoteDataSource.getFrameworks();
    final assessments = await _remoteDataSource.getAssessments();
    final scoresByVersion = <String, List<double>>{};

    for (final assessment in assessments) {
      final score = assessment.overallScore;
      if (score != null) {
        scoresByVersion
            .putIfAbsent(assessment.frameworkVersionId, () => [])
            .add(score);
      }
    }

    return frameworks
        .where((framework) => framework.currentVersionId != null)
        .map((framework) {
          final scores =
              scoresByVersion[framework.currentVersionId] ?? const <double>[];
          final score = scores.isEmpty
              ? 0
              : scores.reduce((a, b) => a + b) / scores.length;
          return FrameworkComplianceItem(
            code: framework.code,
            name: framework.name,
            score: score.clamp(0, 100).toDouble(),
          );
        })
        .toList();
  }
}
