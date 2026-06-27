import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/section_header_card.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/banking_info_module.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEmployeeBankingStep extends StatelessWidget {
  const AddEmployeeBankingStep({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final em = Assets.icons.employeeManagement;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18.h,
      children: [
        SectionHeaderCard(
          iconAssetPath: em.banking.path,
          title: localizations.bankingInformation,
          subtitle: localizations.bankingInformationSubtitle,
        ),
        const BankingInfoModule(),
      ],
    );
  }
}
