import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/features/security_manager/presentation/providers/application_roles/application_roles_state.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_provider.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/application_roles_detail_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ApplicationRoleDetailMobileSheet extends ConsumerWidget {
  const ApplicationRoleDetailMobileSheet({super.key, required this.role});

  final ApplicationRoleItem role;

  static Future<void> show(BuildContext context, ApplicationRoleItem role) async {
    await DigifyBottomSheet.show(
      context,
      type: DigifyBottomSheetType.custom,
      title: role.name,
      child: ApplicationRoleDetailMobileSheet(role: role),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rolesManagementProvider.notifier).selectRole(role.id);
    });

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: ApplicationRolesDetailContent(selectedListingRole: role, onBack: () => context.pop(), showHeader: false),
    );
  }
}
