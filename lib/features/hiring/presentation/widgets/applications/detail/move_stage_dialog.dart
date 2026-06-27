import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/application/applications/providers/move_application_stage_provider.dart';
import 'package:grc/features/hiring/application/applications/states/move_application_stage_state.dart';
import 'package:grc/features/hiring/application/applications/utils/application_pipeline_utils.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class MoveStageDialog extends ConsumerWidget {
  const MoveStageDialog({super.key, required this.params});

  final MoveApplicationStageParams params;

  static Future<void> show(BuildContext context, {required MoveApplicationStageParams params}) {
    return showDialog(
      context: context,
      builder: (context) => MoveStageDialog(params: params),
    );
  }

  Future<void> _onSubmit(BuildContext context, WidgetRef ref) async {
    final loc = AppLocalizations.of(context)!;
    final notifier = ref.read(moveApplicationStageControllerProvider(params).notifier);
    final success = await notifier.submit();

    if (!context.mounted) return;

    final submitError = ref.read(moveApplicationStageControllerProvider(params)).submitError;
    if (!success) {
      if (submitError != null) {
        ToastService.error(context, submitError);
      }
      return;
    }

    ToastService.success(context, loc.hiringApplicationMoveStageSuccess);
    context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(moveApplicationStageControllerProvider(params));
    final notifier = ref.read(moveApplicationStageControllerProvider(params).notifier);
    final stages = selectablePipelineStageCodes(state.currentStageCode);
    final stageError = state.fieldErrors['stage'];

    return AppDialog(
      title: loc.hiringApplicationMoveStageTitle,
      width: 450.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifySelectFieldWithLabel<String>(
            label: loc.hiringApplicationMoveStageSelectLabel,
            isRequired: true,
            items: stages,
            value: state.selectedStageCode,
            itemLabelBuilder: (code) => pipelineStageLabel(loc, code),
            hint: loc.hiringApplicationMoveStageSelectHint,
            onChanged: notifier.setSelectedStageCode,
          ),
          if (stageError != null) ...[
            Gap(4.h),
            Text(
              stageError,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ],
          Gap(16.h),
          DigifyTextArea(
            labelText: loc.hiringApplicationMoveStageCommentsLabel,
            hintText: loc.hiringApplicationMoveStageCommentsHint,
            initialValue: state.comments,
            onChanged: notifier.setComments,
            maxLines: 4,
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: loc.cancel, onPressed: state.isSubmitting ? null : () => context.pop()),
        const SizedBox(width: 8),
        AppButton.primary(
          label: loc.hiringApplicationMoveStageButton,
          svgPath: Assets.icons.employeeManagement.arrowRight.path,
          isLoading: state.isSubmitting,
          onPressed: state.selectedStageCode == null || state.isSubmitting ? null : () => _onSubmit(context, ref),
        ),
      ],
    );
  }
}
