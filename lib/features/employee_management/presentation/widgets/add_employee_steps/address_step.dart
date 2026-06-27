import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/section_header_card.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/emergency_contact_module.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/residential_address_module.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddEmployeeAddressStep extends StatelessWidget {
  const AddEmployeeAddressStep({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 18.h,
      children: [
        SectionHeaderCard(
          iconAssetPath: Assets.icons.homeIcon.path,
          title: localizations.addressAndEmergencyContact,
          subtitle: localizations.addressAndEmergencyContactSubtitle,
        ),
        const ResidentialAddressModule(),
        const EmergencyContactModule(),
      ],
    );
  }
}
