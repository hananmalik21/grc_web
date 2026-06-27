import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/services/responsive_service.dart';
import '../../providers/user_management/user_management_enterprise_provider.dart';
import '../../providers/user_management/user_management_provider.dart';
import 'user_management_desktop_layout.dart';
import 'user_management_mobile_layout.dart';
import 'user_management_tablet_layout.dart';
import 'user_management_permission_mixin.dart';
import 'create_user_mobile_sheet.dart';
import 'create_user_screen.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> with UserManagementPermissionMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userManagementProvider.notifier).getUsers();
    });
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(userManagementSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  Future<void> _onCreateUserPressed() async {
    if (context.isMobileLayout) {
      await CreateUserMobileSheet.show(context);
    } else {
      await context.pushNamed(CreateUserScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedEnterpriseId = ref.watch(userManagementSelectedEnterpriseProvider);
    final layout = context.screenLayout;

    if (!canViewUser) return AppUnauthorizedState();

    if (layout.isMobile) {
      return UserManagementMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreateUserPressed: _onCreateUserPressed,
      );
    }

    if (layout.isTablet) {
      return UserManagementTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
        onCreateUserPressed: _onCreateUserPressed,
      );
    }

    return UserManagementDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
      onCreateUserPressed: _onCreateUserPressed,
    );
  }
}
