import 'package:grc/features/hiring/domain/repositories/candidates_repository.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/utils/candidate_resume_file_opener.dart';

class CandidateResumeViewService {
  const CandidateResumeViewService({required CandidatesRepository repository}) : _repository = repository;

  final CandidatesRepository _repository;

  Future<bool> openResume({required CandidateResumeData resume}) async {
    final bytes = await _repository.getResumeBytes(resumeLink: resume.resumeLink);
    if (bytes.isEmpty) return false;

    final fileName = _safeFileName(resume.fileName);
    final mimeType = resolveResumeMimeType(fileName: fileName, fileType: resume.fileType);

    return openCandidateResumeFile(bytes: bytes, fileName: fileName, mimeType: mimeType);
  }

  String _safeFileName(String fileName) {
    final trimmed = fileName.trim();
    if (trimmed.isNotEmpty) return trimmed;
    return 'candidate_resume.pdf';
  }
}
