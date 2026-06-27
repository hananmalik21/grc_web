import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/application/requisition/providers/create_job_posting_enterprise_provider.dart';
import 'package:grc/features/hiring/application/requisition/providers/create_job_posting_provider.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/presentation/models/requisition_table_row_data.dart';
import 'package:grc/features/hiring/presentation/widgets/requisition_detail/create_job_posting/create_job_posting_yn_flag_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CreateJobPostingDialog extends ConsumerStatefulWidget {
  const CreateJobPostingDialog({super.key, required this.row});

  final RequisitionTableRowData row;

  static Future<void> show(BuildContext context, {required RequisitionTableRowData row, int? enterpriseId}) {
    return showDialog(
      context: context,
      builder: (dialogContext) => ProviderScope(
        overrides: [if (enterpriseId != null) createJobPostingEnterpriseIdProvider.overrideWithValue(enterpriseId)],
        child: CreateJobPostingDialog(row: row),
      ),
    );
  }

  @override
  ConsumerState<CreateJobPostingDialog> createState() => _CreateJobPostingDialogState();
}

class _CreateJobPostingDialogState extends ConsumerState<CreateJobPostingDialog> {
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _aboutRoleController;
  late final TextEditingController _responsibilitiesController;
  late final TextEditingController _qualificationsController;

  String get _providerKey => widget.row.id;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _aboutRoleController = TextEditingController();
    _responsibilitiesController = TextEditingController();
    _qualificationsController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _aboutRoleController.dispose();
    _responsibilitiesController.dispose();
    _qualificationsController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    final notifier = ref.read(createJobPostingProvider(_providerKey).notifier);
    notifier.setPostingTitle(_titleController.text);
    notifier.setPostingDescription(_descriptionController.text);
    notifier.setAboutTheRole(_aboutRoleController.text);
    notifier.setResponsibilitiesText(_responsibilitiesController.text);
    notifier.setQualificationsText(_qualificationsController.text);

    final success = await notifier.submit();
    if (!mounted) return;

    final loc = AppLocalizations.of(context)!;
    if (success) {
      ToastService.success(context, loc.hiringRequisitionJobPostingCreateSuccess);
      context.pop();
      return;
    }

    final state = ref.read(createJobPostingProvider(_providerKey));
    final message = state.submitError ?? state.fieldErrors.values.firstOrNull ?? 'Please correct the form errors';
    ToastService.error(context, message);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final formState = ref.watch(createJobPostingProvider(_providerKey));
    final formNotifier = ref.read(createJobPostingProvider(_providerKey).notifier);

    return AppDialog(
      title: loc.hiringRequisitionJobPostingActionCreate,
      subtitle: widget.row.requisitionCode,
      width: 720.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyTextField(
            labelText: loc.hiringRequisitionJobPostingTitleLabel,
            controller: _titleController,
            hintText: loc.hiringRequisitionJobPostingTitleLabel,
            isRequired: true,
            readOnly: formState.isSubmitting,
            onChanged: formNotifier.setPostingTitle,
          ),
          Gap(16.h),
          DigifyTextArea(
            labelText: loc.hiringRequisitionJobPostingDescriptionLabel,
            controller: _descriptionController,
            hintText: loc.hiringRequisitionJobPostingDescriptionLabel,
            maxLines: 3,
            readOnly: formState.isSubmitting,
            onChanged: formNotifier.setPostingDescription,
          ),
          Gap(16.h),
          DigifyTextArea(
            labelText: loc.hiringRequisitionJobPostingAboutTheRoleLabel,
            controller: _aboutRoleController,
            hintText: loc.hiringRequisitionJobPostingAboutTheRoleLabel,
            maxLines: 3,
            readOnly: formState.isSubmitting,
            isRequired: true,
            onChanged: formNotifier.setAboutTheRole,
          ),
          Gap(16.h),
          DigifyTextArea(
            labelText: loc.hiringRequisitionJobPostingResponsibilitiesLabel,
            controller: _responsibilitiesController,
            hintText: loc.hiringRequisitionJobPostingResponsibilitiesHint,
            maxLines: 3,
            readOnly: formState.isSubmitting,
            isRequired: true,
            onChanged: formNotifier.setResponsibilitiesText,
          ),
          Gap(16.h),
          DigifyTextArea(
            labelText: loc.hiringRequisitionJobPostingQualificationsLabel,
            controller: _qualificationsController,
            hintText: loc.hiringRequisitionJobPostingQualificationsHint,
            maxLines: 3,
            readOnly: formState.isSubmitting,
            isRequired: true,
            onChanged: formNotifier.setQualificationsText,
          ),
          Gap(24.h),
          _sectionTitle(context, loc.hiringRequisitionJobPostingScheduleSection),
          Gap(16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DigifyDateField(
                  label: loc.hiringRequisitionJobPostingStartDateLabel,
                  isRequired: true,
                  hintText: 'dd/mm/yyyy',
                  initialDate: formState.startDate,
                  firstDate: HiringConfig.createRequisitionDatePickerFirstDate,
                  lastDate: HiringConfig.createRequisitionDatePickerLastDate,
                  onDateSelected: formNotifier.setStartDate,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifyDateField(
                  label: loc.hiringRequisitionJobPostingEndDateLabel,
                  isRequired: false,
                  hintText: 'dd/mm/yyyy',
                  initialDate: formState.endDate,
                  firstDate: formState.startDate ?? HiringConfig.createRequisitionDatePickerFirstDate,
                  lastDate: HiringConfig.createRequisitionDatePickerLastDate,
                  onDateSelected: formNotifier.setEndDate,
                  readOnly: formState.startDate == null || formState.isSubmitting,
                ),
              ),
            ],
          ),
          Gap(24.h),
          _sectionTitle(context, loc.hiringRequisitionJobPostingChannelsSection),
          Gap(16.h),
          CreateJobPostingYnFlagRow(
            label: loc.hiringRequisitionJobPostingChannelInternal,
            value: formState.internalSiteFlag,
            yesLabel: loc.hiringCommonYes,
            noLabel: loc.hiringCommonNo,
            enabled: !formState.isSubmitting,
            onChanged: formNotifier.setInternalSiteFlag,
          ),
          Gap(16.h),
          CreateJobPostingYnFlagRow(
            label: loc.hiringRequisitionJobPostingChannelExternal,
            value: formState.externalSiteFlag,
            yesLabel: loc.hiringCommonYes,
            noLabel: loc.hiringCommonNo,
            enabled: !formState.isSubmitting,
            onChanged: formNotifier.setExternalSiteFlag,
          ),
          Gap(16.h),
          CreateJobPostingYnFlagRow(
            label: loc.hiringRequisitionJobPostingChannelLinkedIn,
            value: formState.linkedinFlag,
            yesLabel: loc.hiringCommonYes,
            noLabel: loc.hiringCommonNo,
            enabled: !formState.isSubmitting,
            onChanged: formNotifier.setLinkedinFlag,
          ),
          Gap(16.h),
        ],
      ),
      actions: [
        AppButton.outline(label: loc.cancel, onPressed: formState.isSubmitting ? null : () => context.pop()),
        SizedBox(width: 12.w),
        AppButton.primary(
          label: loc.create,
          isLoading: formState.isSubmitting,
          onPressed: formState.isSubmitting ? null : _onSubmit,
        ),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: context.textTheme.headlineSmall?.copyWith(
        color: context.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
    );
  }
}
