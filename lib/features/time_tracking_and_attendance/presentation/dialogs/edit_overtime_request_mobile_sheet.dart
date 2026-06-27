import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/overtime/overtime_record.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/dialogs/edit_overtime_request_dialog/edit_overtime_request_form_body.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime/edit_overtime_request_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EditOvertimeMobileSheet {
  EditOvertimeMobileSheet._();

  static Future<void> show(BuildContext context, OvertimeRecord record) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Edit Overtime Request',
      barrierDismissible: false,
      child: _EditOvertimeSheetBody(record: record),
    );
  }
}

class _EditOvertimeSheetBody extends ConsumerStatefulWidget {
  const _EditOvertimeSheetBody({required this.record});

  final OvertimeRecord record;

  @override
  ConsumerState<_EditOvertimeSheetBody> createState() => _EditOvertimeSheetBodyState();
}

class _EditOvertimeSheetBodyState extends ConsumerState<_EditOvertimeSheetBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(editOvertimeRequestProvider.notifier).init(widget.record);
    });
  }

  Future<void> _onSave() async {
    final save = ref.read(updateOvertimeRequestProvider);
    await save(context, () {
      if (mounted) Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editOvertimeRequestProvider);
    final localizations = AppLocalizations.of(context)!;
    final isLoading = state?.isLoading ?? false;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 8.h, bottom: 16.h),
            child: const EditOvertimeRequestFormBody(),
          ),
        ),
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                label: 'Save Changes',
                svgPath: Assets.icons.saveDivisionIcon.path,
                isLoading: isLoading,
                onPressed: isLoading ? null : _onSave,
                type: AppButtonType.primary,
              ),
              Gap(10.h),
              AppButton(
                label: localizations.cancel,
                onPressed: isLoading ? null : () => Navigator.of(context).pop(),
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
