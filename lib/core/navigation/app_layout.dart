import 'package:grc/core/navigation/app_header.dart';
import 'package:grc/core/navigation/sidebar/sidebar.dart';
import 'package:grc/core/navigation/sidebar/sidebar_provider.dart';
import 'package:grc/core/permissions/permission_service.dart';
import 'package:grc/core/services/initialization/providers/initialization_providers.dart';
import 'package:grc/core/widgets/common/keyboard_scroll_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLayout extends ConsumerWidget {
  final Widget child;

  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(enterpriseBootstrapProvider);
    ref.read(appInitializationAfterAuthProvider);
    ref.watch(permissionsBootstrapProvider);
    final width = MediaQuery.sizeOf(context).width;
    final isSidebarExpanded = ref.watch(sidebarProvider);
    final useDrawer = width < 900;

    return Scaffold(
      onDrawerChanged: useDrawer
          ? (bool isOpened) {
              if (!isOpened) ref.read(sidebarProvider.notifier).collapse();
            }
          : null,
      body: Stack(
        children: [
          Row(
            children: [
              if (!useDrawer)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  width: isSidebarExpanded ? 260.0 : 72.0,
                ),
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
          if (!useDrawer)
            const Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Sidebar(),
            ),
        ],
      ),
      drawer: useDrawer ? const Sidebar() : null,
    );
  }
}
