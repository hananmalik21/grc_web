import 'package:grc/features/security_manager/presentation/screens/user_management/user_management_permission_mixin.dart';
import 'package:flutter/material.dart';

import '../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../../core/services/responsive/responsive_helper.dart';
import '../../../../../core/widgets/buttons/app_button.dart';
import '../../../../../core/widgets/common/digify_tab_header.dart';
import '../../../../../core/widgets/common/enterprise_selector_widget.dart';
import '../../../../../gen/assets.gen.dart';
import 'user_management_content.dart';

class UserManagementTabletLayout extends StatelessWidget with UserManagementPermissionMixin {
  const UserManagementTabletLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onCreateUserPressed,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final Future<void> Function()? onCreateUserPressed;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return UserManagementContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: DigifyTabHeader(
        title: localizations.userManagement,
        description: 'Manage system users, roles, and access permissions',
        trailing: canCreateUser
            ? AppButton.primary(
                label: 'Create New User',
                svgPath: Assets.icons.addNewIconFigma.path,
                onPressed: onCreateUserPressed == null ? null : () => onCreateUserPressed!(),
              )
            : null,
      ),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
