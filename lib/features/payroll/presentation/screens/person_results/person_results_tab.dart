import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/payroll/presentation/screens/person_results/mixins/person_results_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'layouts/person_results_desktop_layout.dart';
import 'layouts/person_results_mobile_layout.dart';
import 'layouts/person_results_tablet_layout.dart';

class PersonResultsTab extends ConsumerStatefulWidget {
  const PersonResultsTab({super.key});

  @override
  ConsumerState<PersonResultsTab> createState() => _PersonResultsTabState();
}

class _PersonResultsTabState extends ConsumerState<PersonResultsTab> with PersonResultsPermissionMixin {
  @override
  Widget build(BuildContext context) {
    final layout = context.screenLayout;

    if (!canViewPersonResults) {
      return const AppUnauthorizedState();
    }

    if (layout.isMobile) {
      return const PersonResultsMobileLayout();
    }

    if (layout.isTablet) {
      return const PersonResultsTabletLayout();
    }

    return const PersonResultsDesktopLayout();
  }
}
