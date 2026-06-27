import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/gen/assets.gen.dart';
import '../../providers/overtime/edit_overtime_request_provider.dart';

class EditOvertimeRequestFormBody extends ConsumerStatefulWidget {
  const EditOvertimeRequestFormBody({super.key});

  @override
  ConsumerState<EditOvertimeRequestFormBody> createState() => _EditOvertimeRequestFormBodyState();
}

class _EditOvertimeRequestFormBodyState extends ConsumerState<EditOvertimeRequestFormBody> {
  TextEditingController? _reasonController;

  @override
  void dispose() {
    _reasonController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editOvertimeRequestProvider);
    if (state == null) return const SizedBox.shrink();

    final notifier = ref.read(editOvertimeRequestProvider.notifier);
    final record = state.record;

    _reasonController ??= TextEditingController(text: state.reason);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyTextField(
          labelText: 'EMPLOYEE',
          initialValue: record.employeeNameDisplay,
          readOnly: true,
          hintText: '--',
        ),
        Gap(16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DigifyTextField(
                labelText: 'OVERTIME DATE',
                initialValue: record.dateDisplay,
                readOnly: true,
                hintText: '--',
              ),
            ),
            Gap(16.w),
            Expanded(
              child: DigifyTextField(
                labelText: 'OVERTIME TYPE',
                initialValue: record.typeDisplay,
                readOnly: true,
                hintText: '--',
              ),
            ),
          ],
        ),
        Gap(16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DigifyTextField(
                labelText: 'NUMBER OF HOURS',
                isRequired: true,
                hintText: 'Type number of hours',
                initialValue: state.numberOfHours,
                onChanged: notifier.setNumberOfHours,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                prefixIcon: Padding(
                  padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
                  child: DigifyAsset(
                    assetPath: Assets.icons.clockIcon.path,
                    width: 20,
                    height: 20,
                    color: context.isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
                  ),
                ),
              ),
            ),
            Gap(16.w),
            Expanded(
              child: DigifyTextField(
                labelText: 'ESTIMATED RATE',
                initialValue: record.rateDisplay != '--' ? '${record.rateDisplay}x' : '--',
                readOnly: true,
                hintText: '--',
              ),
            ),
          ],
        ),
        Gap(16.h),
        DigifyTextArea(
          controller: _reasonController,
          labelText: 'JUSTIFICATION / REASON',
          isRequired: true,
          onChanged: notifier.setReason,
          hintText: 'Provide a detailed reason for the overtime requirement...',
          maxLines: 5,
        ),
      ],
    );
  }
}
