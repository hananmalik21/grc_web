import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/payroll/presentation/screens/element_entries/mixins/element_entries_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'layouts/element_entries_desktop_layout.dart';
import 'layouts/element_entries_mobile_layout.dart';
import 'layouts/element_entries_tablet_layout.dart';

class ElementEntriesTab extends ConsumerStatefulWidget {
  const ElementEntriesTab({super.key});

  @override
  ConsumerState<ElementEntriesTab> createState() => _ElementEntriesTabState();
}

class _ElementEntriesTabState extends ConsumerState<ElementEntriesTab> with ElementEntriesPermissionMixin {
  @override
  Widget build(BuildContext context) {
    final layout = context.screenLayout;

    if (!canViewElementEntries) {
      return const AppUnauthorizedState();
    }

    if (layout.isMobile) {
      return const ElementEntriesMobileLayout();
    }

    if (layout.isTablet) {
      return const ElementEntriesTabletLayout();
    }

    return const ElementEntriesDesktopLayout();
  }
}
