import 'package:grc/features/leave_management/domain/models/forfeit_preview_employee.dart';

abstract class ForfeitPreviewRepository {
  Future<List<ForfeitPreviewEmployee>> getForfeitPreviewEmployees();
}
