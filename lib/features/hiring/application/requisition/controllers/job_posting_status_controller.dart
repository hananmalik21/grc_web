import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/hiring/application/requisition/providers/job_postings_api_providers.dart';
import 'package:grc/features/hiring/application/requisition/providers/requisition_job_postings_provider.dart';
import 'package:grc/features/hiring/application/requisition/providers/requisitions_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/domain/models/job_postings/activate_job_posting_input.dart';
import 'package:grc/features/hiring/domain/models/job_postings/pause_job_posting_input.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final jobPostingStatusActionLoadingProvider = StateProvider.autoDispose.family<bool, String>(
  (ref, postingGuid) => false,
);

class JobPostingStatusController {
  const JobPostingStatusController(this.ref);

  final Ref ref;

  Future<void> pause(BuildContext context, {required String postingGuid, required String requisitionGuid}) async {
    final loc = AppLocalizations.of(context)!;
    await _runStatusAction(
      context,
      postingGuid: postingGuid,
      requisitionGuid: requisitionGuid,
      action: (enterpriseId, actor) => ref
          .read(pauseJobPostingUseCaseProvider)
          .call(PauseJobPostingInput(postingGuid: postingGuid, enterpriseId: enterpriseId, pausedBy: actor)),
      successFallback: loc.hiringRequisitionJobPostingPauseSuccess,
      errorFallback: loc.hiringRequisitionJobPostingPauseError,
    );
  }

  Future<void> activate(BuildContext context, {required String postingGuid, required String requisitionGuid}) async {
    final loc = AppLocalizations.of(context)!;
    await _runStatusAction(
      context,
      postingGuid: postingGuid,
      requisitionGuid: requisitionGuid,
      action: (enterpriseId, actor) => ref
          .read(activateJobPostingUseCaseProvider)
          .call(ActivateJobPostingInput(postingGuid: postingGuid, enterpriseId: enterpriseId, activatedBy: actor)),
      successFallback: loc.hiringRequisitionJobPostingActivateSuccess,
      errorFallback: loc.hiringRequisitionJobPostingActivateError,
    );
  }

  Future<void> _runStatusAction(
    BuildContext context, {
    required String postingGuid,
    required String requisitionGuid,
    required Future<Map<String, dynamic>> Function(int enterpriseId, String actor) action,
    required String successFallback,
    required String errorFallback,
  }) async {
    final loc = AppLocalizations.of(context)!;
    final enterpriseId = ref.read(requisitionsTabEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      ToastService.warning(context, loc.selectEnterpriseFirst);
      return;
    }

    if (!context.mounted) return;
    ref.read(jobPostingStatusActionLoadingProvider(postingGuid).notifier).state = true;

    try {
      final actor = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';
      final response = await action(enterpriseId, actor);

      await ref.read(requisitionJobPostingsProvider(requisitionGuid).notifier).refresh();

      if (context.mounted) {
        final message = response['message'] as String?;
        ToastService.success(context, message ?? successFallback);
      }
    } on AppException catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.message);
      }
    } catch (_) {
      if (context.mounted) {
        ToastService.error(context, errorFallback);
      }
    } finally {
      if (context.mounted) {
        ref.read(jobPostingStatusActionLoadingProvider(postingGuid).notifier).state = false;
      }
    }
  }
}

final jobPostingStatusControllerProvider = Provider<JobPostingStatusController>((ref) {
  return JobPostingStatusController(ref);
});
