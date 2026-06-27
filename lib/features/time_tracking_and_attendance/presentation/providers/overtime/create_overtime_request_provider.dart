import 'package:grc/core/enums/overtime_status.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'new_overtime_attendance_day_id_provider.dart';
import 'new_overtime_provider.dart';
import 'overtime_enterprise_provider.dart';
import 'overtime_provider.dart';
import 'overtime_rate_types_provider.dart';

final createOvertimeRequestProvider =
    Provider<Future<void> Function(BuildContext context, VoidCallback onSuccess, {OvertimeStatus status})>((ref) {
      return (BuildContext context, VoidCallback onSuccess, {OvertimeStatus status = OvertimeStatus.submitted}) async {
        final formState = ref.read(newOvertimeRequestProvider);
        final notifier = ref.read(newOvertimeRequestProvider.notifier);
        if (!notifier.validate()) {
          ToastService.error(context, notifier.validationError ?? 'Please fix the errors');
          return;
        }

        final enterpriseId = ref.read(overtimeEnterpriseIdProvider);
        if (enterpriseId == null) {
          ToastService.error(context, 'Please select an enterprise');
          return;
        }

        final rateTypesAsync = ref.read(overtimeRateTypesProvider);
        final otConfigId = rateTypesAsync.valueOrNull?.otConfigId;
        if (otConfigId == null || otConfigId == 0) {
          ToastService.error(context, 'Please select an overtime type first');
          return;
        }

        if (status == OvertimeStatus.draft) {
          notifier.setDraftLoading(true);
        } else {
          notifier.setLoading(true);
        }
        try {
          final attendance = await ref.read(newOvertimeAttendanceDayIdProvider.future);
          if (!context.mounted) return;
          final attendanceDayId = attendance.attendanceDayId;
          if (attendanceDayId == null || attendanceDayId == 0) {
            ToastService.error(
              context,
              'No attendance record found for this employee on the selected date. '
              'Please ensure attendance is marked for the date.',
            );
            return;
          }

          final employee = formState.selectedEmployee!;
          final requestedHours = double.tryParse(formState.numberOfHours!.trim()) ?? 0;
          final overtimeRepository = ref.read(overtimeRepositoryProvider);

          await overtimeRepository.createOvertimeRequest(
            tenantId: enterpriseId,
            employeeGuid: employee.guid,
            attendanceDayId: attendanceDayId,
            requestedHours: requestedHours,
            reason: formState.reason!.trim(),
            otConfigId: otConfigId,
            otRateTypeId: formState.overtimeType!.id,
            status: status,
          );

          if (context.mounted) {
            final message = status == OvertimeStatus.draft
                ? AppLocalizations.of(context)!.draftSaved
                : 'Overtime request submitted successfully';
            ToastService.success(context, message);
            onSuccess();
          }
          ref.read(overtimeManagementProvider.notifier).loadOvertime();
        } on AppException catch (e) {
          if (context.mounted) {
            ToastService.error(context, e.message);
          }
        } catch (e) {
          if (context.mounted) {
            ToastService.error(context, 'Failed to submit overtime request: ${e.toString()}');
          }
        } finally {
          if (status == OvertimeStatus.draft) {
            notifier.setDraftLoading(false);
          } else {
            notifier.setLoading(false);
          }
        }
      };
    });
