import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/application_roles/application_roles_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_widgets.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ApplicationRolesDetailContent extends ConsumerWidget {
  const ApplicationRolesDetailContent({
    super.key,
    required this.selectedListingRole,
    required this.onBack,
    this.showHeader = true,
  });

  final ApplicationRoleItem selectedListingRole;
  final VoidCallback onBack;
  final bool showHeader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(rolesManagementProvider.notifier);
    final selectedRole = ref.watch(rolesManagementProvider).selectedRole;
    final isMobile = context.isMobile;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20.h,
      children: [
        if (showHeader) _DetailHeader(roleName: selectedListingRole.name, onBack: onBack),
        if (selectedRole != null) ...[
          RolesManagementSelectedRoleOverviewCard(role: selectedRole, users: notifier.selectedRoleUsers),
          isMobile
              ? RolesManagementPermissionMatrixMobile(permissions: notifier.selectedRolePermissions)
              : RolesManagementPermissionMatrixCard(permissions: notifier.selectedRolePermissions),
          isMobile
              ? Column(
                  spacing: 20.h,
                  children: [
                    RolesManagementUserAssignmentMobile(users: notifier.selectedRoleUsers),
                    RolesManagementActivityLogMobile(activities: notifier.selectedRoleActivities),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: RolesManagementUserAssignmentCard(users: notifier.selectedRoleUsers)),
                    Gap(24.w),
                    Expanded(child: RolesManagementActivityLogCard(activities: notifier.selectedRoleActivities)),
                  ],
                ),
        ],
      ],
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.roleName, required this.onBack});

  final String roleName;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        DigifyAssetButton(onTap: onBack, assetPath: Assets.icons.employeeManagement.backArrow.path),
        Gap(24.w),
        Expanded(child: DigifyTabHeader(title: roleName)),
      ],
    );
  }
}
