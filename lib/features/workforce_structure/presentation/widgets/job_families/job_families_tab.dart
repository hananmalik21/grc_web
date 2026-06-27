import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_families_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_family_providers.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_families/job_families_desktop_layout.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_families/job_families_mobile_layout.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_families/job_families_permission_mixin.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_families/job_families_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobFamiliesTab extends ConsumerStatefulWidget {
  const JobFamiliesTab({super.key});

  @override
  ConsumerState<JobFamiliesTab> createState() => _JobFamiliesTabState();
}

class _JobFamiliesTabState extends ConsumerState<JobFamiliesTab> with JobFamiliesPermissionMixin {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(jobFamilyNotifierProvider.notifier).refresh());
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(jobFamiliesSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  @override
  Widget build(BuildContext context) {
    final selectedEnterpriseId = ref.watch(jobFamiliesEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (!canViewJobFamily) return const AppUnauthorizedState();

    if (layout.isMobile) {
      return JobFamiliesMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    if (layout.isTablet) {
      return JobFamiliesTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    return JobFamiliesDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
    );
  }
}
