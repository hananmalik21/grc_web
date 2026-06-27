import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_api_providers.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/delete_candidate_assessment_providers.dart';
import 'package:grc/features/hiring/application/candidates/providers/get_candidate_detail_provider.dart';
import 'package:grc/features/hiring/domain/models/candidates/delete_candidate_assessment_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteCandidateAssessmentController {
  const DeleteCandidateAssessmentController(this.ref);

  final Ref ref;

  Future<void> delete(BuildContext context, {required String assessmentGuid, required String candidateGuid}) async {
    final loc = AppLocalizations.of(context)!;
    final enterpriseId = ref.read(candidatesTabEnterpriseIdProvider);

    if (enterpriseId == null || enterpriseId <= 0) {
      ToastService.warning(context, loc.selectEnterpriseFirst);
      return;
    }

    if (assessmentGuid.trim().isEmpty) {
      ToastService.error(context, 'Assessment identifier is missing');
      return;
    }

    if (!context.mounted) return;
    ref.read(deleteCandidateAssessmentLoadingProvider(assessmentGuid).notifier).state = true;

    try {
      final deletedBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';
      final response = await ref
          .read(deleteCandidateAssessmentUseCaseProvider)
          .call(
            DeleteCandidateAssessmentInput(
              assessmentGuid: assessmentGuid,
              enterpriseId: enterpriseId,
              deletedBy: deletedBy,
            ),
          );

      final detailParams = GetCandidateDetailParams(enterpriseId: enterpriseId, candidateGuid: candidateGuid);
      ref.invalidate(getCandidateDetailProvider(detailParams));
      ref.invalidate(getCandidateDetailDataProvider(detailParams));

      if (context.mounted) {
        final message = response['message'] as String?;
        ToastService.success(context, message ?? 'Assessment deleted successfully');
      }
    } on AppException catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.message);
      }
    } catch (_) {
      if (context.mounted) {
        ToastService.error(context, 'Failed to delete assessment. Please try again.');
      }
    } finally {
      if (context.mounted) {
        ref.read(deleteCandidateAssessmentLoadingProvider(assessmentGuid).notifier).state = false;
      }
    }
  }
}

final deleteCandidateAssessmentControllerProvider = Provider<DeleteCandidateAssessmentController>((ref) {
  return DeleteCandidateAssessmentController(ref);
});
