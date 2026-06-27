import 'package:grc/features/workforce_structure/data/datasources/reporting_structure_remote_datasource.dart';
import 'package:grc/features/workforce_structure/domain/models/reporting_relationship.dart';
import 'package:grc/features/workforce_structure/domain/repositories/reporting_structure_repository.dart';

class ReportingStructureRepositoryImpl implements ReportingStructureRepository {
  final ReportingStructureRemoteDataSource dataSource;

  ReportingStructureRepositoryImpl({required this.dataSource});

  @override
  Future<List<ReportingRelationship>> getReportingRelationships({int? tenantId}) async {
    return await dataSource.getReportingRelationships(tenantId: tenantId);
  }
}
