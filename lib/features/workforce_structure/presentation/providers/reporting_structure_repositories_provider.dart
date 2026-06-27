import 'package:grc/features/workforce_structure/presentation/providers/employee_providers.dart';
import 'package:grc/features/workforce_structure/data/datasources/reporting_structure_remote_datasource.dart';
import 'package:grc/features/workforce_structure/data/repositories/reporting_structure_repository_impl.dart';
import 'package:grc/features/workforce_structure/domain/repositories/reporting_structure_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reportingStructureRemoteDataSourceProvider = Provider<ReportingStructureRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ReportingStructureRemoteDataSourceImpl(apiClient: apiClient);
});

final reportingStructureRepositoryProvider = Provider<ReportingStructureRepository>((ref) {
  final remoteDataSource = ref.watch(reportingStructureRemoteDataSourceProvider);
  return ReportingStructureRepositoryImpl(dataSource: remoteDataSource);
});
