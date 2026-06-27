import 'package:grc/features/payroll/data/datasources/element_entries_remote_data_source.dart';
import 'package:grc/features/payroll/data/dto/create_element_entry_request_dto.dart';
import 'package:grc/features/payroll/domain/repositories/element_entries_repository.dart';

class ElementEntriesRepositoryImpl implements ElementEntriesRepository {
  const ElementEntriesRepositoryImpl({required this.remoteDataSource});

  final ElementEntriesRemoteDataSource remoteDataSource;

  @override
  Future<void> createElementEntry(CreateElementEntryRequestDto request) {
    return remoteDataSource.createElementEntry(body: request.toJson());
  }
}
