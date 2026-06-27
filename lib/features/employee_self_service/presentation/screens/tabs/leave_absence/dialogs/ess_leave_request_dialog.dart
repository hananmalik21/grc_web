import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/employee_self_service/presentation/providers/leave_absence/ess_leave_request_dialog_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class EssLeaveRequestDialog extends ConsumerWidget {
  const EssLeaveRequestDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(context: context, barrierDismissible: false, builder: (_) => const EssLeaveRequestDialog());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(essLeaveRequestDialogProvider);
    final notifier = ref.read(essLeaveRequestDialogProvider.notifier);

    return AppDialog(
      width: 620,
      title: 'New Leave Request',
      subtitle: 'Fill in the details below',
      onClose: () {
        notifier.reset();
        context.pop();
      },
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifySelectWithLabel<String>(
            label: 'Leave Type',
            isRequired: true,
            value: state.leaveType,
            items: EssLeaveRequestDialogNotifier.leaveTypes,
            itemLabelBuilder: (item) => item,
            hint: 'Select leave type',
            onChanged: notifier.setLeaveType,
            fillColor: AppColors.cardBackground,
          ),
          Gap(18.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final isStacked = constraints.maxWidth < 420;
              final startField = Expanded(
                child: DigifyDateField(
                  label: 'Start Date',
                  hintText: 'dd/mm/yyyy',
                  initialDate: state.startDate,
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2030),
                  onDateSelected: notifier.setStartDate,
                ),
              );
              final endField = Expanded(
                child: DigifyDateField(
                  label: 'End Date',
                  hintText: state.startDate == null ? 'Select start date first' : 'dd/mm/yyyy',
                  initialDate: state.endDate,
                  firstDate: state.startDate,
                  lastDate: DateTime(2030),
                  readOnly: state.startDate == null,
                  onDateSelected: notifier.setEndDate,
                ),
              );

              if (isStacked) {
                return Column(children: [startField, Gap(16.h), endField]);
              }

              return Row(children: [startField, Gap(12.w), endField]);
            },
          ),
          Gap(18.h),
          DigifyTextArea(
            labelText: 'Reason',
            isRequired: true,
            hintText: 'Please provide a reason for your leave request...',
            controller: TextEditingController(text: state.reason)
              ..selection = TextSelection.collapsed(offset: state.reason.length),
            onChanged: notifier.setReason,
            maxLines: 5,
            minLines: 5,
            fillColor: AppColors.cardBackground,
          ),
          Gap(18.h),
          Text(
            'Attachments (Optional)',
            style: context.textTheme.labelMedium?.copyWith(
              color: context.isDark ? AppColors.textSecondaryDark : AppColors.inputLabel,
              fontWeight: FontWeight.w500,
              fontSize: 13.sp,
            ),
          ),
          Gap(8.h),
          _AttachmentDropzone(
            attachments: state.attachments,
            onAddAttachment: () {
              notifier.addMockAttachment();
              ToastService.info(context, 'Attachment picker is not connected yet. Added a sample file.');
            },
            onRemoveAttachment: notifier.removeAttachment,
          ),
        ],
      ),
      actions: [
        AppButton.outline(
          label: 'Cancel',
          onPressed: () {
            notifier.reset();
            context.pop();
          },
        ),
        Gap(10.w),
        AppButton.primary(
          label: 'Submit Request',
          onPressed: state.isSubmitting
              ? null
              : () {
                  if (!notifier.validate()) {
                    ToastService.warning(
                      context,
                      ref.read(essLeaveRequestDialogProvider).validationMessage ??
                          'Please complete all required fields.',
                    );
                    return;
                  }

                  ToastService.success(context, 'ESS leave request submission is ready for backend integration.');
                  notifier.reset();
                  context.pop();
                },
        ),
      ],
    );
  }
}

class _AttachmentDropzone extends StatelessWidget {
  const _AttachmentDropzone({
    required this.attachments,
    required this.onAddAttachment,
    required this.onRemoveAttachment,
  });

  final List<String> attachments;
  final VoidCallback onAddAttachment;
  final ValueChanged<String> onRemoveAttachment;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.borderGrey;

    return InkWell(
      onTap: onAddAttachment,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderColor, width: 1.5.w, strokeAlign: BorderSide.strokeAlignInside),
          color: AppColors.cardBackground,
        ),
        child: Column(
          children: [
            DigifyAsset(
              assetPath: Assets.icons.uploadDropIcon.path,
              width: 30,
              height: 30,
              color: isDark ? AppColors.textSecondaryDark : AppColors.sidebarCategoryText,
            ),
            Gap(12.h),
            Text(
              'Click to upload or drag and drop',
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
            Gap(2.h),
            Text(
              'PDF, DOC, or image files (max 5MB)',
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
              ),
            ),
            if (attachments.isNotEmpty) ...[
              Gap(14.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: attachments
                    .map(
                      (file) => Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarSearchBg,
                          borderRadius: BorderRadius.circular(999.r),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              file,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                              ),
                            ),
                            Gap(6.w),
                            InkWell(
                              onTap: () => onRemoveAttachment(file),
                              child: Icon(Icons.close, size: 14.sp, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
