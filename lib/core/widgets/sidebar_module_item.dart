import 'package:flutter/material.dart';

import 'package:digify_core/permissions/perm_module.dart';
import 'package:digify_core/permissions/permission_service.dart';
import 'sidebar_submodule_item.dart';

class SidebarModuleItem extends StatelessWidget {
  const SidebarModuleItem({super.key, required this.module});

  final PermModule module;

  @override
  Widget build(BuildContext context) {
    final visibleSubModules = module.subModules
        .where(PermissionService.instance.canSeeSubModule)
        .toList();

    return ExpansionTile(
      title: Text(module.label),
      children: visibleSubModules
          .map((sub) => SidebarSubModuleItem(sub: sub))
          .toList(),
    );
  }
}
