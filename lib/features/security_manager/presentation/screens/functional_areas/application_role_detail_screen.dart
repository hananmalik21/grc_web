import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/security_manager/presentation/providers/application_roles/application_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/application_roles_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ApplicationRoleDetailScreen extends ConsumerWidget {
  const ApplicationRoleDetailScreen({super.key, required this.role});

  final ApplicationRoleItem role;

  static const routeName = 'security-manager-application-role-detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rolesManagementProvider.notifier).selectRole(role.id);
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.tableHeaderBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: ApplicationRolesDetailContent(selectedListingRole: role, onBack: context.pop),
        ),
      ),
    );
  }
}
