import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/digify_style_org_level_field.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/requisitions_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/create_requisition_org_structure_skeleton.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

OrgUnit? deepestOrgSelection(EnterpriseSelectionState state, List<OrgStructureLevel> levels) {
  for (var i = levels.length - 1; i >= 0; i--) {
    final u = state.getSelection(levels[i].levelCode);
    if (u != null) return u;
  }
  return null;
}

Map<String, OrgUnit> orgLevelSelectionsMap(EnterpriseSelectionState state, List<OrgStructureLevel> levels) {
  final map = <String, OrgUnit>{};
  for (final level in levels) {
    final unit = state.getSelection(level.levelCode);
    if (unit != null) {
      map[level.levelCode] = unit;
    }
  }
  return map;
}

class CreateRequisitionDepartmentOrgFields extends ConsumerStatefulWidget {
  const CreateRequisitionDepartmentOrgFields({super.key, required this.scope});

  final CreateRequisitionOrgSelectionScope scope;

  @override
  ConsumerState<CreateRequisitionDepartmentOrgFields> createState() => _CreateRequisitionDepartmentOrgFieldsState();
}

class _CreateRequisitionDepartmentOrgFieldsState extends ConsumerState<CreateRequisitionDepartmentOrgFields> {
  StateNotifierProvider<EnterpriseSelectionNotifier, EnterpriseSelectionState>? _selectionProvider;
  String _cacheKey = '';
  bool _orgSelectionSynced = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orgState = ref.read(createRequisitionOrgStructureNotifierProvider);
      if (orgState.orgStructure == null && !orgState.isLoading) {
        ref.read(createRequisitionOrgStructureNotifierProvider.notifier).fetchOrgStructureLevels();
      }
    });
  }

  void _syncOrgSelectionsToProvider({
    required List<OrgStructureLevel> activeLevels,
    required StateNotifierProvider<EnterpriseSelectionNotifier, EnterpriseSelectionState> selectionProvider,
  }) {
    if (_orgSelectionSynced) return;

    final createState = ref.read(createRequisitionProvider);
    final selectionState = ref.read(selectionProvider);
    final hasSelection = activeLevels.any((level) => selectionState.getSelection(level.levelCode) != null);
    if (hasSelection) {
      _orgSelectionSynced = true;
      ref.read(createRequisitionProvider.notifier).clearOrgPrefillPaths(scope: widget.scope);
      return;
    }

    final prefillPath = switch (widget.scope) {
      CreateRequisitionOrgSelectionScope.basicInfo => createState.basicInfoOrgPrefillPath,
      CreateRequisitionOrgSelectionScope.justification => createState.justificationOrgPrefillPath,
    };
    final savedSelections = switch (widget.scope) {
      CreateRequisitionOrgSelectionScope.basicInfo => createState.basicInfoOrgLevelSelections,
      CreateRequisitionOrgSelectionScope.justification => createState.justificationOrgLevelSelections,
    };

    Map<String, OrgUnit> selectionsToApply = const {};
    var clearPrefillPath = false;
    if (prefillPath.isNotEmpty) {
      selectionsToApply = {for (final unit in prefillPath) unit.levelCode: unit};
      clearPrefillPath = true;
    } else if (savedSelections.isNotEmpty) {
      selectionsToApply = savedSelections;
    }

    _orgSelectionSynced = true;
    if (selectionsToApply.isEmpty) return;

    final notifier = ref.read(createRequisitionProvider.notifier);
    ref.read(selectionProvider.notifier).initialize(selectionsToApply);
    notifier.setOrgLevelSelections(widget.scope, selectionsToApply);

    final after = ref.read(selectionProvider);
    final deepest = deepestOrgSelection(after, activeLevels);
    switch (widget.scope) {
      case CreateRequisitionOrgSelectionScope.basicInfo:
        notifier.setSelectedDepartmentOrgUnit(deepest);
      case CreateRequisitionOrgSelectionScope.justification:
        notifier.setSelectedJustificationOrgUnit(deepest);
    }

    if (clearPrefillPath) {
      notifier.clearOrgPrefillPaths(scope: widget.scope);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enterpriseId = ref.watch(requisitionsTabEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      return Text(
        l10n.hiringCreateRequisitionEnterpriseMissing,
        style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      );
    }

    final orgState = ref.watch(createRequisitionOrgStructureNotifierProvider);

    if (orgState.isLoading) {
      return const CreateRequisitionOrgStructureFieldsSkeleton();
    }

    if (orgState.error != null) {
      return Text(
        l10n.hiringCreateRequisitionDepartmentOrgLoadError(orgState.error!),
        style: context.textTheme.bodySmall?.copyWith(color: AppColors.error),
      );
    }

    final activeLevels = orgState.orgStructure?.activeLevels ?? [];

    if (activeLevels.isEmpty) {
      return Text(
        l10n.hiringCreateRequisitionOrgStructureLevelsEmpty,
        style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      );
    }

    final structureId = orgState.orgStructure!.structureId;
    final nextKey = '${widget.scope.name}|$structureId|${activeLevels.map((l) => l.levelCode).join('|')}';
    if (_selectionProvider == null || _cacheKey != nextKey) {
      _cacheKey = nextKey;
      _orgSelectionSynced = false;
      _selectionProvider = createRequisitionEnterpriseSelectionProvider((
        scope: widget.scope,
        levels: activeLevels,
        structureId: structureId,
      ));
    }

    final selectionProvider = _selectionProvider!;
    final selectionState = ref.watch(selectionProvider);
    ref.watch(createRequisitionProvider.select((s) => s.isEditHydrated));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncOrgSelectionsToProvider(activeLevels: activeLevels, selectionProvider: selectionProvider);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...activeLevels.asMap().entries.map((entry) {
          final index = entry.key;
          final level = entry.value;
          final parentLevel = index > 0 ? activeLevels[index - 1] : null;
          final isEnabled = parentLevel == null || selectionState.getSelection(parentLevel.levelCode) != null;

          return Padding(
            padding: EdgeInsets.only(bottom: index < activeLevels.length - 1 ? 12.h : 0),
            child: DigifyStyleOrgLevelField(
              level: level,
              selectionProvider: selectionProvider,
              isEnabled: isEnabled,
              levelIsRequired: false,
              displayLabel: null,
              onSelectionChanged: (levelCode, unit) {
                ref.read(selectionProvider.notifier).selectUnit(levelCode, unit);
                final after = ref.read(selectionProvider);
                final selections = orgLevelSelectionsMap(after, activeLevels);
                final deepest = deepestOrgSelection(after, activeLevels);
                final notifier = ref.read(createRequisitionProvider.notifier);
                notifier.setOrgLevelSelections(widget.scope, selections);
                switch (widget.scope) {
                  case CreateRequisitionOrgSelectionScope.basicInfo:
                    notifier.setSelectedDepartmentOrgUnit(deepest);
                  case CreateRequisitionOrgSelectionScope.justification:
                    notifier.setSelectedJustificationOrgUnit(deepest);
                }
              },
            ),
          );
        }),
      ],
    );
  }
}
