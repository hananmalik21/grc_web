import 'package:grc/core/providers/current_user_provider.dart';
import 'package:grc/features/compensation/presentation/mappers/bulk_adjustment_request_mapper.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_api_providers.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_form_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_metadata_provider.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_tab_enterprise_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CreateBulkAdjustmentSubmitNotifier extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncValue.data(null);

  Future<void> submit() async {
    final enterpriseId = ref.read(bulkAdjustmentsTabEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      throw Exception('Enterprise is required');
    }

    final metadata = ref.read(bulkAdjustmentsMetadataProvider);
    final metadataError = ref.read(bulkAdjustmentsMetadataProvider.notifier).firstValidationError();
    if (metadataError != null) {
      throw Exception(metadataError);
    }

    final formState = ref.read(bulkAdjustmentsFormProvider);
    if (!bulkAdjustmentFormHasSubmittableChanges(formState)) {
      throw Exception('Update at least one component before submitting');
    }

    final effectiveDate = metadata.effectiveDate;
    if (effectiveDate == null) {
      throw Exception('Effective Date is required');
    }

    final updatedBy = ref.read(currentUserProvider).valueOrNull?.username ?? 'SYSTEM';
    final request = mapBulkAdjustmentSubmitRequest(
      enterpriseId: enterpriseId,
      adjustmentType: metadata.adjustmentType,
      effectiveDate: DateFormat('yyyy-MM-dd').format(effectiveDate),
      reasonCode: metadata.reasonCode,
      budgetCode: metadata.budgetCode,
      justificationText: metadata.justification.trim(),
      updatedBy: updatedBy,
      formState: formState,
    );

    if (request.employees.isEmpty) {
      throw Exception('No component changes to submit');
    }

    final hasInvalidEmployee = request.employees.any((employee) => employee.employeeId <= 0 || employee.planId <= 0);
    if (hasInvalidEmployee) {
      throw Exception('Selected employees are missing required identifiers');
    }

    ref.read(bulkAdjustmentsMetadataProvider.notifier).setSubmitting(true);
    state = const AsyncValue.loading();

    try {
      await ref.read(createBulkAdjustmentUseCaseProvider)(request: request);
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    } finally {
      ref.read(bulkAdjustmentsMetadataProvider.notifier).setSubmitting(false);
    }
  }
}

final createBulkAdjustmentSubmitProvider =
    AutoDisposeNotifierProvider<CreateBulkAdjustmentSubmitNotifier, AsyncValue<void>>(
      CreateBulkAdjustmentSubmitNotifier.new,
    );
