import 'package:grc/features/leave_management/data/datasources/forfeit_schedule_local_data_source.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_schedule_entry.dart';
import 'package:grc/features/leave_management/domain/repositories/forfeit_schedule_repository.dart';

class ForfeitScheduleRepositoryImpl implements ForfeitScheduleRepository {
  final ForfeitScheduleLocalDataSource localDataSource;

  ForfeitScheduleRepositoryImpl({required this.localDataSource});

  @override
  Future<List<ForfeitScheduleEntry>> getForfeitScheduleEntries() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return localDataSource.getForfeitScheduleEntries();
  }
}
