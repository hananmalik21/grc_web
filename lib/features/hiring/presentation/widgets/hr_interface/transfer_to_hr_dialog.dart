import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/common/digify_status_dot.dart';
import 'package:grc/features/hiring/domain/models/offer.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TransferToHrDialog extends StatefulWidget {
  const TransferToHrDialog({required this.offer, super.key});

  final Offer offer;

  static Future<void> show(BuildContext context, Offer offer) {
    return showDialog<void>(
      context: context,
      builder: (context) => TransferToHrDialog(offer: offer),
    );
  }

  @override
  State<TransferToHrDialog> createState() => _TransferToHrDialogState();
}

class _TransferToHrDialogState extends State<TransferToHrDialog> {
  static const _departmentOptions = [
    'HR Onboarding Team',
    'People Operations',
    'HR Business Partners',
    'Recruitment Team',
  ];

  final TextEditingController _notesController = TextEditingController();

  late String _selectedDepartment;
  bool _sendNotification = true;
  bool _triggerWorkflow = true;

  @override
  void initState() {
    super.initState();
    _selectedDepartment = _departmentOptions.first;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    final cardFillColor = isDark ? AppColors.cardBackgroundDark : AppColors.sidebarSearchBg;
    final inputFillColor = isDark ? AppColors.inputBgDark : Colors.white;

    return AppDialog(
      title: l10n.hiringHrInterfaceTransferToHr,
      width: 500.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(color: cardFillColor, borderRadius: BorderRadius.circular(10.r)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transferring Employee',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                Gap(4.h),
                Text(
                  widget.offer.candidateName,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    fontSize: 18.sp,
                  ),
                ),
                Gap(2.h),
                Text(
                  widget.offer.position,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                Gap(2.h),
                Text(
                  'Start Date: ${widget.offer.startDate}',
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Gap(16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(17.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transfer Details',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.infoTextDark : AppColors.infoText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(8.h),
                _BulletText(
                  text: 'Employee will be created as "Pending" status in HR system',
                  color: isDark ? AppColors.infoTextDark : AppColors.roleActionBlue,
                ),
                _BulletText(
                  text: 'All offer details will be synced to employee profile',
                  color: isDark ? AppColors.infoTextDark : AppColors.roleActionBlue,
                ),
                _BulletText(
                  text: 'HR department will be notified via email',
                  color: isDark ? AppColors.infoTextDark : AppColors.roleActionBlue,
                ),
                _BulletText(
                  text: 'Onboarding workflow will be triggered automatically',
                  color: isDark ? AppColors.infoTextDark : AppColors.roleActionBlue,
                ),
              ],
            ),
          ),
          Gap(16.h),
          DigifySelectFieldWithLabel<String>(
            label: 'HR Department Contact',
            value: _selectedDepartment,
            items: _departmentOptions,
            itemLabelBuilder: (item) => item,
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedDepartment = value);
              }
            },
            fillColor: inputFillColor,
          ),
          Gap(16.h),
          DigifyTextArea(
            labelText: 'Transfer Notes (Optional)',
            hintText: 'Add any special instructions or notes for HR department...',
            controller: _notesController,
            maxLines: 4,
            minLines: 4,
            fillColor: inputFillColor,
          ),
          Gap(16.h),
          DigifyCheckbox(
            value: _sendNotification,
            onChanged: (value) => setState(() => _sendNotification = value ?? false),
            label: 'Send notification email to HR department',
          ),
          Gap(12.h),
          DigifyCheckbox(
            value: _triggerWorkflow,
            onChanged: (value) => setState(() => _triggerWorkflow = value ?? false),
            label: 'Trigger onboarding workflow automatically',
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: l10n.cancel, onPressed: () => context.pop()),
        Gap(8.w),
        AppButton(
          label: 'Confirm Transfer',
          type: AppButtonType.primary,
          onPressed: () => context.pop(),
          backgroundColor: AppColors.shiftEditButtonText,
          svgPath: Assets.icons.sendEmailPurple.path,
          svgAssetColor: Colors.white,
        ),
      ],
    );
  }
}

class _BulletText extends StatelessWidget {
  const _BulletText({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DigifyStatusDot(color: color, size: 3.w),
          Gap(8.w),
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodyMedium?.copyWith(color: color, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
