import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/section_header_card.dart';
import 'package:grc/features/security_manager/presentation/providers/user_management/user_form_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/create_user/security_settings/security_preference_tiles.dart';
import 'package:grc/features/security_manager/presentation/widgets/user_management/user_form_section.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AuditComplianceSection extends ConsumerWidget {
  const AuditComplianceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userFormProvider);
    final notifier = ref.read(userFormProvider.notifier);

    return UserFormSection(
      isDark: context.isDark,
      header: SectionHeaderCard(title: 'Audit & Compliance', iconAssetPath: Assets.icons.complianceIcon.path),
      child: Column(
        children: [
          SecurityPreferenceTile(
            title: 'Audit User Actions',
            subtitle: 'Log all user activities for compliance',
            value: state.auditUserActions ?? false,
            onChanged: notifier.setAuditUserActions,
          ),
          Gap(12.h),
          SecurityPreferenceTile(
            title: 'Data Access Logging',
            subtitle: 'Track sensitive data access',
            value: state.dataAccessLogging ?? false,
            onChanged: notifier.setDataAccessLogging,
          ),
          Gap(12.h),
          SecurityPreferenceTile(
            title: 'Compliance Alerts',
            subtitle: 'Send alerts for policy violations',
            value: state.complianceAlert ?? false,
            onChanged: notifier.setComplianceAlert,
          ),
        ],
      ),
    );
  }
}
