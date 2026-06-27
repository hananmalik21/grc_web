import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/models/overtime/overtime_record.dart';
import 'overtime_enterprise_provider.dart';
import 'overtime_provider.dart';

class EditOvertimeRequestState {
  final OvertimeRecord record;
  final String numberOfHours;
  final String reason;
  final bool isLoading;

  const EditOvertimeRequestState({
    required this.record,
    required this.numberOfHours,
    required this.reason,
    this.isLoading = false,
  });

  EditOvertimeRequestState copyWith({OvertimeRecord? record, String? numberOfHours, String? reason, bool? isLoading}) {
    return EditOvertimeRequestState(
      record: record ?? this.record,
      numberOfHours: numberOfHours ?? this.numberOfHours,
      reason: reason ?? this.reason,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class EditOvertimeRequestNotifier extends StateNotifier<EditOvertimeRequestState?> {
  EditOvertimeRequestNotifier() : super(null);

  void init(OvertimeRecord record) {
    state = EditOvertimeRequestState(
      record: record,
      numberOfHours: record.overtimeDetail?.overtimeHours ?? '',
      reason: record.approvalInformation?.reason ?? '',
    );
  }

  void setNumberOfHours(String value) {
    if (state == null) return;
    state = state!.copyWith(numberOfHours: value);
  }

  void setReason(String value) {
    if (state == null) return;
    state = state!.copyWith(reason: value);
  }

  void setLoading(bool loading) {
    if (state == null) return;
    state = state!.copyWith(isLoading: loading);
  }

  void reset() {
    state = null;
  }

  bool validate() {
    if (state == null) return false;
    final hours = state!.numberOfHours.trim();
    if (hours.isEmpty) return false;
    final parsed = double.tryParse(hours);
    if (parsed == null || parsed <= 0) return false;
    final reason = state!.reason.trim();
    if (reason.isEmpty) return false;
    return true;
  }

  String? get validationError {
    if (state == null) return null;
    final hours = state!.numberOfHours.trim();
    if (hours.isEmpty) return 'Please enter number of hours';
    final parsed = double.tryParse(hours);
    if (parsed == null || parsed <= 0) return 'Please enter a valid number of hours';
    final reason = state!.reason.trim();
    if (reason.isEmpty) return 'Please enter justification/reason';
    return null;
  }
}

final editOvertimeRequestProvider = StateNotifierProvider<EditOvertimeRequestNotifier, EditOvertimeRequestState?>((
  ref,
) {
  return EditOvertimeRequestNotifier();
});

final updateOvertimeRequestProvider = Provider<Future<void> Function(BuildContext context, VoidCallback onSuccess)>((
  ref,
) {
  return (BuildContext context, VoidCallback onSuccess) async {
    final editState = ref.read(editOvertimeRequestProvider);
    final editNotifier = ref.read(editOvertimeRequestProvider.notifier);

    if (editState == null) return;
    if (!editNotifier.validate()) {
      ToastService.error(context, editNotifier.validationError ?? 'Please fix the errors');
      return;
    }

    final guid = editState.record.otRequestGuid;
    if (guid == null || guid.isEmpty) {
      ToastService.error(context, 'Invalid overtime request');
      return;
    }

    final enterpriseId = ref.read(overtimeEnterpriseIdProvider);
    if (enterpriseId == null) {
      ToastService.error(context, 'Please select an enterprise');
      return;
    }

    editNotifier.setLoading(true);
    var success = false;
    try {
      final requestedHours = double.tryParse(editState.numberOfHours.trim()) ?? 0;
      final overtimeNotifier = ref.read(overtimeManagementProvider.notifier);
      final error = await overtimeNotifier.updateOvertimeRequest(
        guid,
        requestedHours: requestedHours,
        reason: editState.reason.trim(),
      );

      if (!context.mounted) return;

      if (error == null) {
        success = true;
        final currentPage = ref.read(overtimeManagementProvider).currentPage;
        ToastService.success(context, 'Overtime request updated successfully');
        onSuccess();
        overtimeNotifier.loadOvertime(page: currentPage);
        Future.microtask(() => editNotifier.reset());
      } else {
        ToastService.error(context, error.replaceFirst('Exception: ', ''));
      }
    } on AppException catch (e) {
      if (context.mounted) {
        ToastService.error(context, e.message);
      }
    } catch (e) {
      if (context.mounted) {
        ToastService.error(context, 'Failed to update overtime request: ${e.toString()}');
      }
    } finally {
      if (!success) editNotifier.setLoading(false);
    }
  };
});
