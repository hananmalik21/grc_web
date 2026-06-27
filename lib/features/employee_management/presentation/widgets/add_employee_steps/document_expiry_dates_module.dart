import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_documents_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DocumentExpiryDatesModule extends ConsumerWidget {
  const DocumentExpiryDatesModule({super.key});

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
    final em = Assets.icons.employeeManagement;
    final documentIcon = _prefixIcon(context, em.document.path, isDark);
    final calendarPath = Assets.icons.leaveManagementMainIcon.path;
    final state = ref.watch(addEmployeeDocumentsProvider);
    final notifier = ref.read(addEmployeeDocumentsProvider.notifier);
    final firstExpiryDate = DateTime.now();
    final lastExpiryDate = DateTime(2100, 12, 31);

    final civilIdExpiry = DigifyDateField(
      label: localizations.civilIdExpiry,
      isRequired: true,
      hintText: localizations.hintSelectDate,
      calendarIconPath: calendarPath,
      initialDate: state.civilIdExpiry,
      firstDate: firstExpiryDate,
      lastDate: lastExpiryDate,
      onDateSelected: notifier.setCivilIdExpiry,
    );
    final passportExpiry = DigifyDateField(
      label: localizations.passportExpiry,
      isRequired: true,
      hintText: localizations.hintSelectDate,
      calendarIconPath: calendarPath,
      initialDate: state.passportExpiry,
      firstDate: firstExpiryDate,
      lastDate: lastExpiryDate,
      onDateSelected: notifier.setPassportExpiry,
    );
    final visaNumber = DigifyTextField(
      labelText: localizations.visaNumber,
      isRequired: true,
      prefixIcon: documentIcon,
      hintText: localizations.hintVisaNumber,
      initialValue: state.visaNumber ?? '',
      onChanged: notifier.setVisaNumber,
    );
    final visaExpiry = DigifyDateField(
      label: localizations.visaExpiry,
      isRequired: true,
      hintText: localizations.hintSelectDate,
      calendarIconPath: calendarPath,
      initialDate: state.visaExpiry,
      firstDate: firstExpiryDate,
      lastDate: lastExpiryDate,
      onDateSelected: notifier.setVisaExpiry,
    );
    final workPermitNumber = DigifyTextField(
      labelText: localizations.workPermitNumber,
      isRequired: true,
      prefixIcon: documentIcon,
      hintText: localizations.hintWorkPermitNumber,
      initialValue: state.workPermitNumber ?? '',
      onChanged: notifier.setWorkPermitNumber,
    );
    final workPermitExpiry = DigifyDateField(
      label: localizations.workPermitExpiry,
      isRequired: true,
      hintText: localizations.hintSelectDate,
      calendarIconPath: calendarPath,
      initialDate: state.workPermitExpiry,
      firstDate: firstExpiryDate,
      lastDate: lastExpiryDate,
      onDateSelected: notifier.setWorkPermitExpiry,
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
                assetPath: em.document.path,
                width: 14,
                height: 14,
                color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimary,
              ),
              Gap(7.w),
              Text(
                localizations.documentExpiryDates,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                ),
              ),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final useTwoColumns = constraints.maxWidth > 500;
              if (useTwoColumns) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16.h,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: civilIdExpiry),
                        Gap(14.w),
                        Expanded(child: passportExpiry),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: visaNumber),
                        Gap(14.w),
                        Expanded(child: visaExpiry),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: workPermitNumber),
                        Gap(14.w),
                        Expanded(child: workPermitExpiry),
                      ],
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16.h,
                children: [civilIdExpiry, passportExpiry, visaNumber, visaExpiry, workPermitNumber, workPermitExpiry],
              );
            },
          ),
        ],
      ),
    );
  }
}
