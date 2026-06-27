import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/application/applications/providers/add_application_note_provider.dart';
import 'package:grc/features/hiring/application/applications/states/add_application_note_state.dart';
import 'package:grc/features/hiring/application/applications/utils/application_note_utils.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class AddNotesDialog extends ConsumerWidget {
  const AddNotesDialog({super.key, required this.params});

  final AddApplicationNoteParams params;

  static Future<void> show(BuildContext context, {required AddApplicationNoteParams params}) {
    return showDialog(
      context: context,
      builder: (context) => AddNotesDialog(params: params),
    );
  }

  Future<void> _onSubmit(BuildContext context, WidgetRef ref) async {
    final loc = AppLocalizations.of(context)!;
    final notifier = ref.read(addApplicationNoteControllerProvider(params).notifier);
    final success = await notifier.submit();

    if (!context.mounted) return;

    final submitError = ref.read(addApplicationNoteControllerProvider(params)).submitError;
    if (!success) {
      if (submitError != null) {
        ToastService.error(context, submitError);
      }
      return;
    }

    ToastService.success(context, loc.hiringApplicationAddNoteSuccess);
    context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(addApplicationNoteControllerProvider(params));
    final notifier = ref.read(addApplicationNoteControllerProvider(params).notifier);
    final noteTextError = state.fieldErrors['noteText'];

    return AppDialog(
      title: loc.hiringApplicationAddNoteTitle,
      width: 450.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifySelectFieldWithLabel<String>(
            label: loc.hiringApplicationAddNoteTypeLabel,
            items: applicationNoteTypeCodes,
            value: state.noteTypeCode,
            itemLabelBuilder: (code) => applicationNoteTypeLabel(loc, code),
            hint: loc.hiringApplicationAddNoteTypeHint,
            onChanged: notifier.setNoteTypeCode,
          ),
          Gap(16.h),
          DigifyTextArea(
            labelText: loc.hiringApplicationAddNoteTextLabel,
            isRequired: true,
            hintText: loc.hiringApplicationAddNoteTextHint,
            initialValue: state.noteText,
            onChanged: notifier.setNoteText,
            maxLines: 6,
          ),
          if (noteTextError != null) ...[
            Gap(4.h),
            Text(
              noteTextError,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ],
          Gap(16.h),
          DigifyCheckbox(
            value: state.isPrivate,
            label: loc.hiringApplicationAddNotePrivateLabel,
            onChanged: (value) => notifier.setIsPrivate(value ?? false),
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: loc.cancel, onPressed: state.isSubmitting ? null : () => context.pop()),
        const SizedBox(width: 8),
        AppButton.primary(
          label: loc.hiringApplicationAddNoteButton,
          svgPath: Assets.icons.saveDivisionIcon.path,
          isLoading: state.isSubmitting,
          onPressed: state.noteText.trim().isEmpty || state.isSubmitting ? null : () => _onSubmit(context, ref),
        ),
      ],
    );
  }
}
