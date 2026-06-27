import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/common/app_unauthorized_state.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_structure_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:grc/features/workforce_structure/presentation/screens/grade_structure/grade_structure_desktop_layout.dart';
import 'package:grc/features/workforce_structure/presentation/screens/grade_structure/grade_structure_mobile_layout.dart';
import 'package:grc/features/workforce_structure/presentation/screens/grade_structure/grade_structure_permission_mixin.dart';
import 'package:grc/features/workforce_structure/presentation/screens/grade_structure/grade_structure_tablet_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GradeStructureTab extends ConsumerStatefulWidget {
  const GradeStructureTab({super.key});

  @override
  ConsumerState<GradeStructureTab> createState() => _GradeStructureTabState();
}

class _GradeStructureTabState extends ConsumerState<GradeStructureTab> with GradeStructurePermissionMixin {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(gradeNotifierProvider.notifier).refresh());
  }

  void _onEnterpriseChanged(int? enterpriseId) {
    ref.read(gradeStructureSelectedEnterpriseProvider.notifier).setEnterpriseId(enterpriseId);
  }

  @override
  Widget build(BuildContext context) {
    final selectedEnterpriseId = ref.watch(gradeStructureEnterpriseIdProvider);
    final layout = context.screenLayout;

    if (!canViewGrade) return const AppUnauthorizedState();

    if (layout.isMobile) {
      return GradeStructureMobileLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    if (layout.isTablet) {
      return GradeStructureTabletLayout(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: _onEnterpriseChanged,
      );
    }

    return GradeStructureDesktopLayout(
      selectedEnterpriseId: selectedEnterpriseId,
      onEnterpriseChanged: _onEnterpriseChanged,
    );
  }
}
