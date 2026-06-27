import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_address_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ResidentialAddressModule extends ConsumerWidget {
  const ResidentialAddressModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressState = ref.watch(addEmployeeAddressProvider);
    final addressNotifier = ref.read(addEmployeeAddressProvider.notifier);
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final addressIcon = Padding(
      padding: EdgeInsetsDirectional.only(start: 12.w, end: 8.w),
      child: DigifyAsset(
        assetPath: Assets.icons.locationPinIcon.path,
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
                assetPath: Assets.icons.locationPinIcon.path,
                width: 14,
                height: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
              Gap(7.w),
              Text(
                localizations.residentialAddress,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                ),
              ),
            ],
          ),
          DigifyTextField(
            labelText: '${localizations.address} (Line 1)',
            prefixIcon: addressIcon,
            hintText: 'e.g. Block 1, St 2',
            initialValue: addressState.addressLine1 ?? '',
            onChanged: addressNotifier.setAddressLine1,
            isRequired: true,
          ),
          DigifyTextField(
            labelText: '${localizations.address} (Line 2)',
            prefixIcon: addressIcon,
            hintText: 'e.g. Building 5, Floor 3',
            initialValue: addressState.addressLine2 ?? '',
            onChanged: addressNotifier.setAddressLine2,
          ),
          DigifyTextField(
            labelText: localizations.governorate,
            prefixIcon: addressIcon,
            hintText: localizations.hintGovernorate,
            initialValue: addressState.area ?? '',
            onChanged: addressNotifier.setArea,
            isRequired: true,
          ),
          DigifyTextField(
            labelText: localizations.city,
            prefixIcon: addressIcon,
            hintText: 'e.g. Kuwait City',
            initialValue: addressState.city ?? '',
            onChanged: addressNotifier.setCity,
            isRequired: true,
          ),
          DigifyTextField(
            labelText: localizations.country,
            prefixIcon: addressIcon,
            hintText: localizations.hintCountry,
            initialValue: addressState.countryCode ?? '',
            onChanged: addressNotifier.setCountryCode,
            isRequired: true,
          ),
        ],
      ),
    );
  }
}
