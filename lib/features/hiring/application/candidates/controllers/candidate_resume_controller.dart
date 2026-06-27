import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidate_resume_providers.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CandidateResumeController {
  const CandidateResumeController(this.ref);

  final Ref ref;

  Future<void> openResume(BuildContext context, {required CandidateResumeData resume}) async {
    final resumeKey = _resumeKey(resume);
    if (resumeKey.isEmpty) {
      ToastService.error(context, 'Resume identifier is missing');
      return;
    }

    if (!context.mounted) return;
    ref.read(candidateResumeOpeningProvider(resumeKey).notifier).state = true;

    try {
      final opened = await ref.read(candidateResumeViewServiceProvider).openResume(resume: resume);

      if (context.mounted && !opened) {
        ToastService.error(context, 'Unable to open resume.');
      }
    } catch (error) {
      if (context.mounted) {
        ToastService.error(context, error.toString());
      }
    } finally {
      if (context.mounted) {
        ref.read(candidateResumeOpeningProvider(resumeKey).notifier).state = false;
      }
    }
  }

  String _resumeKey(CandidateResumeData resume) {
    final resumeGuid = resume.resumeGuid.trim();
    if (resumeGuid.isNotEmpty) return resumeGuid;
    return resume.resumeId.toString();
  }
}

final candidateResumeControllerProvider = Provider<CandidateResumeController>((ref) {
  return CandidateResumeController(ref);
});
