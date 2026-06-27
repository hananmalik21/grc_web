import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_api_providers.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_controller_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/candidates_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/delete_candidate_providers.dart';
import 'package:grc/features/hiring/domain/models/candidates/delete_candidate_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteCandidateController {
  const DeleteCandidateController(this.ref);

  final Ref ref;

  Future<void> delete(BuildContext context, {required String candidateGuid}) async {
    final loc = AppLocalizations.of(context)!;
    final enterpriseId = ref.read(candidatesTabEnterpriseIdProvider);

    if (enterpriseId == null || enterpriseId <= 0) {
      ToastService.warning(context, loc.selectEnterpriseFirst);
      return;
    }

    if (candidateGuid.trim().isEmpty) {
      ToastService.error(context, 'Candidate identifier is missing');
      return;
    }

    if (!context.mounted) return;
    ref.read(deleteCandidateLoadingProvider(candidateGuid).notifier).state = true;

    try {
      final deletedBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';
      final response = await ref
          .read(deleteCandidateUseCaseProvider)
          .call(DeleteCandidateInput(candidateGuid: candidateGuid, enterpriseId: enterpriseId, deletedBy: deletedBy));

      ref.read(candidatesControllerProvider).refreshCandidates();

      if (context.mounted) {
        final message = response['message'] as String?;
        ToastService.success(context, message ?? loc.hiringCandidatesDeletedMessage);
      }
    } on AppException catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.message);
      }
    } catch (_) {
      if (context.mounted) {
        ToastService.error(context, 'Failed to delete candidate. Please try again.');
      }
    } finally {
      if (context.mounted) {
        ref.read(deleteCandidateLoadingProvider(candidateGuid).notifier).state = false;
      }
    }
  }
}

final deleteCandidateControllerProvider = Provider<DeleteCandidateController>((ref) {
  return DeleteCandidateController(ref);
});
