import 'package:grc/features/hiring/domain/models/applications/application.dart';
import 'package:grc/features/hiring/domain/models/applications/application_detail.dart';
import 'package:grc/features/hiring/domain/models/applications/add_application_note_input.dart';
import 'package:grc/features/hiring/domain/models/applications/change_application_stage_input.dart';
import 'package:grc/features/hiring/domain/models/applications/reject_application_input.dart';

abstract class ApplicationsRepository {
  Future<ApplicationsPage> getApplications({required int enterpriseId, int page = 1, int limit = 10});

  Future<ApplicationDetail> getApplicationByGuid({required String applicationGuid, required int enterpriseId});

  Future<Map<String, dynamic>> changeApplicationStage(ChangeApplicationStageInput input);

  Future<Map<String, dynamic>> addApplicationNote(AddApplicationNoteInput input);

  Future<Map<String, dynamic>> rejectApplication(RejectApplicationInput input);
}
