import 'dart:typed_data';

import 'candidate_resume_file_opener_stub.dart'
    if (dart.library.html) 'candidate_resume_file_opener_web.dart'
    if (dart.library.io) 'candidate_resume_file_opener_io.dart'
    as opener;

Future<bool> openCandidateResumeFile({required Uint8List bytes, required String fileName, required String mimeType}) {
  return opener.openResumeBytes(bytes: bytes, fileName: fileName, mimeType: mimeType);
}

String resolveResumeMimeType({required String fileName, required String fileType}) {
  final extension = _fileExtension(fileName).isNotEmpty ? _fileExtension(fileName) : fileType.trim().toLowerCase();

  return switch (extension) {
    'pdf' => 'application/pdf',
    'doc' => 'application/msword',
    'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    _ => 'application/octet-stream',
  };
}

String _fileExtension(String fileName) {
  final trimmed = fileName.trim();
  final dotIndex = trimmed.lastIndexOf('.');
  if (dotIndex <= 0 || dotIndex == trimmed.length - 1) return '';
  return trimmed.substring(dotIndex + 1).toLowerCase();
}
