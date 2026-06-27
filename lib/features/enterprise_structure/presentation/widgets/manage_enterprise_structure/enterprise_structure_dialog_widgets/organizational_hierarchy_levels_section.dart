import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/enterprise_structure_dialog_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/shared/hierarchy_level_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'enterprise_structure_dialog_mode.dart';

class OrganizationalHierarchyLevelsSection extends ConsumerWidget {
  final EnterpriseStructureDialogMode mode;
  final List<HierarchyLevel> levels;
  final EditEnterpriseStructureState formState;
  final EditEnterpriseStructureNotifier formNotifier;
  final EnterpriseStructureDialogState? dialogState;

  const OrganizationalHierarchyLevelsSection({
    super.key,
    required this.mode,
    required this.levels,
    required this.formState,
    required this.formNotifier,
    this.dialogState,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.organizationalHierarchyLevels,
              style: context.textTheme.titleSmall?.copyWith(
                fontSize: 15.sp,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            if (mode != EnterpriseStructureDialogMode.view && dialogState != null)
              GestureDetector(
                onTap: () {
                  final api = dialogState!.toHierarchyLevels(localizations);
                  if (api.isNotEmpty) {
                    formNotifier.resetToDefault(api);
                  }
                },
                child: Text(
                  localizations.resetToDefault,
                  style: context.textTheme.bodySmall?.copyWith(fontSize: 13.sp, color: AppColors.primary),
                ),
              ),
          ],
        ),
        Gap(16.h),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          buildDefaultDragHandles: false,
          itemCount: levels.length,
          // ignore: deprecated_member_use
          onReorder: (oldIndex, newIndex) {
            if (mode == EnterpriseStructureDialogMode.view) {
              return;
            }

            if (oldIndex < 0 || oldIndex >= levels.length) return;
            if (levels[oldIndex].isMandatory) return;

            int target = newIndex;
            if (target > oldIndex) target -= 1;

            if (target < 0) target = 0;
            if (target >= levels.length) target = levels.length - 1;

            if (levels[target].isMandatory) {
              final int dir = (target > oldIndex) ? 1 : -1;
              int scan = target;
              while (scan >= 0 && scan < levels.length && levels[scan].isMandatory) {
                scan += dir;
              }
              if (scan < 0 || scan >= levels.length) {
                scan = target;
                while (scan >= 0 && scan < levels.length && levels[scan].isMandatory) {
                  scan -= dir;
                }
              }
              if (scan < 0 || scan >= levels.length) return;
              target = scan;
            }

            formNotifier.reorderLevels(oldIndex, target);
          },
          itemBuilder: (context, index) {
            final level = levels[index];
            final canEdit = mode != EnterpriseStructureDialogMode.view;

            final card = HierarchyLevelCard(
              name: level.name,
              icon: level.icon,
              levelNumber: level.level,
              isMandatory: level.isMandatory,
              isActive: level.isActive,
              canMoveUp: index > 0,
              canMoveDown: index < levels.length - 1,
              onMoveUp: canEdit ? () => formNotifier.moveLevelUp(index) : null,
              onMoveDown: canEdit ? () => formNotifier.moveLevelDown(index) : null,
              onToggleActive: canEdit ? (_) => formNotifier.toggleLevelActive(index) : null,
              showArrows: mode != EnterpriseStructureDialogMode.view,
            );

            if (level.isMandatory || mode == EnterpriseStructureDialogMode.view) {
              return Padding(
                key: ValueKey(level.id),
                padding: EdgeInsetsDirectional.only(bottom: 12.h),
                child: card,
              );
            }

            return Padding(
              key: ValueKey(level.id),
              padding: EdgeInsetsDirectional.only(bottom: 12.h),
              child: ReorderableDragStartListener(index: index, child: card),
            );
          },
        ),
      ],
    );
  }
}
