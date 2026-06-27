import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/employee_search_field.dart';
import 'package:grc/features/hiring/application/candidates/schedule_interview_mode_rules.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/create_requisition_rec_lookup_select_field.dart';
import 'package:grc/features/hiring/presentation/widgets/schedule_interview/edit_interview_form_binding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class UpdateInterviewFormBody extends ConsumerWidget {
  const UpdateInterviewFormBody({super.key, required this.binding, required this.notesController});

  final EditInterviewFormBinding binding;
  final TextEditingController notesController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final loc = AppLocalizations.of(context)!;
    final formState = ref.watch(binding.formStateProvider);
    final formNotifier = binding.readActions(ref);
    final enterpriseId = ref.watch(binding.enterpriseIdProvider);
    final typeLookups = ref.watch(binding.typeLookupsProvider).valueOrNull ?? const [];
    final interviewModeCode = ref.watch(binding.formStateProvider.select((s) => s.interviewModeCode));
    final meetingLink = ref.watch(binding.formStateProvider.select((s) => s.meetingLink));
    final showMeetingLink = ScheduleInterviewModeRules.requiresMeetingLink(interviewModeCode);

    return Column(
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
                formState.candidateName,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.infoText,
                ),
              ),
            ],
          ),
        ),
        Gap(24.h),
        _SectionTitle(title: 'Interview Details'),
        Gap(16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CreateRequisitionRecLookupSelectField(
                label: 'Interview Type',
                hint: 'Select interview type',
                selectedKey: formState.interviewTypeCode,
                lookups: typeLookups,
                onChanged: formNotifier.setInterviewType,
              ),
            ),
            Gap(16.w),
            Expanded(
              child: DigifySelectFieldWithLabel<String>(
                label: 'Interview Round',
                hint: 'Select round',
                items: HiringConfig.scheduleInterviewRoundCodes,
                itemLabelBuilder: HiringConfig.scheduleInterviewRoundLabel,
                value: formState.interviewRound,
                onChanged: (val) {
                  if (val != null) formNotifier.setInterviewRound(val);
                },
              ),
            ),
          ],
        ),
        Gap(24.h),
        _SectionTitle(title: 'Schedule'),
        Gap(16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: DigifyDateField(
                label: 'Date',
                isRequired: false,
                hintText: 'dd/mm/yyyy',
                initialDate: formState.interviewDate,
                firstDate: HiringConfig.candidateFormDatePickerFirstDate,
                lastDate: HiringConfig.candidateFormDatePickerLastDate,
                onDateSelected: formNotifier.setInterviewDate,
              ),
            ),
            Gap(16.w),
            Expanded(
              child: DigifyTimePickerField(
                label: 'Start Time',
                isRequired: false,
                hintText: '--:--',
                value: formState.startTime,
                onTimeSelected: formNotifier.setStartTime,
              ),
            ),
            Gap(16.w),
            Expanded(
              child: DigifyTimePickerField(
                label: 'End Time',
                isRequired: false,
                hintText: '--:--',
                value: formState.endTime,
                onTimeSelected: formNotifier.setEndTime,
              ),
            ),
          ],
        ),
        Gap(24.h),
        _SectionTitle(title: 'Interview Mode'),
        Gap(16.h),
        DigifySelectFieldWithLabel<String>(
          label: 'Interview Mode',
          hint: 'Select interview mode',
          items: HiringConfig.scheduleInterviewModeCodes,
          itemLabelBuilder: HiringConfig.scheduleInterviewModeLabel,
          value: formState.interviewModeCode,
          onChanged: formNotifier.setInterviewMode,
        ),
        if (showMeetingLink) ...[
          Gap(16.h),
          DigifyTextField(
            key: ValueKey(interviewModeCode),
            labelText: 'Meeting Link',
            initialValue: meetingLink,
            hintText: 'https://meet.company.com/...',
            onChanged: formNotifier.setMeetingLink,
          ),
        ],
        Gap(24.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _SectionTitle(title: 'Interviewers'),
            AppButton.primary(label: 'Add Interviewer', onPressed: formNotifier.addInterviewerSlot),
          ],
        ),
        Gap(16.h),
        if (enterpriseId == null || enterpriseId <= 0)
          Text(
            'Select an enterprise to search for interviewers',
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          )
        else
          ...formState.interviewers.asMap().entries.map((entry) {
            final index = entry.key;
            final member = entry.value;
            final label = formState.interviewers.length == 1 ? 'Select Interviewer' : 'Interviewer ${index + 1}';

            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: EmployeeSearchField(
                      label: label,
                      enterpriseId: enterpriseId,
                      selectedEmployee: member,
                      hintText: loc.typeToSearchEmployees,
                      onEmployeeSelected: (employee) => formNotifier.setInterviewer(index, employee),
                      fillColor: Colors.transparent,
                    ),
                  ),
                  if (formState.interviewers.length > 1 || member != null)
                    Padding(
                      padding: EdgeInsetsDirectional.only(top: 28.h),
                      child: IconButton(
                        icon: Icon(Icons.delete_outline, color: AppColors.error, size: 20.w),
                        onPressed: () => formNotifier.removeInterviewerSlot(index),
                      ),
                    ),
                ],
              ),
            );
          }),
        Gap(24.h),
        DigifyTextArea(
          labelText: 'Additional Notes',
          controller: notesController,
          hintText: 'Any special instructions or topics to cover...',
          maxLines: 4,
          onChanged: formNotifier.setAdditionalNotes,
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: context.textTheme.headlineSmall?.copyWith(
        color: context.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
      ),
    );
  }
}
