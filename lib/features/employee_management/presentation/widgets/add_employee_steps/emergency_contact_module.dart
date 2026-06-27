import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/utils/phone_number_utils.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_phone_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_address_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/empl_lookups_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmergencyContactModule extends ConsumerWidget {
  const EmergencyContactModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(addEmployeeAddressProvider);
    final addressNotifier = ref.read(addEmployeeAddressProvider.notifier);
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final enterpriseId = ref.watch(manageEmployeesEnterpriseIdProvider);
    if (enterpriseId == null) {
      return Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: AppShadows.primaryShadow,
        ),
        child: Text(
          localizations.emergencyContact,
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
          ),
        ),
      );
    }
    final relationshipValuesAsync = ref.watch(
      emplLookupValuesForTypeProvider((enterpriseId: enterpriseId, typeCode: 'CONTACT_RELATIONSHIP')),
    );
    final relationshipValues = relationshipValuesAsync.valueOrNull ?? [];
    final relationshipLoading = relationshipValuesAsync.isLoading;
    final selectedRelationship = _relationshipByCode(addressState.emergRelationship, relationshipValues);
    final emergPhoneParts = PhoneNumberUtils.split(addressState.emergPhone);
    final personIcon = _prefixIcon(context, Assets.icons.userIcon.path, isDark);
    final phoneIcon = Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: DigifyAsset(
        assetPath: Assets.icons.leaveManagement.phone.path,
        width: 20.w,
        height: 20.h,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
    );
    final emailIcon = Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: DigifyAsset(
        assetPath: Assets.icons.employeeManagement.mail.path,
        width: 20.w,
        height: 20.h,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
    );

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 18.h,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.warningIcon.path,
                width: 14,
                height: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
              Gap(7.w),
              Text(
                localizations.emergencyContact,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final useTwoColumns = constraints.maxWidth > 500;
              final contactName = DigifyTextField(
                labelText: localizations.contactName,
                prefixIcon: personIcon,
                hintText: localizations.hintContactName,
                initialValue: addressState.contactName ?? '',
                onChanged: (value) => addressNotifier.setContactName(value),
                isRequired: true,
              );
              final emergencyAddress = DigifyTextField(
                labelText: localizations.address,
                prefixIcon: _prefixIcon(context, Assets.icons.locationPinIcon.path, isDark),
                hintText: localizations.hintAddress,
                initialValue: addressState.emergAddress ?? '',
                onChanged: (value) => addressNotifier.setEmergAddress(value),
              );
              final relationship = DigifySelectFieldWithLabel<EmplLookupValue>(
                label: localizations.relationship,
                hint: relationshipLoading ? localizations.pleaseWait : localizations.hintRelationship,
                items: relationshipValues,
                itemLabelBuilder: (v) => v.meaningEn,
                value: selectedRelationship,
                onChanged: relationshipLoading ? null : (v) => addressNotifier.setEmergRelationship(v?.lookupCode),
                isRequired: true,
              );
              final phoneNumber = DigifyPhoneField(
                labelText: localizations.phoneNumber,
                isRequired: true,
                hintText: localizations.hintNationalPhoneNumber,
                prefixIcon: phoneIcon,
                initialDialCode: emergPhoneParts.dialCode,
                initialNumber: emergPhoneParts.national,
                onDialCodeChanged: (dial) {
                  final current = ref.read(addEmployeeAddressProvider).emergPhone;
                  final national = PhoneNumberUtils.split(current).national;
                  final combined = PhoneNumberUtils.combine(dial, national);
                  addressNotifier.setEmergPhone(combined.isEmpty ? null : combined);
                },
                onNumberChanged: (number) {
                  final current = ref.read(addEmployeeAddressProvider).emergPhone;
                  final dial = PhoneNumberUtils.split(current).dialCode;
                  final combined = PhoneNumberUtils.combine(dial, number);
                  addressNotifier.setEmergPhone(combined.isEmpty ? null : combined);
                },
              );
              final emailAddress = DigifyTextField(
                labelText: localizations.emailAddress,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: emailIcon,
                hintText: localizations.hintEmail,
                initialValue: addressState.emergEmail ?? '',
                onChanged: (value) => addressNotifier.setEmergEmail(value),
                isRequired: true,
              );
              if (useTwoColumns) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.h,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: contactName),
                        Gap(14.w),
                        Expanded(child: relationship),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: phoneNumber),
                        Gap(14.w),
                        Expanded(child: emailAddress),
                      ],
                    ),
                    emergencyAddress,
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.h,
                children: [contactName, relationship, phoneNumber, emailAddress, emergencyAddress],
              );
            },
          ),
        ],
      ),
    );
  }

  static EmplLookupValue? _relationshipByCode(String? code, List<EmplLookupValue> values) {
    if (code == null || code.trim().isEmpty) return null;
    try {
      return values.firstWhere((v) => v.lookupCode == code.trim());
    } catch (_) {
      return null;
    }
  }

  Widget _prefixIcon(BuildContext context, String path, bool isDark) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: DigifyAsset(
        assetPath: path,
        width: 20,
        height: 20,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textMuted,
      ),
    );
  }
}
