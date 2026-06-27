import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/employee_management/presentation/widgets/add_employee_steps/digify_style_org_level_field.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_unit_providers.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/enterprise_structure_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnterpriseStructureFields extends ConsumerStatefulWidget {
  final AppLocalizations localizations;
  final Map<String, String?> selectedUnitIds;
  final Map<String, OrgUnit>? initialSelections;
  final Function(String levelCode, String? unitId) onSelectionChanged;

  const EnterpriseStructureFields({
    super.key,
    required this.localizations,
    required this.selectedUnitIds,
    required this.onSelectionChanged,
    this.initialSelections,
  });

  @override
  ConsumerState<EnterpriseStructureFields> createState() => _EnterpriseStructureFieldsState();
}

class _EnterpriseStructureFieldsState extends ConsumerState<EnterpriseStructureFields> {
  StateNotifierProvider<EnterpriseSelectionNotifier, EnterpriseSelectionState>? _cachedSelectionProvider;
  String? _cachedStructureId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentState = ref.read(orgStructureNotifierProvider);
      if (currentState.orgStructure == null && !currentState.isLoading) {
        ref.read(orgStructureNotifierProvider.notifier).fetchOrgStructureLevels();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orgStructureState = ref.watch(orgStructureNotifierProvider);
    final activeLevels = orgStructureState.orgStructure?.activeLevels ?? [];

    if (orgStructureState.isLoading) {
      return const EnterpriseStructureSkeleton();
    }

    if (orgStructureState.error != null) {
      return _buildErrorBox(orgStructureState.error!);
    }

    if (activeLevels.isEmpty) {
      return const SizedBox.shrink();
    }

    final structureId = orgStructureState.orgStructure!.structureId;

    if (_cachedSelectionProvider == null || _cachedStructureId != structureId) {
      _cachedStructureId = structureId;
      _cachedSelectionProvider = enterpriseSelectionNotifierProvider((levels: activeLevels, structureId: structureId));

      if (widget.initialSelections != null && _cachedSelectionProvider != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(_cachedSelectionProvider!.notifier).initialize(widget.initialSelections!);
        });
      }
    }

    final selectionProvider = _cachedSelectionProvider!;
    final selectionState = ref.watch(selectionProvider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          SizedBox(height: 16.h),
          ...activeLevels.asMap().entries.map((entry) {
            final index = entry.key;
            final level = entry.value;
            final parentLevel = index > 0 ? activeLevels[index - 1] : null;
            final isEnabled = parentLevel == null || selectionState.getSelection(parentLevel.levelCode) != null;

            return Column(
              children: [
                DigifyStyleOrgLevelField(
                  level: level,
                  selectionProvider: selectionProvider,
                  isEnabled: isEnabled,
                  onSelectionChanged: (levelCode, unit) {
                    ref.read(selectionProvider.notifier).selectUnit(levelCode, unit);
                    widget.onSelectionChanged(levelCode, unit?.orgUnitId);
                  },
                ),
                if (index < activeLevels.length - 1) SizedBox(height: 16.h),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Enterprise Structure',
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
    );
  }

  Widget _buildErrorBox(String error) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enterprise Structure',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.error),
          ),
          SizedBox(height: 8.h),
          Text(
            'Failed to load structure levels: $error',
            style: TextStyle(fontSize: 12.sp, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
