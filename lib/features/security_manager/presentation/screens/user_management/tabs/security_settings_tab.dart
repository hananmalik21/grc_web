import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/create_user/security_settings/audit_compliance_section.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/create_user/security_settings/authentication_security_section.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/create_user/security_settings/session_management_section.dart';

class SecuritySettingsTab extends StatelessWidget {
  const SecuritySettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AuthenticationSecuritySection(),
        Gap(24),
        SessionManagementSection(),
        Gap(24),
        AuditComplianceSection(),
      ],
    );
  }
}
