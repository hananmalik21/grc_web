import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/utils/input_formatters.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/employee_management/domain/models/empl_lookup_value.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_banking_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/empl_lookups_provider.dart';
import 'package:grc/features/employee_management/presentation/providers/manage_employees_enterprise_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class BankingInfoModule extends ConsumerWidget {
  const BankingInfoModule({super.key});

  static EmplLookupValue? _bankByCode(String? code, List<EmplLookupValue> values) {
    if (code == null || code.trim().isEmpty) return null;
    try {
      return values.firstWhere((v) => v.lookupCode == code.trim());
    } catch (_) {
      return null;
    }
  }

  static Widget _prefixIcon(BuildContext context, String path, bool isDark) {
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final state = ref.watch(addEmployeeBankingProvider);
    final notifier = ref.read(addEmployeeBankingProvider.notifier);
    final em = Assets.icons.employeeManagement;
    final cardIcon = _prefixIcon(context, em.card.path, isDark);
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
          localizations.bankingInformation,
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
          ),
        ),
      );
    }
    final bankValuesAsync = ref.watch(
      emplLookupValuesForTypeProvider((enterpriseId: enterpriseId, typeCode: 'BANK_NAME')),
    );
    final bankValues = bankValuesAsync.valueOrNull ?? [];
    final bankLoading = bankValuesAsync.isLoading;
    final selectedBank = _bankByCode(state.bankCode, bankValues);

    final bankNameField = DigifySelectFieldWithLabel<EmplLookupValue>(
      label: localizations.bankName,
      isRequired: true,
      hint: bankLoading ? localizations.pleaseWait : localizations.hintBankName,
      items: bankValues,
      itemLabelBuilder: (v) => v.meaningEn,
      value: selectedBank,
      onChanged: bankLoading ? null : (v) => notifier.setBank(v?.lookupCode, v?.meaningEn),
    );
    final accountNumberField = DigifyTextField(
      labelText: localizations.accountNumber,
      isRequired: true,
      prefixIcon: cardIcon,
      hintText: localizations.hintAccountNumber,
      initialValue: state.accountNumber ?? '',
      onChanged: notifier.setAccountNumber,
    );
    final ibanField = DigifyTextField(
      labelText: localizations.iban,
      isRequired: true,
      prefixIcon: cardIcon,
      hintText: localizations.hintIban,
      initialValue: state.iban ?? '',
      onChanged: notifier.setIban,
      inputFormatters: AppInputFormatters.iban,
    );

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final useTwoColumns = constraints.maxWidth > 500;
          if (useTwoColumns) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.h,
              children: [
                bankNameField,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: accountNumberField),
                    Gap(14.w),
                    Expanded(child: ibanField),
                  ],
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.h,
            children: [bankNameField, accountNumberField, ibanField],
          );
        },
      ),
    );
  }
}
