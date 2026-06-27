import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';
import 'package:grc/features/employee_management/presentation/models/employee_detail_document_display.dart';
import 'package:grc/features/employee_management/presentation/utils/employee_detail_formatters.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/employee_detail_document_card.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/employee_detail_icon_label_section_card.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DocumentsBankingTabContent extends StatelessWidget {
  const DocumentsBankingTabContent({super.key, required this.isDark, this.fullDetails, this.wrapInScrollView = true});

  final bool isDark;
  final EmployeeFullDetails? fullDetails;
  final bool wrapInScrollView;

  List<EmployeeDetailIconLabelRow> _bankingInfoRows() {
    final bank = fullDetails?.bankAccounts;
    final first = bank?.isNotEmpty == true ? bank!.first : null;
    return [
      EmployeeDetailIconLabelRow(
        iconPath: Assets.icons.buildingSmallIcon.path,
        label: 'Bank Name',
        value: displayValue(first?.bankName),
      ),
      EmployeeDetailIconLabelRow(
        iconPath: Assets.icons.employeeManagement.hash.path,
        label: 'Account Number',
        value: displayValue(first?.accountNumber),
      ),
      EmployeeDetailIconLabelRow(
        iconPath: Assets.icons.employeeManagement.card.path,
        label: 'IBAN',
        value: displayValue(first?.iban),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = EmployeeDetailDocumentDisplay.fromFullDetails(fullDetails);
    final documentIconPath = Assets.icons.employeeManagement.document.path;

    final hasBanking = (fullDetails?.bankAccounts ?? []).isNotEmpty;
    final hasDocuments = items.isNotEmpty;

    final List<Widget> sections = [];

    if (hasBanking) {
      sections.add(
        EmployeeDetailIconLabelSectionCard(
          title: 'Banking Information',
          titleIconAssetPath: Assets.icons.employeeManagement.banking.path,
          rows: _bankingInfoRows(),
          isDark: isDark,
          borderColor: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        ),
      );
      sections.add(Gap(16.h));
    }

    final List<Widget> documentSectionChildren = [];

    documentSectionChildren.add(
      Text(
        AppLocalizations.of(context)!.addEmployeeStepDocuments,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
      ),
    );
    documentSectionChildren.add(Gap(12.h));

    if (hasDocuments) {
      final List<Widget> cardRows = [];
      for (var i = 0; i < items.length; i += 2) {
        final left = items[i];
        final right = i + 1 < items.length ? items[i + 1] : null;
        cardRows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: EmployeeDetailDocumentCard(
                  title: left.title,
                  iconPath: documentIconPath,
                  statusLabel: left.status,
                  number: left.fileName,
                  expiryDate: left.expiryDate,
                  isDark: isDark,
                  firstFieldLabel: left.firstFieldLabel,
                  accessUrl: left.accessUrl,
                ),
              ),
              if (right != null) ...[
                Gap(12.w),
                Expanded(
                  child: EmployeeDetailDocumentCard(
                    title: right.title,
                    iconPath: documentIconPath,
                    statusLabel: right.status,
                    number: right.fileName,
                    expiryDate: right.expiryDate,
                    isDark: isDark,
                    firstFieldLabel: right.firstFieldLabel,
                    accessUrl: right.accessUrl,
                  ),
                ),
              ],
            ],
          ),
        );
        if (i + 2 < items.length) cardRows.add(Gap(12.h));
      }
      documentSectionChildren.addAll(cardRows);
    } else {
      documentSectionChildren.add(
        Text(
          AppLocalizations.of(context)!.noDocumentsAvailable,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
    }

    sections.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: documentSectionChildren));

    final content = Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: sections),
    );
    if (wrapInScrollView) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: content,
      );
    }
    return content;
  }
}
