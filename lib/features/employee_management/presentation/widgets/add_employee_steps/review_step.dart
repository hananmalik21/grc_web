import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/section_header_card.dart';
import 'package:grc/features/employee_management/presentation/providers/add_employee_review_data_provider.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/review_summary_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddEmployeeReviewStep extends ConsumerWidget {
  const AddEmployeeReviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final em = Assets.icons.employeeManagement;
    final data = ref.watch(addEmployeeReviewDataProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderCard(
          iconAssetPath: Assets.icons.checkIconGreen.path,
          title: localizations.reviewAndConfirm,
          subtitle: localizations.reviewAndConfirmSubtitle,
        ),
        Gap(18.w),
        ReviewSummaryCard(
          iconPath: em.basicInfo.path,
          title: localizations.personalInformation,
          rows: [
            ReviewSummaryRow(label: localizations.reviewName, value: data.name),
            ReviewSummaryRow(label: localizations.phone, value: data.phone),
            ReviewSummaryRow(label: localizations.nationality, value: data.nationality),
            ReviewSummaryRow(label: localizations.email, value: data.email),
            ReviewSummaryRow(label: localizations.reviewDob, value: data.dobFormatted),
            ReviewSummaryRow(label: localizations.gender, value: data.gender),
          ],
        ),
        Gap(18.w),
        ReviewSummaryCard(
          iconPath: Assets.icons.homeIcon.path,
          title: localizations.addEmployeeStepAddress,
          rows: [
            ReviewSummaryRow(label: localizations.address, value: data.emergAddress),
            ReviewSummaryRow(label: localizations.phone, value: data.emergPhone),
            ReviewSummaryRow(label: localizations.email, value: data.emergEmail),
            ReviewSummaryRow(label: localizations.relationship, value: data.relationship),
            ReviewSummaryRow(label: localizations.contactName, value: data.contactName),
          ],
        ),
        Gap(18.w),
        ReviewSummaryCard(
          iconPath: Assets.icons.departmentsIcon.path,
          title: localizations.enterpriseStructure,
          rows: [
            ReviewSummaryRow(label: localizations.company, value: data.companyDisplay),
            ReviewSummaryRow(label: localizations.workLocation, value: data.workLocation),
          ],
        ),
        Gap(18.w),
        ReviewSummaryCard(
          iconPath: em.assignment.path,
          title: localizations.employmentDetails,
          rows: [
            ReviewSummaryRow(label: localizations.position, value: data.position),
            ReviewSummaryRow(label: localizations.contractType, value: data.contractTypeLabel),
            ReviewSummaryRow(label: localizations.enterpriseHireDate, value: data.enterpriseHireDateFormatted),
            ReviewSummaryRow(label: localizations.status, value: data.statusLabel),
          ],
        ),
        Gap(18.w),
        ReviewSummaryCard(
          iconPath: Assets.icons.timeManagementMainIcon.path,
          title: localizations.addEmployeeStepWorkSchedule,
          rows: [ReviewSummaryRow(label: localizations.workSchedule, value: data.workScheduleName)],
        ),
        Gap(18.w),
        ReviewSummaryCard(
          iconPath: em.compensation.path,
          title: localizations.addEmployeeStepCompensation,
          rows: [
            ReviewSummaryRow(label: localizations.compensationStartDate, value: data.compensationStartDateFormatted),
            ReviewSummaryRow(label: localizations.compensationEndDate, value: data.compensationEndDateFormatted),
            ReviewSummaryRow(label: localizations.addEmployeeStepCompensation, value: data.compensationPlansDisplay),
            ReviewSummaryRow(label: localizations.currency, value: data.compensationCurrencyDisplay, rightAlign: true),
            ReviewSummaryRow(
              label: localizations.reviewTotal,
              value: data.compensationGrossDisplay,
              valueBold: true,
              labelBold: true,
              rightAlign: true,
              dividerBefore: true,
            ),
          ],
        ),
        Gap(18.w),
        ReviewSummaryCard(
          iconPath: em.banking.path,
          title: localizations.addEmployeeStepBanking,
          rows: [
            ReviewSummaryRow(label: localizations.bankName, value: data.bankName),
            ReviewSummaryRow(label: localizations.accountNumber, value: data.accountNumber),
            ReviewSummaryRow(label: localizations.iban, value: data.iban),
          ],
        ),
        Gap(18.w),
        ReviewSummaryCard(
          iconPath: em.document.path,
          title: localizations.documentsAndCompliance,
          rows: [
            ReviewSummaryRow(label: localizations.civilIdExpiry, value: data.civilIdExpiryFormatted),
            ReviewSummaryRow(label: localizations.passportExpiry, value: data.passportExpiryFormatted),
            ReviewSummaryRow(label: localizations.visaNumber, value: data.visaNumber),
            ReviewSummaryRow(label: localizations.visaExpiry, value: data.visaExpiryFormatted),
            ReviewSummaryRow(label: localizations.workPermitNumber, value: data.workPermitNumber),
            ReviewSummaryRow(label: localizations.workPermitExpiry, value: data.workPermitExpiryFormatted),
            ReviewSummaryRow(label: localizations.supportingDocuments, value: data.supportingDocumentName),
          ],
        ),
      ],
    );
  }
}
