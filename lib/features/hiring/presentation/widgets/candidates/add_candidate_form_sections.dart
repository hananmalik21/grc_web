import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_phone_field.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/hiring/application/candidates/providers/create_candidate_lookups_provider.dart';
import 'package:grc/features/hiring/application/candidates/providers/create_candidate_provider.dart';
import 'package:grc/features/hiring/application/candidates/states/create_candidate_state.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/create_requisition_rec_lookup_select_field.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/add_candidate_education_dialog.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/add_candidate_work_experience_dialog.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/dashed_border.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

Widget candidateSectionTitle(BuildContext context, String title) {
  final isDark = context.isDark;
  return Text(
    title,
    style: context.textTheme.titleLarge?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
  );
}

class CandidatePersonalSection extends StatelessWidget {
  const CandidatePersonalSection({
    super.key,
    required this.firstNameController,
    required this.middleNameController,
    required this.lastNameController,
    this.singleColumn = false,
  });

  final TextEditingController firstNameController;
  final TextEditingController middleNameController;
  final TextEditingController lastNameController;
  final bool singleColumn;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        candidateSectionTitle(context, loc.personalInformation),
        Gap(12.h),
        if (singleColumn) ...[
          DigifyTextField(
            labelText: loc.firstName,
            isRequired: true,
            controller: firstNameController,
            hintText: loc.hintFirstName,
          ),
          Gap(12.h),
          DigifyTextField(labelText: loc.middleName, controller: middleNameController, hintText: loc.hintMiddleName),
          Gap(12.h),
          DigifyTextField(
            labelText: loc.lastName,
            isRequired: true,
            controller: lastNameController,
            hintText: loc.hintLastName,
          ),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DigifyTextField(
                  labelText: loc.firstName,
                  isRequired: true,
                  controller: firstNameController,
                  hintText: loc.hintFirstName,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: DigifyTextField(
                  labelText: loc.middleName,
                  controller: middleNameController,
                  hintText: loc.hintMiddleName,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: DigifyTextField(
                  labelText: loc.lastName,
                  isRequired: true,
                  controller: lastNameController,
                  hintText: loc.hintLastName,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class CandidateContactSection extends ConsumerWidget {
  const CandidateContactSection({
    super.key,
    required this.emailController,
    required this.state,
    this.singleColumn = false,
  });

  final TextEditingController emailController;
  final CreateCandidateState state;
  final bool singleColumn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;

    final phoneField = DigifyPhoneField(
      labelText: loc.phone,
      hintText: loc.hintMobileNumber,
      initialDialCode: state.phoneDialCode,
      initialNumber: state.phoneNumber,
      isRequired: true,
      onDialCodeChanged: (dialCode) {
        ref.read(createCandidateProvider.notifier).setPhoneDialCode(dialCode);
      },
      onNumberChanged: (number) {
        ref.read(createCandidateProvider.notifier).setPhoneNumber(number ?? '');
      },
    );

    final emailField = DigifyTextField(
      labelText: loc.email,
      isRequired: true,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      hintText: 'e.g. alex.martinez@email.com',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        candidateSectionTitle(context, loc.contactInformation),
        Gap(12.h),
        if (singleColumn) ...[
          emailField,
          Gap(12.h),
          phoneField,
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: emailField),
              Gap(12.w),
              Expanded(child: phoneField),
            ],
          ),
        ],
      ],
    );
  }
}

class CandidateProfessionalSection extends StatelessWidget {
  const CandidateProfessionalSection({
    super.key,
    required this.currentTitleController,
    required this.currentEmployerController,
    required this.yearsOfExperienceController,
    required this.currentLocationController,
    this.singleColumn = false,
  });

  final TextEditingController currentTitleController;
  final TextEditingController currentEmployerController;
  final TextEditingController yearsOfExperienceController;
  final TextEditingController currentLocationController;
  final bool singleColumn;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        candidateSectionTitle(context, loc.professionalInformation),
        Gap(12.h),
        if (singleColumn) ...[
          DigifyTextField(
            labelText: loc.currentTitle,
            controller: currentTitleController,
            hintText: 'e.g. Software Engineer',
          ),
          Gap(12.h),
          DigifyTextField(
            labelText: loc.currentEmployer,
            controller: currentEmployerController,
            hintText: 'e.g. Tech Corp',
          ),
          Gap(12.h),
          DigifyTextField.number(
            labelText: loc.yearsOfExperience,
            controller: yearsOfExperienceController,
            isRequired: false,
            hintText: 'e.g. 5',
          ),
          Gap(12.h),
          DigifyTextField(
            labelText: loc.currentLocation,
            controller: currentLocationController,
            hintText: 'e.g. San Francisco, CA',
          ),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DigifyTextField(
                  labelText: loc.currentTitle,
                  controller: currentTitleController,
                  hintText: 'e.g. Software Engineer',
                ),
              ),
              Gap(12.w),
              Expanded(
                child: DigifyTextField(
                  labelText: loc.currentEmployer,
                  controller: currentEmployerController,
                  hintText: 'e.g. Tech Corp',
                ),
              ),
            ],
          ),
          Gap(12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: DigifyTextField.number(
                  labelText: loc.yearsOfExperience,
                  controller: yearsOfExperienceController,
                  isRequired: false,
                  hintText: 'e.g. 5',
                ),
              ),
              Gap(12.w),
              Expanded(
                child: DigifyTextField(
                  labelText: loc.currentLocation,
                  controller: currentLocationController,
                  hintText: 'e.g. San Francisco, CA',
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class CandidateAdditionalSection extends ConsumerWidget {
  const CandidateAdditionalSection({
    super.key,
    required this.expectedSalaryController,
    required this.linkedinProfileController,
    required this.state,
    required this.dropdownFillColor,
    this.singleColumn = false,
  });

  final TextEditingController expectedSalaryController;
  final TextEditingController linkedinProfileController;
  final CreateCandidateState state;
  final Color dropdownFillColor;
  final bool singleColumn;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;

    final sourceLookups = ref.watch(createCandidateSourceLookupValuesProvider).valueOrNull ?? const [];

    final sourceField = CreateRequisitionRecLookupSelectField(
      label: 'Source',
      isRequired: true,
      hint: 'Select source',
      selectedKey: state.source,
      lookups: sourceLookups,
      fillColor: dropdownFillColor,
      onChanged: (value) => ref.read(createCandidateProvider.notifier).setSource(value),
    );

    final salaryField = DigifyTextField.number(
      labelText: 'Expected Salary (${state.salaryCurrency ?? ''})',
      controller: expectedSalaryController,
      isRequired: false,
      hintText: 'e.g. 120000',
    );

    final currencyLookups = ref.watch(createCandidateCurrencyLookupValuesProvider).valueOrNull ?? const [];

    final currencyField = CreateRequisitionRecLookupSelectField(
      label: loc.currency,
      hint: loc.hiringCreateRequisitionCurrencyHint,
      selectedKey: state.salaryCurrency,
      lookups: currencyLookups,
      fillColor: dropdownFillColor,
      onChanged: (value) => ref.read(createCandidateProvider.notifier).setSalaryCurrency(value),
    );

    final noticePeriodField = DigifySelectFieldWithLabel<String>(
      label: loc.noticePeriod,
      value: state.noticePeriod,
      items: HiringConfig.noticePeriodOptions,
      itemLabelBuilder: (item) => item,
      hint: 'Select notice period',
      fillColor: dropdownFillColor,
      onChanged: (value) {
        if (value != null) ref.read(createCandidateProvider.notifier).setNoticePeriod(value);
      },
    );

    final linkedinField = DigifyTextField(
      labelText: loc.linkedinProfile,
      controller: linkedinProfileController,
      hintText: 'linkedin.com/in/username',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        candidateSectionTitle(context, 'Additional Information'),
        Gap(12.h),
        if (singleColumn) ...[
          sourceField,
          Gap(12.h),
          salaryField,
          Gap(12.h),
          currencyField,
          Gap(12.h),
          noticePeriodField,
          Gap(12.h),
          linkedinField,
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: sourceField),
              Gap(12.w),
              Expanded(child: salaryField),
            ],
          ),
          Gap(12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: currencyField),
              Gap(12.w),
              Expanded(child: noticePeriodField),
            ],
          ),
          Gap(12.h),
          linkedinField,
        ],
      ],
    );
  }
}

class CandidateResumeSection extends StatelessWidget {
  const CandidateResumeSection({
    super.key,
    required this.state,
    required this.onPickResume,
    this.uploadLabel = 'Drop resume here or click to upload',
  });

  final CreateCandidateState state;
  final VoidCallback onPickResume;
  final String uploadLabel;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        candidateSectionTitle(context, 'Resume'),
        Gap(12.h),
        InkWell(
          onTap: onPickResume,
          borderRadius: BorderRadius.circular(10.r),
          child: DashedBorder(
            color: isDark ? AppColors.borderGreyDark : AppColors.borderGrey,
            strokeWidth: 1.5.w,
            dashLength: 6.r,
            gapLength: 4.r,
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
              child: Column(
                children: [
                  DigifyAsset(
                    assetPath: Assets.icons.uploadDropIcon.path,
                    width: 40.w,
                    height: 40.w,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                  Gap(8.h),
                  Text(
                    state.displayResumeFileName ?? uploadLabel,
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: state.displayResumeFileName != null
                          ? (isDark ? AppColors.successTextDark : AppColors.success)
                          : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                      fontWeight: state.displayResumeFileName != null ? FontWeight.w500 : FontWeight.w400,
                    ),
                  ),
                  Gap(12.h),
                  AppButton.outline(
                    label: state.displayResumeFileName != null ? 'Change File' : 'Choose File',
                    onPressed: onPickResume,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CandidateFormListItem {
  const CandidateFormListItem({required this.id, required this.title, required this.subtitle});

  final String id;
  final String title;
  final String subtitle;
}

class CandidateFormOptionalSection extends StatelessWidget {
  const CandidateFormOptionalSection({
    super.key,
    required this.title,
    required this.iconPath,
    required this.buttonLabel,
    required this.buttonIconPath,
    required this.emptyStateMessage,
    required this.onAddPressed,
    this.items = const [],
    this.onEditItem,
    this.onRemoveItem,
  });

  final String title;
  final String iconPath;
  final String buttonLabel;
  final String buttonIconPath;
  final String emptyStateMessage;
  final VoidCallback onAddPressed;
  final List<CandidateFormListItem> items;
  final ValueChanged<String>? onEditItem;
  final ValueChanged<String>? onRemoveItem;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textStyle = context.textTheme.titleLarge?.copyWith(
      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DigifyAsset(assetPath: iconPath, color: AppColors.primary, width: 20.w, height: 20.w),
            Gap(8.w),
            Expanded(
              child: Text(title, style: textStyle, overflow: TextOverflow.ellipsis),
            ),
            Gap(8.w),
            AppButton.outline(label: buttonLabel, svgPath: buttonIconPath, onPressed: onAddPressed),
          ],
        ),
        Gap(12.h),
        if (items.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.inputBgDark : AppColors.sidebarSearchBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: Text(
                emptyStateMessage,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        else
          Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                if (i > 0) Gap(8.h),
                _CandidateFormListItemTile(
                  item: items[i],
                  isDark: isDark,
                  onEdit: onEditItem != null ? () => onEditItem!(items[i].id) : null,
                  onRemove: onRemoveItem != null ? () => onRemoveItem!(items[i].id) : null,
                ),
              ],
            ],
          ),
      ],
    );
  }
}

class _CandidateFormListItemTile extends StatelessWidget {
  const _CandidateFormListItemTile({required this.item, required this.isDark, this.onEdit, this.onRemove});

  final CandidateFormListItem item;
  final bool isDark;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputBgDark : AppColors.sidebarSearchBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(4.h),
                Text(
                  item.subtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null) ActionButtonWidget(type: ActionButtonType.edit, onTap: onEdit),
          if (onRemove != null) ActionButtonWidget(type: ActionButtonType.delete, onTap: onRemove),
        ],
      ),
    );
  }
}

class CandidateEducationOptionalSection extends ConsumerWidget {
  const CandidateEducationOptionalSection({super.key});

  Future<void> _openEducationDialog(BuildContext context, WidgetRef ref, {String? editId}) async {
    final notifier = ref.read(createCandidateProvider.notifier);
    final state = ref.read(createCandidateProvider);
    final initial = editId == null ? null : state.educationEntries.where((e) => e.id == editId).firstOrNull;

    final result = await AddCandidateEducationDialog.show(context, initialEntry: initial);
    if (result == null || !context.mounted) return;

    if (editId != null) {
      notifier.updateEducation(result);
    } else {
      notifier.addEducation(result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createCandidateProvider);

    return CandidateFormOptionalSection(
      title: 'Education (Optional)',
      iconPath: Assets.icons.businessUnitFilterIcon.path,
      buttonLabel: 'Add Education',
      buttonIconPath: Assets.icons.addDivisionIcon.path,
      emptyStateMessage: 'No education added yet. Click "Add Education" to include your academic background.',
      items: state.educationEntries
          .map((e) => CandidateFormListItem(id: e.id, title: e.displayTitle, subtitle: e.displaySubtitle))
          .toList(),
      onAddPressed: () => _openEducationDialog(context, ref),
      onEditItem: (id) => _openEducationDialog(context, ref, editId: id),
      onRemoveItem: (id) => ref.read(createCandidateProvider.notifier).removeEducation(id),
    );
  }
}

class CandidateWorkExperienceOptionalSection extends ConsumerWidget {
  const CandidateWorkExperienceOptionalSection({super.key});

  Future<void> _openWorkExperienceDialog(BuildContext context, WidgetRef ref, {String? editId}) async {
    final notifier = ref.read(createCandidateProvider.notifier);
    final state = ref.read(createCandidateProvider);
    final initial = editId == null ? null : state.workExperienceEntries.where((e) => e.id == editId).firstOrNull;

    final result = await AddCandidateWorkExperienceDialog.show(context, initialEntry: initial);
    if (result == null || !context.mounted) return;

    if (editId != null) {
      notifier.updateWorkExperience(result);
    } else {
      notifier.addWorkExperience(result);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createCandidateProvider);

    return CandidateFormOptionalSection(
      title: 'Work Experience (Optional)',
      iconPath: Assets.icons.employeeSelfService.education.path,
      buttonLabel: 'Add Experience',
      buttonIconPath: Assets.icons.addDivisionIcon.path,
      emptyStateMessage:
          'No work experience added yet. Click "Add Experience" to include your professional background.',
      items: state.workExperienceEntries
          .map((e) => CandidateFormListItem(id: e.id, title: e.displayTitle, subtitle: e.displaySubtitle))
          .toList(),
      onAddPressed: () => _openWorkExperienceDialog(context, ref),
      onEditItem: (id) => _openWorkExperienceDialog(context, ref, editId: id),
      onRemoveItem: (id) => ref.read(createCandidateProvider.notifier).removeWorkExperience(id),
    );
  }
}
