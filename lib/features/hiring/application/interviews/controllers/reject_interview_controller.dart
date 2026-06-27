import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/hiring/application/interviews/providers/interviews_api_providers.dart';
import 'package:grc/features/hiring/application/interviews/providers/interviews_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/domain/models/interview.dart';
import 'package:grc/features/hiring/domain/models/interview_result_status.dart';
import 'package:grc/features/hiring/domain/models/update_interview_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RejectInterviewController {
  const RejectInterviewController(this.ref);

  final Ref ref;

  Future<void> reject(BuildContext context, {required Interview interview}) async {
    final loc = AppLocalizations.of(context)!;
    final enterpriseId = ref.read(interviewsTabEnterpriseIdProvider);

    if (enterpriseId == null || enterpriseId <= 0) {
      ToastService.warning(context, loc.selectEnterpriseFirst);
      return;
    }

    final interviewGuid = interview.interviewGuid?.trim() ?? '';
    if (interviewGuid.isEmpty) {
      ToastService.error(context, loc.hiringInterviewRejectMissingId);
      return;
    }

    if (!context.mounted) return;
    ref.read(rejectInterviewLoadingProvider(interviewGuid).notifier).state = true;

    try {
      final updatedBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'ADMIN';
      final response = await ref
          .read(updateInterviewUseCaseProvider)
          .call(
            UpdateInterviewInput(
              interviewGuid: interviewGuid,
              enterpriseId: enterpriseId,
              updatedBy: updatedBy,
              resultStatus: InterviewResultStatus.rejected,
            ),
          );

      ref.read(interviewsTabRefreshTickProvider.notifier).state++;

      if (context.mounted) {
        final message = response['message'] as String?;
        ToastService.success(context, message ?? loc.hiringInterviewRejectSuccess);
      }
    } on AppException catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.message);
      }
    } catch (_) {
      if (context.mounted) {
        ToastService.error(context, loc.hiringInterviewRejectFailed);
      }
    } finally {
      if (context.mounted) {
        ref.read(rejectInterviewLoadingProvider(interviewGuid).notifier).state = false;
      }
    }
  }
}

final rejectInterviewControllerProvider = Provider<RejectInterviewController>((ref) {
  return RejectInterviewController(ref);
});

final rejectInterviewLoadingProvider = StateProvider.autoDispose.family<bool, String>((ref, interviewGuid) => false);
