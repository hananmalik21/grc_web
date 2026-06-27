import 'dart:ui';

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/application/applications/providers/reject_application_provider.dart';
import 'package:grc/features/hiring/application/applications/states/reject_application_state.dart';
import 'package:grc/features/hiring/application/applications/utils/application_rejection_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class RejectApplicationDialog extends ConsumerWidget {
  const RejectApplicationDialog({super.key, required this.params});

  final RejectApplicationParams params;

  static Future<void> show(BuildContext context, {required RejectApplicationParams params}) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (context) => RejectApplicationDialog(params: params),
    );
  }

  Future<void> _onReject(BuildContext context, WidgetRef ref) async {
    final loc = AppLocalizations.of(context)!;
    final notifier = ref.read(rejectApplicationControllerProvider(params).notifier);
    final success = await notifier.submit();

    if (!context.mounted) return;

    final submitError = ref.read(rejectApplicationControllerProvider(params)).submitError;
    if (!success) {
      if (submitError != null) {
        ToastService.error(context, submitError);
      }
      return;
    }

    ToastService.success(context, loc.hiringApplicationRejectSuccess);
    context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(rejectApplicationControllerProvider(params));
    final notifier = ref.read(rejectApplicationControllerProvider(params).notifier);
    final reasonError = state.fieldErrors['reason'];

    final isDark = context.isDark;
    final isMobile = context.isMobileLayout;

    final maxWidth = context.responsive<double>(mobile: 360, tablet: 460, desktop: 500);
    final horizontalPadding = context.responsive<double>(mobile: 20, tablet: 28, desktop: 32);
    final iconSize = context.responsive<double>(mobile: 56, tablet: 64, desktop: 64);
    final iconInnerSize = context.responsive<double>(mobile: 28, tablet: 32, desktop: 32);
    final titleFontSize = context.responsive<double>(mobile: 18, tablet: 20, desktop: 20);
    final bodyFontSize = context.responsive<double>(mobile: 13.5, tablet: 14.5, desktop: 14.5);
    final buttonHeight = context.responsive<double>(mobile: 42, tablet: 46, desktop: 46);
    final topPadding = context.responsive<double>(mobile: 28, tablet: 32, desktop: 36);
    final bottomPadding = context.responsive<double>(mobile: 24, tablet: 28, desktop: 28);

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: isMobile ? 0.9 * MediaQuery.sizeOf(context).width : maxWidth,
            constraints: BoxConstraints(maxWidth: maxWidth),
            margin: EdgeInsets.symmetric(horizontal: context.responsive<double>(mobile: 20, tablet: 40, desktop: 0)),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : Colors.white,
              borderRadius: BorderRadius.circular(isMobile ? 20.r : 16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap(topPadding),
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.error.withValues(alpha: 0.15) : AppColors.errorBg,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.warning_amber_rounded, color: AppColors.error, size: iconInnerSize),
                ),
                Gap(16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    children: [
                      Text(
                        loc.hiringApplicationRejectTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.w700,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Gap(8.h),
                      Text(
                        loc.hiringApplicationRejectSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: bodyFontSize,
                          fontWeight: FontWeight.w400,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DigifySelectFieldWithLabel<String>(
                        label: loc.hiringApplicationRejectReasonLabel,
                        isRequired: true,
                        items: applicationRejectionReasonCodes,
                        value: state.rejectionReasonCode,
                        itemLabelBuilder: (code) => applicationRejectionReasonLabel(loc, code),
                        hint: loc.hiringApplicationRejectReasonHint,
                        onChanged: notifier.setRejectionReasonCode,
                      ),
                      if (reasonError != null) ...[
                        Gap(4.h),
                        Text(
                          reasonError,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.error),
                        ),
                      ],
                      Gap(14.h),
                      DigifyTextArea(
                        labelText: loc.hiringApplicationRejectCommentsLabel,
                        hintText: loc.hiringApplicationRejectCommentsHint,
                        initialValue: state.rejectionComments,
                        onChanged: notifier.setRejectionComments,
                        maxLines: 4,
                        minLines: 3,
                      ),
                      Gap(14.h),
                      DigifyCheckbox(
                        value: state.sendEmail,
                        onChanged: (value) => notifier.setSendEmail(value ?? false),
                        label: loc.hiringApplicationRejectSendEmailLabel,
                      ),
                    ],
                  ),
                ),
                Gap(24.h),
                Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, bottomPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: loc.cancel,
                          type: AppButtonType.outline,
                          height: buttonHeight,
                          onPressed: state.isSubmitting ? null : () => context.pop(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          label: loc.hiringApplicationRejectButton,
                          type: AppButtonType.danger,
                          height: buttonHeight,
                          isLoading: state.isSubmitting,
                          onPressed: state.rejectionReasonCode == null || state.isSubmitting
                              ? null
                              : () => _onReject(context, ref),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
