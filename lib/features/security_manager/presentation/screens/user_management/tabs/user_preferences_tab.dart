import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/create_user/user_preferences/display_preferences_section.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/create_user/user_preferences/notification_preferences_section.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/create_user/user_preferences/regional_settings_section.dart';

class UserPreferencesTab extends StatelessWidget {
  const UserPreferencesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        RegionalSettingsSection(),
        Gap(24),
        NotificationPreferencesSection(),
        Gap(24),
        DisplayPreferencesSection(),
      ],
    );
  }
}
