import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../providers/security_policies/security_policies_provider.dart';
import '../../../providers/security_policies/security_policies_state.dart';
import 'widgets/compact_input_field.dart';
import 'widgets/compact_option_field.dart';
import 'widgets/policies_section_card.dart';
import 'widgets/policy_setting_card.dart';

class PasswordPoliciesSection extends StatelessWidget {
  final SecurityPoliciesValues values;
  final SecurityPoliciesNotifier notifier;

  const PasswordPoliciesSection({super.key, required this.values, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return PoliciesSectionCard(
      title: 'Password Policies',
      child: Column(
        children: [
          PolicySettingCard(
            title: 'Minimum Password Length',
            subtitle: 'Minimum number of characters required for passwords',
            enabled: values.minPasswordLengthEnabled,
            onEnabledChanged: notifier.setMinPasswordLengthEnabled,
            input: CompactInputField(value: values.minPasswordLength, onChanged: notifier.setMinPasswordLength),
          ),
          Gap(14.h),
          PolicySettingCard(
            title: 'Password Complexity',
            subtitle: 'Require uppercase, lowercase, numbers, and special characters',
            enabled: values.passwordComplexityEnabled,
            onEnabledChanged: notifier.setPasswordComplexityEnabled,
            input: CompactOptionField(
              value: values.passwordComplexity.label,
              onTap: () => notifier.setPasswordComplexity(values.passwordComplexity.next),
            ),
          ),
          Gap(14.h),
          PolicySettingCard(
            title: 'Password Expiry (Days)',
            subtitle: 'Force password change after specified days',
            enabled: values.passwordExpiryEnabled,
            onEnabledChanged: notifier.setPasswordExpiryEnabled,
            input: CompactInputField(value: values.passwordExpiryDays, onChanged: notifier.setPasswordExpiryDays),
          ),
        ],
      ),
    );
  }
}
