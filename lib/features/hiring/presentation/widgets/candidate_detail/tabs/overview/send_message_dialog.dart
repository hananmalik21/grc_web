import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_status_dot.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SendMessageDialog extends StatefulWidget {
  final CandidateData candidate;

  const SendMessageDialog({super.key, required this.candidate});

  static Future<void> show(BuildContext context, CandidateData candidate) {
    return showDialog(
      context: context,
      builder: (context) => SendMessageDialog(candidate: candidate),
    );
  }

  @override
  State<SendMessageDialog> createState() => _SendMessageDialogState();
}

class _SendMessageDialogState extends State<SendMessageDialog> {
  String _selectedMessageType = 'Email';
  String _selectedTemplate = 'Blank Message';

  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return AppDialog(
      title: 'Send Message',
      width: 600.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'To',
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              Gap(4.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                ),
                child: Row(
                  children: [
                    Text(
                      widget.candidate.name,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                    Gap(8.w),
                    DigifyStatusDot(color: AppColors.textSecondary, size: 3.r),
                    Gap(8.w),
                    Text(
                      widget.candidate.email,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(24.h),

          DigifySelectFieldWithLabel<String>(
            label: 'Message Type',
            isRequired: true,
            items: const ['Email', 'SMS', 'WhatsApp'],
            itemLabelBuilder: (item) => item,
            value: _selectedMessageType,
            onChanged: (val) => setState(() => _selectedMessageType = val!),
          ),
          Gap(20.h),

          DigifySelectFieldWithLabel<String>(
            label: 'Template (Optional)',
            items: const ['Blank Message', 'Interview Invitation', 'Rejection', 'Offer Letter'],
            itemLabelBuilder: (item) => item,
            value: _selectedTemplate,
            onChanged: (val) => setState(() => _selectedTemplate = val!),
          ),
          Gap(20.h),

          DigifyTextField(
            labelText: 'Subject',
            isRequired: true,
            controller: _subjectController,
            hintText: 'Enter subject line',
          ),
          Gap(20.h),

          DigifyTextArea(
            labelText: 'Message',
            isRequired: true,
            controller: _messageController,
            hintText: 'Type your message here...',
            maxLines: 8,
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Cancel', onPressed: () => context.pop()),
        SizedBox(width: 12.w),
        AppButton.primary(
          label: 'Send Message',
          svgPath: Assets.icons.sendEmailPurple.path,
          onPressed: () {
            context.pop();
          },
        ),
      ],
    );
  }
}
