import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/digify_style_org_level_field.dart';
import 'package:grc/features/hiring/presentation/providers/offers/create_offer/create_offer_provider.dart';
import 'package:grc/features/hiring/presentation/providers/offers/offers_tab_enterprise_provider.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/widgets/create_requisition_org_structure_skeleton.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

OrgUnit? _deepestOfferOrgSelection(EnterpriseSelectionState state, List<OrgStructureLevel> levels) {
  for (var i = levels.length - 1; i >= 0; i--) {
    final unit = state.getSelection(levels[i].levelCode);
    if (unit != null) return unit;
  }
  return null;
}

Map<String, OrgUnit> _offerOrgLevelSelectionsMap(EnterpriseSelectionState state, List<OrgStructureLevel> levels) {
  final map = <String, OrgUnit>{};
  for (final level in levels) {
    final unit = state.getSelection(level.levelCode);
    if (unit != null) {
      map[level.levelCode] = unit;
    }
  }
  return map;
}

class CreateOfferDepartmentOrgFields extends ConsumerStatefulWidget {
  const CreateOfferDepartmentOrgFields({super.key});

  @override
  ConsumerState<CreateOfferDepartmentOrgFields> createState() => _CreateOfferDepartmentOrgFieldsState();
}

class _CreateOfferDepartmentOrgFieldsState extends ConsumerState<CreateOfferDepartmentOrgFields> {
  StateNotifierProvider<EnterpriseSelectionNotifier, EnterpriseSelectionState>? _selectionProvider;
  String _cacheKey = '';
  bool _orgSelectionSynced = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orgState = ref.read(createOfferOrgStructureNotifierProvider);
      if (orgState.orgStructure == null && !orgState.isLoading) {
        ref.read(createOfferOrgStructureNotifierProvider.notifier).fetchOrgStructureLevels();
      }
    });
  }

  void _syncOrgSelectionsToProvider({
    required List<OrgStructureLevel> activeLevels,
    required StateNotifierProvider<EnterpriseSelectionNotifier, EnterpriseSelectionState> selectionProvider,
  }) {
    if (_orgSelectionSynced) return;

    final offerState = ref.read(createOfferProvider);
    final selectionState = ref.read(selectionProvider);
    final hasSelection = activeLevels.any((level) => selectionState.getSelection(level.levelCode) != null);
    if (hasSelection) {
      _orgSelectionSynced = true;
      ref.read(createOfferProvider.notifier).clearOrgPrefillPath();
      return;
    }

    Map<String, OrgUnit> selectionsToApply = const {};
    var clearPrefillPath = false;
    if (offerState.orgPrefillPath.isNotEmpty) {
      selectionsToApply = {for (final unit in offerState.orgPrefillPath) unit.levelCode: unit};
      clearPrefillPath = true;
    } else if (offerState.orgLevelSelections.isNotEmpty) {
      selectionsToApply = offerState.orgLevelSelections;
    }

    _orgSelectionSynced = true;
    if (selectionsToApply.isEmpty) return;

    final notifier = ref.read(createOfferProvider.notifier);
    ref.read(selectionProvider.notifier).initialize(selectionsToApply);
    notifier.setOrgLevelSelections(selectionsToApply);

    final after = ref.read(selectionProvider);
    notifier.setSelectedDepartmentOrgUnit(_deepestOfferOrgSelection(after, activeLevels));

    if (clearPrefillPath) {
      notifier.clearOrgPrefillPath();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final enterpriseId = ref.watch(offersTabEnterpriseIdProvider);
    if (enterpriseId == null || enterpriseId <= 0) {
      return Text(
        l10n.hiringCreateRequisitionEnterpriseMissing,
        style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      );
    }

    final orgState = ref.watch(createOfferOrgStructureNotifierProvider);

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
    final nextKey = '$structureId|${activeLevels.map((l) => l.levelCode).join('|')}';
    if (_selectionProvider == null || _cacheKey != nextKey) {
      _cacheKey = nextKey;
      _orgSelectionSynced = false;
      _selectionProvider = createOfferEnterpriseSelectionProvider((levels: activeLevels, structureId: structureId));
    }

    final selectionProvider = _selectionProvider!;
    final selectionState = ref.watch(selectionProvider);

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
                final selections = _offerOrgLevelSelectionsMap(after, activeLevels);
                final deepest = _deepestOfferOrgSelection(after, activeLevels);
                final notifier = ref.read(createOfferProvider.notifier);
                notifier.setOrgLevelSelections(selections);
                notifier.setSelectedDepartmentOrgUnit(deepest);
              },
            ),
          );
        }),
      ],
    );
  }
}
