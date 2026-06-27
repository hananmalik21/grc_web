import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../providers/overtime/edit_overtime_request_provider.dart';

class EditOvertimeRequestDialogActions extends ConsumerWidget {
  final VoidCallback onClose;

  const EditOvertimeRequestDialogActions({super.key, required this.onClose});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final state = ref.watch(editOvertimeRequestProvider);
    final save = ref.read(updateOvertimeRequestProvider);

    if (state == null) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton.outline(label: localizations.cancel, onPressed: state.isLoading ? null : onClose),
        Gap(12.w),
        AppButton.primary(
          label: 'Save Changes',
          svgPath: Assets.icons.saveDivisionIcon.path,
          isLoading: state.isLoading,
          onPressed: state.isLoading ? null : () => save(context, onClose),
        ),
      ],
    );
  }
}
