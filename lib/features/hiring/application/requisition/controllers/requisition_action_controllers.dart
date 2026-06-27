import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/hiring/application/requisition/controllers/requisition_controller.dart';
import 'package:grc/features/hiring/application/requisition/providers/requisitions_api_providers.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApproveRequisitionController extends RequisitionControllerBase {
  const ApproveRequisitionController(super.ref);

  Future<void> approve(BuildContext context, {required String requisitionGuid}) async {
    final loc = AppLocalizations.of(context)!;
    if (!hasEnterpriseSelected) {
      ToastService.warning(context, loc.selectEnterpriseFirst);
      return;
    }

    if (!context.mounted) return;
    ref.read(approveRequisitionActionLoadingProvider(requisitionGuid).notifier).state = true;

    try {
      final response = await ref.read(approveRequisitionUseCaseProvider)(
        requisitionGuid: requisitionGuid,
        enterpriseId: enterpriseId!,
      );

      if (context.mounted) {
        refreshRequisitions();
        final message = response['message'] as String?;
        ToastService.success(context, message ?? loc.approved);
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.toString());
      }
    } finally {
      if (context.mounted) {
        ref.read(approveRequisitionActionLoadingProvider(requisitionGuid).notifier).state = false;
      }
    }
  }
}

final approveRequisitionControllerProvider = Provider<ApproveRequisitionController>((ref) {
  return ApproveRequisitionController(ref);
});

class RejectRequisitionController extends RequisitionControllerBase {
  const RejectRequisitionController(super.ref);

  Future<void> reject(BuildContext context, {required String requisitionGuid, required String rejectionReason}) async {
    final loc = AppLocalizations.of(context)!;
    if (!hasEnterpriseSelected) {
      ToastService.warning(context, loc.selectEnterpriseFirst);
      return;
    }

    if (!context.mounted) return;
    ref.read(rejectRequisitionActionLoadingProvider(requisitionGuid).notifier).state = true;

    try {
      final response = await ref.read(rejectRequisitionUseCaseProvider)(
        requisitionGuid: requisitionGuid,
        enterpriseId: enterpriseId!,
        rejectionReason: rejectionReason,
      );

      if (context.mounted) {
        refreshRequisitions();
        final message = response['message'] as String?;
        ToastService.success(context, message ?? loc.rejected);
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.toString());
      }
    } finally {
      if (context.mounted) {
        ref.read(rejectRequisitionActionLoadingProvider(requisitionGuid).notifier).state = false;
      }
    }
  }
}

final rejectRequisitionControllerProvider = Provider<RejectRequisitionController>((ref) {
  return RejectRequisitionController(ref);
});

class DeleteRequisitionController extends RequisitionControllerBase {
  const DeleteRequisitionController(super.ref);

  Future<void> delete(BuildContext context, {required String requisitionGuid}) async {
    final loc = AppLocalizations.of(context)!;
    if (!hasEnterpriseSelected) {
      ToastService.warning(context, loc.selectEnterpriseFirst);
      return;
    }

    if (!context.mounted) return;
    ref.read(deleteRequisitionActionLoadingProvider(requisitionGuid).notifier).state = true;

    try {
      final response = await ref.read(deleteRequisitionUseCaseProvider)(
        requisitionGuid: requisitionGuid,
        enterpriseId: enterpriseId!,
      );

      if (context.mounted) {
        refreshRequisitions();
        final message = response['message'] as String?;
        ToastService.success(context, message ?? loc.delete);
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.toString());
      }
    } finally {
      if (context.mounted) {
        ref.read(deleteRequisitionActionLoadingProvider(requisitionGuid).notifier).state = false;
      }
    }
  }
}

final deleteRequisitionControllerProvider = Provider<DeleteRequisitionController>((ref) {
  return DeleteRequisitionController(ref);
});

class ActivateRequisitionController extends RequisitionControllerBase {
  const ActivateRequisitionController(super.ref);

  Future<void> activate(String requisitionGuid) async {
    if (!hasEnterpriseSelected) return;

    ref.read(activateRequisitionResultProvider(requisitionGuid).notifier).state = null;
    ref.read(activateRequisitionActionLoadingProvider(requisitionGuid).notifier).state = true;

    try {
      await ref.read(reopenRequisitionUseCaseProvider)(requisitionGuid: requisitionGuid, enterpriseId: enterpriseId!);

      refreshRequisitions();
      ref.read(activateRequisitionResultProvider(requisitionGuid).notifier).state = const AsyncData(null);
    } catch (e, st) {
      ref.read(activateRequisitionResultProvider(requisitionGuid).notifier).state = AsyncError(e, st);
    } finally {
      ref.read(activateRequisitionActionLoadingProvider(requisitionGuid).notifier).state = false;
    }
  }
}

final activateRequisitionControllerProvider = Provider<ActivateRequisitionController>((ref) {
  return ActivateRequisitionController(ref);
});

class CloseRequisitionController extends RequisitionControllerBase {
  const CloseRequisitionController(super.ref);

  Future<void> close(String requisitionGuid) async {
    if (!hasEnterpriseSelected) return;

    ref.read(closeRequisitionResultProvider(requisitionGuid).notifier).state = null;
    ref.read(closeRequisitionActionLoadingProvider(requisitionGuid).notifier).state = true;

    try {
      await ref.read(closeRequisitionUseCaseProvider)(requisitionGuid: requisitionGuid, enterpriseId: enterpriseId!);

      refreshRequisitions();
      ref.read(closeRequisitionResultProvider(requisitionGuid).notifier).state = const AsyncData(null);
    } catch (e, st) {
      ref.read(closeRequisitionResultProvider(requisitionGuid).notifier).state = AsyncError(e, st);
    } finally {
      ref.read(closeRequisitionActionLoadingProvider(requisitionGuid).notifier).state = false;
    }
  }
}

final closeRequisitionControllerProvider = Provider<CloseRequisitionController>((ref) {
  return CloseRequisitionController(ref);
});

class HoldRequisitionController extends RequisitionControllerBase {
  const HoldRequisitionController(super.ref);

  Future<void> hold(String requisitionGuid) async {
    if (!hasEnterpriseSelected) return;

    ref.read(holdRequisitionResultProvider(requisitionGuid).notifier).state = null;
    ref.read(holdRequisitionActionLoadingProvider(requisitionGuid).notifier).state = true;

    try {
      await ref.read(holdRequisitionUseCaseProvider)(requisitionGuid: requisitionGuid, enterpriseId: enterpriseId!);

      refreshRequisitions();
      ref.read(holdRequisitionResultProvider(requisitionGuid).notifier).state = const AsyncData(null);
    } catch (e, st) {
      ref.read(holdRequisitionResultProvider(requisitionGuid).notifier).state = AsyncError(e, st);
    } finally {
      ref.read(holdRequisitionActionLoadingProvider(requisitionGuid).notifier).state = false;
    }
  }
}

final holdRequisitionControllerProvider = Provider<HoldRequisitionController>((ref) {
  return HoldRequisitionController(ref);
});
