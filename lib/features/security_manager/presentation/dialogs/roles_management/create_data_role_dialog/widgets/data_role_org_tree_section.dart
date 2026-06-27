import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/security_manager/domain/models/org_selection_node.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/create_data_role_form_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/security_console_overview/security_manager_enterprise_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_multi_select_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DataRoleOrgTreeSection extends ConsumerWidget {
  const DataRoleOrgTreeSection({super.key, required this.levels, required this.structureId});

  final List<OrgStructureLevel> levels;
  final String structureId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selections = ref.watch(createDataRoleFormProvider.select((s) => s.orgSelections));

    return _OrgLevelSection(
      levelIndex: 0,
      levels: levels,
      structureId: structureId,
      parentUnitId: null,
      currentSelections: selections,
    );
  }
}

class _OrgLevelSection extends ConsumerWidget {
  const _OrgLevelSection({
    required this.levelIndex,
    required this.levels,
    required this.structureId,
    required this.parentUnitId,
    required this.currentSelections,
  });

  final int levelIndex;
  final List<OrgStructureLevel> levels;
  final String structureId;
  final String? parentUnitId;
  final List<OrgSelectionNode> currentSelections;

  Future<void> _openPicker(BuildContext context, WidgetRef ref) async {
    final level = levels[levelIndex];
    final tenantId = ref.read(securityManagerEnterpriseIdProvider);
    final preSelectedIds = currentSelections.map((n) => n.unitId).toSet();

    final result = await OrgUnitMultiSelectDialog.show(
      context: context,
      levelName: level.levelName,
      pickerKey: (structureId: structureId, levelCode: level.levelCode, parentUnitId: parentUnitId, tenantId: tenantId),
      preSelectedIds: preSelectedIds,
    );

    if (result == null) return;

    final newNodes = result
        .map(
          (u) => OrgSelectionNode(
            levelCode: level.levelCode,
            levelName: level.levelName,
            unitId: u.orgUnitId,
            unitName: u.orgUnitNameEn,
          ),
        )
        .toList();

    ref
        .read(createDataRoleFormProvider.notifier)
        .updateOrgSelections(parentUnitId: parentUnitId, newSelections: newNodes);
  }

  void _removeNode(WidgetRef ref, String unitId) {
    final updated = currentSelections.where((n) => n.unitId != unitId).toList();
    ref
        .read(createDataRoleFormProvider.notifier)
        .updateOrgSelections(parentUnitId: parentUnitId, newSelections: updated);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (levelIndex >= levels.length) return const SizedBox.shrink();

    final level = levels[levelIndex];
    final hasNextLevel = levelIndex < levels.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected nodes
        for (final node in currentSelections) ...[
          _SelectedNodeCard(
            node: node,
            onRemove: () => _removeNode(ref, node.unitId),
            child: hasNextLevel
                ? _OrgLevelSection(
                    levelIndex: levelIndex + 1,
                    levels: levels,
                    structureId: structureId,
                    parentUnitId: node.unitId,
                    currentSelections: node.children,
                  )
                : null,
          ),
          Gap(8.h),
        ],

        // Add button
        _AddButton(levelName: level.levelName, onTap: () => _openPicker(context, ref)),
      ],
    );
  }
}

class _SelectedNodeCard extends StatelessWidget {
  const _SelectedNodeCard({required this.node, required this.onRemove, this.child});

  final OrgSelectionNode node;
  final VoidCallback onRemove;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 10.h, 8.w, 10.h),
            child: Row(
              children: [
                Icon(Icons.check_circle_rounded, size: 16.sp, color: AppColors.primary),
                Gap(8.w),
                Expanded(
                  child: Text(
                    node.unitName,
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(6.r),
                  child: Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Icon(Icons.close_rounded, size: 16.sp, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),
          ),
          if (child != null) Padding(padding: EdgeInsets.fromLTRB(16.w, 0, 12.w, 12.h), child: child),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.levelName, required this.onTap});

  final String levelName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3), style: BorderStyle.solid),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_rounded, size: 16.sp, color: AppColors.primary),
            Gap(6.w),
            Text(
              'Select $levelName',
              style: TextStyle(fontSize: 13.sp, color: AppColors.primary, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
