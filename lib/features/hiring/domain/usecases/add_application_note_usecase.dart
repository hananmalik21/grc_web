import 'package:grc/features/hiring/domain/models/applications/add_application_note_input.dart';
import 'package:grc/features/hiring/domain/repositories/applications_repository.dart';

class AddApplicationNoteUseCase {
  const AddApplicationNoteUseCase({required this.repository});

  final ApplicationsRepository repository;

  Future<Map<String, dynamic>> call(AddApplicationNoteInput input) {
    return repository.addApplicationNote(input);
  }
}
