import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_demographics_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class IdentificationDocumentsModule extends ConsumerWidget {
  const IdentificationDocumentsModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final em = Assets.icons.employeeManagement;
    final demographics = ref.watch(addEmployeeDemographicsProvider);
    final notifier = ref.read(addEmployeeDemographicsProvider.notifier);

    final documentIcon = Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: DigifyAsset(
        assetPath: em.passport.path,
        width: 20,
        height: 20,
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
                assetPath: em.passport.path,
                width: 14,
                height: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
              Gap(7.w),
              Text(
                localizations.identificationDocuments,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final useTwoColumns = constraints.maxWidth > 500;
              final civilId = DigifyTextField(
                labelText: localizations.civilIdNumber,
                prefixIcon: documentIcon,
                hintText: localizations.hintCivilIdNumber,
                initialValue: demographics.civilIdNumber,
                onChanged: (v) => notifier.setCivilIdNumber(v.isEmpty ? null : v),
                isRequired: true,
              );
              final passport = DigifyTextField(
                labelText: localizations.passportNumber,
                prefixIcon: documentIcon,
                hintText: localizations.hintPassportNumber,
                initialValue: demographics.passportNumber,
                onChanged: (v) => notifier.setPassportNumber(v.isEmpty ? null : v),
                isRequired: true,
              );
              if (useTwoColumns) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: civilId),
                    Gap(14.w),
                    Expanded(child: passport),
                  ],
                );
              }
              return Column(crossAxisAlignment: CrossAxisAlignment.start, spacing: 16.h, children: [civilId, passport]);
            },
          ),
        ],
      ),
    );
  }
}
