import 'package:grc/features/workforce_structure/domain/models/reporting_relationship.dart';

abstract class ReportingStructureRepository {
  Future<List<ReportingRelationship>> getReportingRelationships({int? tenantId});
}
