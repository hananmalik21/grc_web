import 'package:flutter/material.dart';

import '../permissions/perm_catalog.dart';
import '../permissions/permission_service.dart';
import 'sidebar_module_item.dart';

class SidebarWidget extends StatelessWidget {
  const SidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final visibleModules = kAllModules.where(PermissionService.instance.canSeeModule).toList();

    if (visibleModules.isEmpty) {
      return const Center(child: Text('No accessible modules.'));
    }

    return ListView.builder(
      itemCount: visibleModules.length,
      itemBuilder: (context, index) => SidebarModuleItem(module: visibleModules[index]),
    );
  }
}
