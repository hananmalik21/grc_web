import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DigifyStyleOrgLevelField extends ConsumerWidget {
  const DigifyStyleOrgLevelField({
    super.key,
    required this.level,
    required this.selectionProvider,
    required this.isEnabled,
    this.displayLabel,
    this.showLabel = true,
    this.preselectedUnitId,
    this.levelIsRequired = true,
    required this.onSelectionChanged,
  });

  final OrgStructureLevel level;
  final dynamic selectionProvider;
  final bool isEnabled;
  final String? displayLabel;
  final bool showLabel;
  final String? preselectedUnitId;
  final bool levelIsRequired;
  final void Function(String levelCode, OrgUnit? unit) onSelectionChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(selectionProvider);
    final selectedUnit = selectionState.getSelection(level.levelCode);
    final options = selectionState.getOptions(level.levelCode) as List<OrgUnit>;
    final isLoading = selectionState.isLoading(level.levelCode) as bool;
    final error = selectionState.getError(level.levelCode) as String?;
    final label = displayLabel ?? selectedUnit?.orgUnitNameEn ?? 'Select ${level.levelName}';
    final dialogSelectedUnitId = selectedUnit?.orgUnitId;

    final content = InkWell(
      onTap: isEnabled
          ? () async {
              if (options.isEmpty && !isLoading && error == null) {
                ref.read(selectionProvider.notifier).loadOptionsForLevel(level.levelCode);
              }
              final OrgUnit? result;
              final liveDialog = _LiveOrgLevelDialog(
                selectionProvider: selectionProvider,
                level: level,
                initialSelectedId: dialogSelectedUnitId,
              );
              result = await DigifySingleSelectDialog.showAdaptive<OrgUnit>(
                context: context,
                child: liveDialog,
                barrierDismissible: false,
              );
              if (result != null) {
                onSelectionChanged(level.levelCode, result);
              }
            }
          : null,
      child: Container(
        height: 40.w,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: isEnabled ? Colors.white : AppColors.inputBg.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: error != null ? AppColors.error : AppColors.borderGrey),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: (displayLabel != null && displayLabel!.isNotEmpty) || selectedUnit != null
                      ? AppColors.textPrimary
                      : AppColors.textSecondary.withValues(alpha: 0.6),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            DigifyAsset(
              assetPath: Assets.icons.workforce.chevronRight.path,
              color: isEnabled ? AppColors.textSecondary : AppColors.textSecondary.withValues(alpha: 0.3),
              height: 15,
            ),
          ],
        ),
      ),
    );

    if (showLabel) {
      return PositionLabeledField(label: level.getLabel(), isRequired: levelIsRequired, child: content);
    }
    return content;
  }
}

class _LiveOrgLevelDialog extends ConsumerWidget {
  const _LiveOrgLevelDialog({required this.selectionProvider, required this.level, required this.initialSelectedId});

  final dynamic selectionProvider;
  final OrgStructureLevel level;
  final String? initialSelectedId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(selectionProvider);
    final options = state.getOptions(level.levelCode) as List<OrgUnit>;
    final isLoading = state.isLoading(level.levelCode) as bool;
    final error = state.getError(level.levelCode) as String?;
    final currentPage = state.getPage(level.levelCode) as int;
    final totalPages = state.getTotalPages(level.levelCode) as int;
    final totalItems = state.getTotalItems(level.levelCode) as int;
    final pageSize = state.getPageSize(level.levelCode) as int;
    final hasNext = state.hasNext(level.levelCode) as bool;
    final hasPrevious = state.hasPrevious(level.levelCode) as bool;

    return DigifySingleSelectDialog<OrgUnit>(
      title: level.levelName,
      subtitle: 'Select ${level.levelName}',
      items: options,
      selectedId: initialSelectedId,
      idBuilder: (unit) => unit.orgUnitId,
      labelBuilder: (unit) => unit.orgUnitNameEn,
      descriptionBuilder: (unit) => unit.orgUnitCode,
      isLoading: isLoading,
      errorMessage: error,
      onRetry: () => ref.read(selectionProvider.notifier).loadOptionsForLevel(level.levelCode),
      pagination: DigifySingleSelectPagination(
        currentPage: currentPage,
        totalPages: totalPages,
        totalItems: totalItems,
        pageSize: pageSize,
        hasNext: hasNext,
        hasPrevious: hasPrevious,
      ),
      onPreviousPage: hasPrevious
          ? () => ref.read(selectionProvider.notifier).goToPage(level.levelCode, currentPage - 1)
          : null,
      onNextPage: hasNext
          ? () => ref.read(selectionProvider.notifier).goToPage(level.levelCode, currentPage + 1)
          : null,
      onPageTap: (page) => ref.read(selectionProvider.notifier).goToPage(level.levelCode, page),
    );
  }
}
