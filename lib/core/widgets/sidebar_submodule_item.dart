import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../permissions/perm_module.dart';

class SidebarSubModuleItem extends StatelessWidget {
  const SidebarSubModuleItem({super.key, required this.sub});

  final PermSubModule sub;

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;
    final isActive = currentRoute == sub.route;

    return ListTile(
      dense: true,
      selected: isActive,
      title: Text(sub.label),
      onTap: () => context.go(sub.route),
    );
  }
}
