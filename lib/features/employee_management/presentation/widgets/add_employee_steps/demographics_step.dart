import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/section_header_card.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/demographics_module.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/identification_documents_module.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEmployeeDemographicsStep extends StatelessWidget {
  const AddEmployeeDemographicsStep({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final lm = Assets.icons.leaveManagement;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18.h,
      children: [
        SectionHeaderCard(
          iconAssetPath: lm.globe.path,
          title: localizations.demographicsAndIdentity,
          subtitle: localizations.demographicsAndIdentitySubtitle,
        ),
        const DemographicsModule(demographicsStepOnly: true),
        const IdentificationDocumentsModule(),
      ],
    );
  }
}
