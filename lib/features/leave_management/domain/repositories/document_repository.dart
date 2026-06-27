import 'package:grc/features/leave_management/domain/models/document.dart';

abstract class DocumentRepository {
  Future<Document?> pickFile({List<String>? allowedExtensions, int? maxSizeInBytes});

  Future<List<Document>> pickFiles({List<String>? allowedExtensions, int? maxSizeInBytes});

  Future<void> removeDocument(String path);
}
