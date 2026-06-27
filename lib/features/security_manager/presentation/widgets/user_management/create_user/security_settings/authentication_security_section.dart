import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/section_header_card.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_form_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/create_user/security_settings/security_preference_tiles.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/user_form_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AuthenticationSecuritySection extends ConsumerWidget {
  const AuthenticationSecuritySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);

    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(title: 'Authentication & Security', iconAssetPath: Assets.icons.securityIcon.path),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SecurityHighlightedPreferenceTile(
            title: 'Enable Two-Factor Authentication (2FA)',
            subtitle: 'Require additional verification for enhanced security',
            value: state.enable2FA ?? false,
            onChanged: notifier.setEnable2FA,
          ),
          Gap(16.h),
          if (context.isMobile) ...[
            SecurityPreferenceTile(
              title: 'Force Password Change',
              subtitle: 'On next login',
              value: state.forcePasswordChange ?? false,
              onChanged: notifier.setForcePasswordChange,
            ),
            Gap(12.h),
            SecurityPreferenceTile(
              title: 'Account Lockout',
              subtitle: 'After failed login attempts',
              value: state.accountLockout ?? false,
              onChanged: notifier.setAccountLockout,
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: SecurityPreferenceTile(
                    title: 'Force Password Change',
                    subtitle: 'On next login',
                    value: state.forcePasswordChange ?? false,
                    onChanged: notifier.setForcePasswordChange,
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: SecurityPreferenceTile(
                    title: 'Account Lockout',
                    subtitle: 'After failed login attempts',
                    value: state.accountLockout ?? false,
                    onChanged: notifier.setAccountLockout,
                  ),
                ),
              ],
            ),
          ],
          if (state.accountLockout ?? false) ...[
            Gap(16.h),
            DigifySelectFieldWithLabel<int>(
              label: 'Failed Login Attempts Before Lockout',
              value: state.failedLoginAttempts,
              items: const [3, 5, 10],
              itemLabelBuilder: (item) => '$item attempts',
              onChanged: (v) => notifier.setFailedLoginAttempts(v!),
            ),
          ],
        ],
      ),
    );
  }
}
