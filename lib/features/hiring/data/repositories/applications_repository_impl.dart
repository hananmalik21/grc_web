import 'package:grc/features/hiring/data/datasources/applications_remote_data_source.dart';
import 'package:grc/features/hiring/domain/models/applications/application.dart';
import 'package:grc/features/hiring/domain/models/applications/application_detail.dart';
import 'package:grc/features/hiring/domain/models/applications/add_application_note_input.dart';
import 'package:grc/features/hiring/domain/models/applications/change_application_stage_input.dart';
import 'package:grc/features/hiring/domain/models/applications/reject_application_input.dart';
import 'package:grc/features/hiring/domain/repositories/applications_repository.dart';

class ApplicationsRepositoryImpl implements ApplicationsRepository {
  const ApplicationsRepositoryImpl({required this.remoteDataSource});

  final ApplicationsRemoteDataSource remoteDataSource;

  @override
  Future<ApplicationsPage> getApplications({required int enterpriseId, int page = 1, int limit = 10}) async {
    final dto = await remoteDataSource.getApplications(enterpriseId: enterpriseId, page: page, limit: limit);
    return dto.toDomain();
  }

  @override
  Future<ApplicationDetail> getApplicationByGuid({required String applicationGuid, required int enterpriseId}) async {
    final dto = await remoteDataSource.getApplicationByGuid(
      applicationGuid: applicationGuid,
      enterpriseId: enterpriseId,
    );
    return dto.toDomain();
  }

  @override
  Future<Map<String, dynamic>> changeApplicationStage(ChangeApplicationStageInput input) {
    return remoteDataSource.changeApplicationStage(input);
  }

  @override
  Future<Map<String, dynamic>> addApplicationNote(AddApplicationNoteInput input) {
    return remoteDataSource.addApplicationNote(input);
  }

  @override
  Future<Map<String, dynamic>> rejectApplication(RejectApplicationInput input) {
    return remoteDataSource.rejectApplication(input);
  }
}
