import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class BlackoutPeriodsSection extends StatelessWidget {
  final bool isDark;
  final BlackoutPeriods blackout;

  const BlackoutPeriodsSection({super.key, required this.isDark, required this.blackout});

  @override
  Widget build(BuildContext context) {
    return ExpandableConfigSection(
      title: 'Blackout Periods',
      iconPath: Assets.icons.leaveManagement.prohibited.path,
      child: DigifyTextField(
        controller: TextEditingController(text: blackout.fromTo),
        labelText: 'From-To (DD/MM/YYYY)',
        hintText: 'e.g., 01/01/2024 - 31/12/2024',
        readOnly: true,
        enabled: false,
      ),
    );
  }
}
