import 'package:grc/core/enums/overtime_status.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../providers/overtime/create_overtime_request_provider.dart';
import '../../providers/overtime/new_overtime_attendance_day_id_provider.dart';
import '../../providers/overtime/new_overtime_provider.dart';

class NewOvertimeRequestDialogActions extends ConsumerWidget {
  final VoidCallback onClose;

  const NewOvertimeRequestDialogActions({super.key, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final submitRequest = ref.read(createOvertimeRequestProvider);
    final formState = ref.watch(newOvertimeRequestProvider);
    final attendanceAsync = ref.watch(newOvertimeAttendanceDayIdProvider);

    final isLoading = formState.isLoading;
    final isDraftLoading = formState.isDraftLoading;
    final hasAttendanceId = (attendanceAsync.valueOrNull?.attendanceDayId ?? 0) > 0;
    final canSubmit = !isLoading && !isDraftLoading && hasAttendanceId;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton.outline(label: localizations.cancel, onPressed: (isLoading || isDraftLoading) ? null : onClose),
        Gap(12.w),
        AppButton.outline(
          label: localizations.saveAsDraft,
          isLoading: isDraftLoading,
          onPressed: canSubmit
              ? () async {
                  await submitRequest(context, onClose, status: OvertimeStatus.draft);
                }
              : null,
        ),
        Gap(12.w),
        AppButton.primary(
          label: 'Submit Request',
          svgPath: Assets.icons.saveDivisionIcon.path,
          isLoading: isLoading,
          onPressed: canSubmit
              ? () async {
                  await submitRequest(context, onClose);
                }
              : null,
        ),
      ],
    );
  }
}
