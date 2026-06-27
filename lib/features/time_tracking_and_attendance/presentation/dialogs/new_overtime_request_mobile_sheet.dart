import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/overtime_status.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/new_overtime_request_dialog_widgets/new_overtime_request_form_body.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime/create_overtime_request_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime/new_overtime_attendance_day_id_provider.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime/new_overtime_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NewOvertimeMobileSheet {
  NewOvertimeMobileSheet._();

  static Future<void> show(BuildContext context) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'New Overtime Request',
      barrierDismissible: false,
      child: const _NewOvertimeSheetBody(),
    );
  }
}

class _NewOvertimeSheetBody extends ConsumerStatefulWidget {
  const _NewOvertimeSheetBody();

  @override
  ConsumerState<_NewOvertimeSheetBody> createState() => _NewOvertimeSheetBodyState();
}

class _NewOvertimeSheetBodyState extends ConsumerState<_NewOvertimeSheetBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(newOvertimeRequestProvider.notifier).reset();
    });
  }

  Future<void> _onSubmit({OvertimeStatus status = OvertimeStatus.submitted}) async {
    final submit = ref.read(createOvertimeRequestProvider);
    await submit(context, () {
      if (mounted) Navigator.of(context).pop();
    }, status: status);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final formState = ref.watch(newOvertimeRequestProvider);
    final attendanceAsync = ref.watch(newOvertimeAttendanceDayIdProvider);

    final isLoading = formState.isLoading;
    final isDraftLoading = formState.isDraftLoading;
    final hasAttendanceId = (attendanceAsync.valueOrNull?.attendanceDayId ?? 0) > 0;
    final canSubmit = !isLoading && !isDraftLoading && hasAttendanceId;
    final busy = isLoading || isDraftLoading;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 8.h, bottom: 16.h),
            child: const NewOvertimeRequestFormBody(),
          ),
        ),
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                label: 'Submit Request',
                svgPath: Assets.icons.saveDivisionIcon.path,
                isLoading: isLoading,
                onPressed: canSubmit ? _onSubmit : null,
                type: AppButtonType.primary,
              ),
              Gap(10.h),
              AppButton(
                label: localizations.saveAsDraft,
                svgPath: Assets.icons.saveDivisionIcon.path,
                isLoading: isDraftLoading,
                onPressed: canSubmit ? () => _onSubmit(status: OvertimeStatus.draft) : null,
                type: AppButtonType.outline,
                backgroundColor: AppColors.cardBackground,
                foregroundColor: AppColors.primary,
              ),
              Gap(10.h),
              AppButton(
                label: localizations.cancel,
                onPressed: busy ? null : () => Navigator.of(context).pop(),
                type: AppButtonType.outline,
                backgroundColor: AppColors.cardBackground,
                foregroundColor: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
