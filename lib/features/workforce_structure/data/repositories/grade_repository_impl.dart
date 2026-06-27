import 'package:grc/features/workforce_structure/data/datasources/grade_remote_datasource.dart';
import 'package:grc/features/workforce_structure/domain/models/grade.dart';
import 'package:grc/features/workforce_structure/domain/models/grade_response.dart';
import 'package:grc/features/workforce_structure/domain/repositories/grade_repository.dart';

class GradeRepositoryImpl implements GradeRepository {
  final GradeRemoteDataSource remoteDataSource;

  const GradeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GradeResponse> getGrades({int page = 1, int pageSize = 10, String? search, int? tenantId}) async {
    return await remoteDataSource.getGrades(page: page, pageSize: pageSize, search: search, tenantId: tenantId);
  }

  @override
  Future<Grade> createGrade(Grade grade, {int? tenantId}) async {
    final data = <String, dynamic>{
      'grade_number': grade.gradeNumber,
      'grade_category': grade.gradeCategory,
      'step_1_salary': grade.step1Salary,
      'step_2_salary': grade.step2Salary,
      'step_3_salary': grade.step3Salary,
      'step_4_salary': grade.step4Salary,
      'step_5_salary': grade.step5Salary,
      'description': grade.description,
      'last_update_login': 'ADMIN',
    };
    if (tenantId != null) data['tenant_id'] = tenantId;
    return await remoteDataSource.createGrade(data);
  }

  @override
  Future<Grade> updateGrade(int gradeId, Grade grade, {int? tenantId}) async {
    final data = <String, dynamic>{
      'grade_category': grade.gradeCategory,
      'step_1_salary': grade.step1Salary,
      'step_2_salary': grade.step2Salary,
      'step_3_salary': grade.step3Salary,
      'step_4_salary': grade.step4Salary,
      'step_5_salary': grade.step5Salary,
      'description': grade.description,
    };
    if (tenantId != null) data['tenant_id'] = tenantId;
    return await remoteDataSource.updateGrade(gradeId, data);
  }

  @override
  Future<void> deleteGrade(int gradeId, {int? tenantId}) async {
    return await remoteDataSource.deleteGrade(gradeId, tenantId: tenantId);
  }
}
