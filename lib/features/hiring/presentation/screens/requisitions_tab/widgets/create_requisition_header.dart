import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateRequisitionHeader extends StatelessWidget {
  final bool canGoBack;
  final bool isLastStep;
  final bool isSubmitting;
  final VoidCallback? onBack;
  final VoidCallback onCancel;
  final VoidCallback onContinue;
  final VoidCallback? onSaveDraft;
  final bool isSavingDraft;
  final String? title;
  final String? description;
  final String? submitLabel;

  const CreateRequisitionHeader({
    super.key,
    required this.canGoBack,
    required this.isLastStep,
    required this.isSubmitting,
    required this.onBack,
    required this.onCancel,
    required this.onContinue,
    this.onSaveDraft,
    this.isSavingDraft = false,
    this.title,
    this.description,
    this.submitLabel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return DigifyTabHeader(
      title: title ?? 'Create New Requisition',
      description: description ?? 'Create a new comprehensive job requisition',
      trailing: Row(
        children: [
          AppButton.outline(label: 'Back', onPressed: canGoBack ? onBack : null),
          Gap(12.w),
          AppButton.outline(label: 'Cancel', onPressed: onCancel),
          Gap(12.w),
          AppButton.outline(
            label: l10n.saveAsDraft,
            isLoading: isSavingDraft,
            onPressed: (isSubmitting || isSavingDraft) ? null : onSaveDraft,
          ),
          Gap(12.w),
          AppButton.primary(
            label: isLastStep ? (submitLabel ?? 'Create Requisition') : 'Continue',
            isLoading: isSubmitting,
            svgPath: isLastStep ? Assets.icons.checkIconGreen.path : null,
            onPressed: (isSubmitting || isSavingDraft) ? null : onContinue,
          ),
        ],
      ),
    );
  }
}
