import 'package:grc/core/models/document_attachment_input.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<DocumentAttachmentInput?> pickCandidateResumeAttachment() async {
  final result = await FilePicker.pickFiles(
    type: FileType.custom,
    allowedExtensions: const ['pdf', 'doc', 'docx'],
    withData: kIsWeb,
  );
  if (result == null || result.files.isEmpty) return null;
  return documentAttachmentFromPlatformFile(result.files.first);
}

DocumentAttachmentInput? documentAttachmentFromPlatformFile(PlatformFile file) {
  if (file.name.trim().isEmpty) return null;

  if (kIsWeb && (file.bytes == null || file.bytes!.isEmpty)) {
    return null;
  }

  final byteLength = file.bytes?.length ?? 0;
  final size = file.size > 0 ? file.size : byteLength;

  return DocumentAttachmentInput(
    name: file.name,
    path: file.path ?? file.name,
    size: size,
    bytes: file.bytes,
    extension: file.extension,
  );
}
