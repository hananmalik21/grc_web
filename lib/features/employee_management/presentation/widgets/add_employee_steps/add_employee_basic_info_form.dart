import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_phone_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/employee_management/domain/models/create_employee_basic_info_request.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_basic_info_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddEmployeeBasicInfoForm extends ConsumerWidget {
  const AddEmployeeBasicInfoForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(addEmployeeBasicInfoProvider);
    final notifier = ref.read(addEmployeeBasicInfoProvider.notifier);
    final form = state.form;
    final formKey = ValueKey<int>(state.formGenerationId);

    final personPrefixIcon = _buildPrefixIcon(context, isDark);
    final emailIcon = _buildPrefixIcon(context, isDark, assetPath: Assets.icons.employeeManagement.mail.path);

    return KeyedSubtree(
      key: formKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useTwoColumns = constraints.maxWidth > 500;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20.h,
            children: [
              _NameSection(
                title: localizations.nameEnglish,
                useTwoColumns: useTwoColumns,
                fields: [
                  DigifyTextField(
                    labelText: localizations.firstName,
                    isRequired: true,
                    prefixIcon: personPrefixIcon,
                    hintText: localizations.hintFirstName,
                    initialValue: form.firstNameEn,
                    onChanged: notifier.setFirstNameEn,
                  ),
                  DigifyTextField(
                    labelText: localizations.secondName,
                    isRequired: true,
                    prefixIcon: personPrefixIcon,
                    hintText: localizations.hintSecondName,
                    initialValue: form.middleNameEn,
                    onChanged: notifier.setMiddleNameEn,
                  ),
                  DigifyTextField(
                    labelText: localizations.thirdName,
                    isRequired: true,
                    prefixIcon: personPrefixIcon,
                    hintText: localizations.hintThirdName,
                    initialValue: form.lastNameEn,
                    onChanged: notifier.setLastNameEn,
                  ),
                  DigifyTextField(
                    labelText: localizations.fourthName,
                    isRequired: true,
                    prefixIcon: personPrefixIcon,
                    hintText: localizations.hintFourthName,
                    initialValue: form.fourthNameEn,
                    onChanged: notifier.setFourthNameEn,
                  ),
                ],
              ),
              _NameSection(
                title: localizations.nameArabicSectionTitle,
                useTwoColumns: useTwoColumns,
                fields: [
                  DigifyTextField.arabic(
                    labelText: localizations.firstNameArabic,
                    hintText: localizations.hintFirstNameArabic,
                    initialValue: form.firstNameAr,
                    onChanged: notifier.setFirstNameAr,
                  ),
                  DigifyTextField.arabic(
                    labelText: localizations.secondNameArabic,
                    hintText: localizations.hintSecondNameArabic,
                    initialValue: form.middleNameAr,
                    onChanged: notifier.setMiddleNameAr,
                  ),
                  DigifyTextField.arabic(
                    labelText: localizations.thirdNameArabic,
                    hintText: localizations.hintThirdNameArabic,
                    initialValue: form.lastNameAr,
                    onChanged: notifier.setLastNameAr,
                  ),
                  DigifyTextField.arabic(
                    labelText: localizations.fourthNameArabic,
                    hintText: localizations.hintFourthNameArabic,
                    initialValue: form.fourthNameAr,
                    onChanged: notifier.setFourthNameAr,
                  ),
                ],
              ),
              Divider(height: 1.h, thickness: 1.h, color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
              _ContactSection(
                title: localizations.contactInformation,
                useTwoColumns: useTwoColumns,
                localizations: localizations,
                form: form,
                notifier: notifier,
                emailIcon: emailIcon,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPrefixIcon(BuildContext context, bool isDark, {String assetPath = ''}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: DigifyAsset(
        assetPath: assetPath.isEmpty ? Assets.icons.userIcon.path : assetPath,
        width: 20,
        height: 20,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
    );
  }
}

class _NameSection extends StatelessWidget {
  const _NameSection({required this.title, required this.useTwoColumns, required this.fields});

  final String title;
  final bool useTwoColumns;
  final List<Widget> fields;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.h,
      children: [
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        if (useTwoColumns) _TwoByTwoGrid(fields: fields) else Column(spacing: 16.h, children: fields),
      ],
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({
    required this.title,
    required this.useTwoColumns,
    required this.localizations,
    required this.form,
    required this.notifier,
    required this.emailIcon,
  });

  final String title;
  final bool useTwoColumns;
  final AppLocalizations localizations;
  final CreateEmployeeBasicInfoRequest form;
  final AddEmployeeBasicInfoNotifier notifier;
  final Widget emailIcon;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final l10n = localizations;

    final fields = [
      DigifyTextField(
        labelText: l10n.emailAddress,
        isRequired: true,
        keyboardType: TextInputType.emailAddress,
        prefixIcon: emailIcon,
        hintText: l10n.hintEmail,
        initialValue: form.email,
        onChanged: notifier.setEmail,
      ),
      DigifyPhoneField(
        labelText: l10n.phoneNumber,
        hintText: l10n.hintNationalPhoneNumber,
        initialDialCode: form.phoneDialCode,
        initialNumber: form.phoneNumber,
        onDialCodeChanged: notifier.setPhoneDialCode,
        onNumberChanged: notifier.setPhoneNumber,
      ),
      DigifyPhoneField(
        labelText: l10n.mobileNumber,
        hintText: l10n.hintNationalMobileNumber,
        initialDialCode: form.mobileDialCode,
        initialNumber: form.mobileNumber,
        onDialCodeChanged: notifier.setMobileDialCode,
        onNumberChanged: notifier.setMobileNumber,
      ),
      DigifyDateField(
        label: l10n.dateOfBirth,
        hintText: l10n.hintDateOfBirth,
        isRequired: true,
        firstDate: DateTime(1900),
        initialDate: form.dateOfBirth,
        onDateSelected: notifier.setDateOfBirth,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.h,
      children: [
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        if (useTwoColumns) _TwoByTwoGrid(fields: fields) else Column(spacing: 16.h, children: fields),
      ],
    );
  }
}

class _TwoByTwoGrid extends StatelessWidget {
  const _TwoByTwoGrid({required this.fields});

  final List<Widget> fields;

  @override
  Widget build(BuildContext context) {
    assert(fields.length == 4, '_TwoByTwoGrid expects exactly 4 fields');

    return Column(
      spacing: 16.h,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: fields[0]),
            Gap(16.w),
            Expanded(child: fields[1]),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: fields[2]),
            Gap(16.w),
            Expanded(child: fields[3]),
          ],
        ),
      ],
    );
  }
}
