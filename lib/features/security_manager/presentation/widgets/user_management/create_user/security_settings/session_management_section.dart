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

class SessionManagementSection extends ConsumerWidget {
  const SessionManagementSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);

    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(title: 'Session Management', iconAssetPath: Assets.icons.clockIcon.path),
      child: Column(
        children: [
          DigifySelectFieldWithLabel<int>(
            label: 'Session Timeout (minutes)',
            value: state.sessionTimeOut,
            items: const [30, 60, 120],
            itemLabelBuilder: (item) => '$item minutes',
            onChanged: (v) => notifier.setSessionTimeOut(v!),
          ),
          Gap(16.h),
          SecurityPreferenceTile(
            title: 'Concurrent Sessions',
            subtitle: 'Allow user to login from multiple devices',
            value: state.allowConcurrentSession ?? false,
            onChanged: notifier.setAllowConcurrentSession,
          ),
          Gap(12.h),
          SecurityPreferenceTile(
            title: 'IP Address Restriction',
            subtitle: 'Restrict access to specific IP addresses',
            value: state.ipAddressRestriction ?? false,
            onChanged: notifier.setIpAddressRestriction,
          ),
        ],
      ),
    );
  }
}
