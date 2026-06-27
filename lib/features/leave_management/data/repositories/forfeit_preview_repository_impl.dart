import 'package:grc/features/leave_management/data/datasources/forfeit_preview_local_data_source.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_preview_employee.dart';
import 'package:grc/features/leave_management/domain/repositories/forfeit_preview_repository.dart';

class ForfeitPreviewRepositoryImpl implements ForfeitPreviewRepository {
  final ForfeitPreviewLocalDataSource localDataSource;

  ForfeitPreviewRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ForfeitPreviewEmployee>> getForfeitPreviewEmployees() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return localDataSource.getForfeitPreviewEmployees();
  }
}
