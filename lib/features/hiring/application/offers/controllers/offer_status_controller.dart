import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/hiring/application/offers/providers/job_offers_api_providers.dart';
import 'package:grc/features/hiring/application/offers/providers/offers_list_provider.dart';
import 'package:grc/features/hiring/domain/models/job_offers/job_offer_status_action.dart';
import 'package:grc/features/hiring/domain/models/job_offers/offer_status_code.dart';
import 'package:grc/features/hiring/domain/models/offer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final offerStatusActionLoadingProvider = StateProvider.autoDispose.family<bool, String>((ref, offerGuid) => false);

class OfferStatusController {
  const OfferStatusController(this.ref);

  final Ref ref;

  Future<void> changeStatus(BuildContext context, {required Offer offer, required String targetStatusCode}) async {
    final loc = AppLocalizations.of(context)!;
    final offerGuid = offer.offerGuid.trim();
    if (offerGuid.isEmpty) {
      ToastService.warning(context, loc.hiringOffersStatusChangeUnavailable);
      return;
    }

    final action = OfferStatusCode.actionForStatus(targetStatusCode);
    if (action == null) {
      ToastService.warning(context, loc.hiringOffersStatusActionUnavailable(targetStatusCode));
      return;
    }

    if (!context.mounted) return;
    ref.read(offerStatusActionLoadingProvider(offerGuid).notifier).state = true;

    try {
      final updatedBy = _resolveUpdatedBy(action);
      final response = await ref
          .read(performJobOfferStatusActionUseCaseProvider)
          .call(PerformJobOfferStatusActionInput(offerGuid: offerGuid, action: action, updatedBy: updatedBy));

      ref.invalidate(offersPageProvider);

      if (context.mounted) {
        final message = response['message'] as String?;
        ToastService.success(context, message ?? loc.hiringOffersStatusChangeSuccess);
      }
    } on AppException catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.message);
      }
    } catch (_) {
      if (context.mounted) {
        ToastService.error(context, loc.hiringOffersStatusChangeError);
      }
    } finally {
      if (context.mounted) {
        ref.read(offerStatusActionLoadingProvider(offerGuid).notifier).state = false;
      }
    }
  }

  String _resolveUpdatedBy(JobOfferStatusAction action) {
    final username = ref.read(currentUserProvider).valueOrNull?.username.trim();
    if (username != null && username.isNotEmpty) {
      return username;
    }

    return switch (action) {
      JobOfferStatusAction.extend => 'ADMIN',
      JobOfferStatusAction.approve || JobOfferStatusAction.withdraw => 'CANDIDATE',
    };
  }
}

final offerStatusControllerProvider = Provider<OfferStatusController>((ref) {
  return OfferStatusController(ref);
});
