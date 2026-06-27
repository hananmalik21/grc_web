import 'package:grc/features/security_manager/presentation/screens/user_management/user_management_permission_mixin.dart';
import 'package:flutter/material.dart';

import '../../../../../core/services/responsive/responsive_helper.dart';
import '../../../../../core/widgets/buttons/app_mobile_button.dart';
import '../../../../../core/widgets/common/digify_mobile_tab_header.dart';
import '../../../../../core/widgets/common/enterprise_selector_mobile_widget.dart';
import '../../../../../gen/assets.gen.dart';
import 'user_management_content.dart';

class UserManagementMobileLayout extends StatelessWidget with UserManagementPermissionMixin {
  const UserManagementMobileLayout({
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
    return UserManagementContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: DigifyMobileTabHeader(
        title: 'User Management',
        trailing: canCreateUser
            ? AppMobileButton.primary(
                svgPath: Assets.icons.addNewIconFigma.path,
                onPressed: () => onCreateUserPressed!(),
              )
            : null,
      ),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
