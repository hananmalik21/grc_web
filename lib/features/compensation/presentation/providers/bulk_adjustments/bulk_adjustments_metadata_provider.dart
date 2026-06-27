import 'package:flutter_riverpod/flutter_riverpod.dart';

class BulkAdjustmentsMetadataState {
  const BulkAdjustmentsMetadataState({
    this.adjustmentType = 'BULK_ADJUSTMENT',
    this.reasonCode = '',
    this.budgetCode = '',
    this.justification = '',
    this.effectiveDate,
    this.isSubmitting = false,
  });

  final String adjustmentType;
  final String reasonCode;
  final String budgetCode;
  final String justification;
  final DateTime? effectiveDate;
  final bool isSubmitting;

  BulkAdjustmentsMetadataState copyWith({
    String? adjustmentType,
    String? reasonCode,
    String? budgetCode,
    String? justification,
    DateTime? effectiveDate,
    bool? isSubmitting,
  }) {
    return BulkAdjustmentsMetadataState(
      adjustmentType: adjustmentType ?? this.adjustmentType,
      reasonCode: reasonCode ?? this.reasonCode,
      budgetCode: budgetCode ?? this.budgetCode,
      justification: justification ?? this.justification,
      effectiveDate: effectiveDate ?? this.effectiveDate,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

class BulkAdjustmentsMetadataNotifier extends AutoDisposeNotifier<BulkAdjustmentsMetadataState> {
  @override
  BulkAdjustmentsMetadataState build() => const BulkAdjustmentsMetadataState();

  void reset() => state = const BulkAdjustmentsMetadataState();

  void setReasonCode(String value) => state = state.copyWith(reasonCode: value);

  void setBudgetCode(String value) => state = state.copyWith(budgetCode: value);

  void setJustification(String value) => state = state.copyWith(justification: value);

  void setEffectiveDate(DateTime value) => state = state.copyWith(effectiveDate: value);

  void setSubmitting(bool value) => state = state.copyWith(isSubmitting: value);

  String? firstValidationError() {
    if (state.reasonCode.isEmpty) return 'Reason Code is required';
    if (state.effectiveDate == null) return 'Effective Date is required';
    if (state.budgetCode.isEmpty) return 'Budget Code is required';
    if (state.justification.trim().isEmpty) return 'Justification is required';
    return null;
  }
}

final bulkAdjustmentsMetadataProvider =
    AutoDisposeNotifierProvider<BulkAdjustmentsMetadataNotifier, BulkAdjustmentsMetadataState>(
      BulkAdjustmentsMetadataNotifier.new,
    );
