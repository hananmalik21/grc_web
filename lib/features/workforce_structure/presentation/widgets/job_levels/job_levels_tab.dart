import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_levels_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_levels/job_levels_permission_mixin.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_level_providers.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_levels/job_levels_desktop_layout.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_levels/job_levels_mobile_layout.dart';
import 'package:grc/features/workforce_structure/presentation/screens/job_levels/job_levels_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JobLevelsTab extends ConsumerStatefulWidget {
  const JobLevelsTab({super.key});

  @override
  ConsumerState<JobLevelsTab> createState() => _JobLevelsTabState();
}

class _JobLevelsTabState extends ConsumerState<JobLevelsTab> with JobLevelsPermissionMixin {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(jobLevelNotifierProvider.notifier).refresh());
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(jobLevelsSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  @override
  Widget build(BuildContext context) {
    final selectedEnterpriseId = ref.watch(jobLevelsEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (!canViewJobLevel) return const AppUnauthorizedState();

    if (layout.isMobile) {
      return JobLevelsMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    if (layout.isTablet) {
      return JobLevelsTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    return JobLevelsDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
    );
  }
}
