import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_structure_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_families_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/job_levels_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/positions_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_tree_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/reporting_structure_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/common/workforce_tab_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkforceTabEnterpriseSelector extends ConsumerWidget {
  final WorkforceTab tab;

  const WorkforceTabEnterpriseSelector({super.key, required this.tab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (tab) {
      case WorkforceTab.positions:
        return _Selector(
          enterpriseId: ref.watch(positionsEnterpriseIdProvider),
          onChanged: (id) => ref.read(positionsSelectedEnterpriseProvider.notifier).setEnterpriseId(id),
        );
      case WorkforceTab.jobFamilies:
        return _Selector(
          enterpriseId: ref.watch(jobFamiliesEnterpriseIdProvider),
          onChanged: (id) => ref.read(jobFamiliesSelectedEnterpriseProvider.notifier).setEnterpriseId(id),
        );
      case WorkforceTab.jobLevels:
        return _Selector(
          enterpriseId: ref.watch(jobLevelsEnterpriseIdProvider),
          onChanged: (id) => ref.read(jobLevelsSelectedEnterpriseProvider.notifier).setEnterpriseId(id),
        );
      case WorkforceTab.gradeStructure:
        return _Selector(
          enterpriseId: ref.watch(gradeStructureEnterpriseIdProvider),
          onChanged: (id) => ref.read(gradeStructureSelectedEnterpriseProvider.notifier).setEnterpriseId(id),
        );
      case WorkforceTab.reportingStructure:
        return _Selector(
          enterpriseId: ref.watch(reportingStructureEnterpriseIdProvider),
          onChanged: (id) => ref.read(reportingStructureSelectedEnterpriseProvider.notifier).setEnterpriseId(id),
        );
      case WorkforceTab.positionTree:
        return _Selector(
          enterpriseId: ref.watch(positionTreeEnterpriseIdProvider),
          onChanged: (id) => ref.read(positionTreeSelectedEnterpriseProvider.notifier).setEnterpriseId(id),
        );
    }
  }
}

class _Selector extends StatelessWidget {
  final int? enterpriseId;
  final ValueChanged<int?> onChanged;

  const _Selector({required this.enterpriseId, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return EnterpriseSelectorWidget(selectedEnterpriseId: enterpriseId, onEnterpriseChanged: onChanged);
  }
}
