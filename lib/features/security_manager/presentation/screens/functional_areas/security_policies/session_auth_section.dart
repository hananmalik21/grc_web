import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../providers/security_policies/security_policies_provider.dart';
import '../../../providers/security_policies/security_policies_state.dart';
import 'widgets/compact_input_field.dart';
import 'widgets/compact_option_field.dart';
import 'widgets/policies_section_card.dart';
import 'widgets/policy_setting_card.dart';

class SessionAuthSection extends StatelessWidget {
  final SecurityPoliciesValues values;
  final SecurityPoliciesNotifier notifier;

  const SessionAuthSection({super.key, required this.values, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return PoliciesSectionCard(
      title: 'Session & Authentication',
      child: Column(
        children: [
          PolicySettingCard(
            title: 'Max Login Attempts',
            subtitle: 'Lock account after failed login attempts',
            enabled: values.maxLoginAttemptsEnabled,
            onEnabledChanged: notifier.setMaxLoginAttemptsEnabled,
            input: CompactInputField(value: values.maxLoginAttempts, onChanged: notifier.setMaxLoginAttempts),
          ),
          Gap(14.h),
          PolicySettingCard(
            title: 'Session Timeout (minutes)',
            subtitle: 'Automatically log out inactive users',
            enabled: values.sessionTimeoutEnabled,
            onEnabledChanged: notifier.setSessionTimeoutEnabled,
            input: CompactInputField(value: values.sessionTimeoutMinutes, onChanged: notifier.setSessionTimeoutMinutes),
          ),
          Gap(14.h),
          PolicySettingCard(
            title: 'Multi-Factor Authentication',
            subtitle: 'Enforce 2FA for all users',
            enabled: values.mfaEnabled,
            onEnabledChanged: notifier.setMfaEnabled,
            input: CompactOptionField(
              value: values.mfaMode.label,
              onTap: () => notifier.setMfaMode(values.mfaMode.toggled),
            ),
          ),
        ],
      ),
    );
  }
}
