import 'package:grc/core/navigation/app_header.dart';
import 'package:grc/core/navigation/sidebar/sidebar.dart';
import 'package:grc/core/navigation/sidebar/sidebar_provider.dart';
import 'package:grc/core/permissions/permission_service.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/keyboard_scroll_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLayout extends ConsumerWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(appInitializationAfterAuthProvider);
    ref.watch(permissionsBootstrapProvider);
    final isDesktop = ref.screenLayout.isDesktop;
    final isSidebarExpanded = ref.watch(sidebarProvider);
    final useDrawer = !isDesktop;

    return Scaffold(
      onDrawerChanged: useDrawer
          ? (bool isOpened) {
              if (!isOpened) ref.read(sidebarProvider.notifier).collapse();
            }
          : null,
      body: Row(
        children: [
          if (!useDrawer) const Sidebar(),
          Expanded(
            child: Column(
              children: [
                AppHeader(isSidebarExpanded: isSidebarExpanded),
                Expanded(child: AppKeyboardScroller(child: child)),
              ],
            ),
          ),
        ],
      ),
      drawer: useDrawer ? const Sidebar() : null,
    );
  }
}
