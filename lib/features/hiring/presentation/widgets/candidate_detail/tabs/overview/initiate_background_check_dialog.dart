import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/common/digify_radio.dart';
import 'package:grc/core/widgets/common/info_guidelines_box.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/application/candidates/providers/initiate_background_check_provider.dart';
import 'package:grc/features/hiring/application/candidates/states/initiate_background_check_state.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class InitiateBackgroundCheckDialog extends ConsumerStatefulWidget {
  const InitiateBackgroundCheckDialog({super.key, required this.candidate});

  final CandidateData candidate;

  static Future<void> show(BuildContext context, CandidateData candidate) {
    return showDialog(
      context: context,
      builder: (context) => InitiateBackgroundCheckDialog(candidate: candidate),
    );
  }

  @override
  ConsumerState<InitiateBackgroundCheckDialog> createState() => _InitiateBackgroundCheckDialogState();
}

class _InitiateBackgroundCheckDialogState extends ConsumerState<InitiateBackgroundCheckDialog> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    ref.read(initiateBackgroundCheckProvider(widget.candidate.id).notifier).setAdditionalNotes(_notesController.text);

    final success = await ref.read(initiateBackgroundCheckProvider(widget.candidate.id).notifier).submit();

    if (!mounted) return;

    if (success) {
      ToastService.success(context, 'Background check initiated successfully');
      context.pop();
    } else {
      final state = ref.read(initiateBackgroundCheckProvider(widget.candidate.id));
      final message = state.submitError ?? state.fieldErrors.values.firstOrNull ?? 'Please correct the form errors';
      ToastService.error(context, message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final formState = ref.watch(initiateBackgroundCheckProvider(widget.candidate.id));
    final formNotifier = ref.read(initiateBackgroundCheckProvider(widget.candidate.id).notifier);
    return AppDialog(
      title: 'Initiate Background Check',
      width: 650.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark : AppColors.infoBg,
              border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Text(
                  'Candidate: ',
                  style: context.textTheme.labelLarge?.copyWith(
                    fontSize: 14.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.infoText,
                  ),
                ),
                Text(
                  widget.candidate.name,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.infoText,
                  ),
                ),
              ],
            ),
          ),
          Gap(24.h),
          InfoGuidelinesBox(
            title: 'Important Notice',
            messages: const [
              'Ensure you have obtained written consent from the candidate before initiating a background check. Background checks must comply with FCRA and local regulations.',
            ],
            iconAssetPath: Assets.icons.infoCircleBlue.path,
            backgroundColor: AppColors.alertMediumBg,
            borderColor: AppColors.warningBorder,
            iconBackgroundColor: Colors.transparent,
            iconColor: AppColors.infoIconColor,
            titleColor: AppColors.yellowText,
            messageColor: AppColors.yellowText,
          ),
          Gap(24.h),
          DigifySelectFieldWithLabel<String>(
            label: 'Provider',
            items: const ['CheckrPro', 'FirstAdvantage', 'Sterling'],
            itemLabelBuilder: (item) => item,
            value: formState.provider,
            onChanged: formState.isSubmitting
                ? null
                : (val) {
                    if (val != null) formNotifier.setProvider(val);
                  },
          ),
          Gap(24.h),
          _buildSectionTitle('Check Type'),
          Gap(12.h),
          Row(
            children: [
              Expanded(
                child: _buildCheckTypeCard(
                  title: 'Standard Check',
                  subtitle: 'Employment, Education, Criminal',
                  duration: '5-7 business days',
                  checkType: BackgroundCheckType.standard,
                  formState: formState,
                  onSelect: formNotifier.setCheckType,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: _buildCheckTypeCard(
                  title: 'Comprehensive Check',
                  subtitle: 'All checks + Credit & References',
                  duration: '7-10 business days',
                  checkType: BackgroundCheckType.comprehensive,
                  formState: formState,
                  onSelect: formNotifier.setCheckType,
                ),
              ),
            ],
          ),
          Gap(24.h),
          _buildSectionTitle('Check Components'),
          Gap(12.h),
          _buildComponentItem(
            component: BackgroundCheckComponent.employment,
            title: 'Employment Verification',
            subtitle: 'Verify past employment history',
            formState: formState,
            onToggle: formNotifier.toggleComponent,
          ),
          Gap(12.h),
          _buildComponentItem(
            component: BackgroundCheckComponent.education,
            title: 'Education Verification',
            subtitle: 'Verify degrees and certifications',
            formState: formState,
            onToggle: formNotifier.toggleComponent,
          ),
          Gap(12.h),
          _buildComponentItem(
            component: BackgroundCheckComponent.criminal,
            title: 'Criminal Records',
            subtitle: 'County, state, and federal criminal search',
            formState: formState,
            onToggle: formNotifier.toggleComponent,
          ),
          Gap(12.h),
          _buildComponentItem(
            component: BackgroundCheckComponent.credit,
            title: 'Credit Check',
            subtitle: 'Credit history and financial responsibility',
            formState: formState,
            onToggle: formNotifier.toggleComponent,
          ),
          Gap(12.h),
          _buildComponentItem(
            component: BackgroundCheckComponent.drug,
            title: 'Drug Testing',
            subtitle: 'Standard 5-panel or 10-panel drug screening',
            formState: formState,
            onToggle: formNotifier.toggleComponent,
          ),
          if (formState.fieldErrors['components'] != null) ...[
            Gap(8.h),
            Text(
              formState.fieldErrors['components']!,
              style: context.textTheme.bodySmall?.copyWith(color: AppColors.error),
            ),
          ],
          Gap(24.h),
          DigifySelectFieldWithLabel<String>(
            label: 'Priority',
            hint: 'Select priority',
            isRequired: true,
            value: formState.priority,
            items: HiringConfig.backgroundCheckPriorityOptions,
            itemLabelBuilder: HiringConfig.backgroundCheckPriorityLabel,
            onChanged: formState.isSubmitting ? null : formNotifier.setPriority,
          ),
          if (formState.fieldErrors['priority'] != null) ...[
            Gap(8.h),
            Text(
              formState.fieldErrors['priority']!,
              style: context.textTheme.bodySmall?.copyWith(color: AppColors.error),
            ),
          ],
          Gap(24.h),
          DigifyTextArea(
            labelText: 'Additional Notes',
            controller: _notesController,
            hintText: 'Any special instructions or requirements...',
            maxLines: 4,
            readOnly: formState.isSubmitting,
          ),
        ],
      ),
      actions: [
        AppButton.outline(label: 'Cancel', onPressed: formState.isSubmitting ? null : () => context.pop()),
        SizedBox(width: 12.w),
        AppButton.primary(
          label: 'Initiate Background Check',
          isLoading: formState.isSubmitting,
          onPressed: formState.isSubmitting ? null : _onSubmit,
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: context.textTheme.headlineSmall?.copyWith(
        color: context.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
    );
  }

  Widget _buildCheckTypeCard({
    required String title,
    required String subtitle,
    required String duration,
    required BackgroundCheckType checkType,
    required InitiateBackgroundCheckState formState,
    required void Function(BackgroundCheckType) onSelect,
  }) {
    final isSelected = formState.checkType == checkType;
    final isDark = context.isDark;

    return GestureDetector(
      onTap: formState.isSubmitting ? null : () => onSelect(checkType),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyRadio<BackgroundCheckType>(
              value: checkType,
              groupValue: formState.checkType,
              onChanged: formState.isSubmitting
                  ? null
                  : (val) {
                      if (val != null) onSelect(val);
                    },
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.titleMedium?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    subtitle,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                  Gap(4.h),
                  Text(
                    duration,
                    style: context.textTheme.titleSmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentItem({
    required BackgroundCheckComponent component,
    required String title,
    required String subtitle,
    required InitiateBackgroundCheckState formState,
    required void Function(BackgroundCheckComponent, bool) onToggle,
  }) {
    final isSelected = formState.isComponentSelected(component);
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          DigifyCheckbox(
            value: isSelected,
            onChanged: formState.isSubmitting ? null : (val) => onToggle(component, val == true),
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontSize: 15.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
