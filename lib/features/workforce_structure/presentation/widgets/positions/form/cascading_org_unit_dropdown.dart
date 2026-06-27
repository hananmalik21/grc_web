import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/forms/digify_single_select_dialog.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/common/dialog_components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CascadingOrgUnitDropdown extends ConsumerWidget {
  final OrgStructureLevel level;
  final StateNotifierProvider<EnterpriseSelectionNotifier, EnterpriseSelectionState> selectionProvider;
  final List<OrgStructureLevel> activeLevels;
  final int levelIndex;
  final Function(String levelCode, String? unitId) onSelectionChanged;

  const CascadingOrgUnitDropdown({
    super.key,
    required this.level,
    required this.selectionProvider,
    required this.activeLevels,
    required this.levelIndex,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(selectionProvider);
    final selectedUnit = selectionState.getSelection(level.levelCode);
    final options = selectionState.getOptions(level.levelCode);
    final isLoading = selectionState.isLoading(level.levelCode);
    final error = selectionState.getError(level.levelCode);

    final isFirstLevel = levelIndex == 0;
    final isEnabled =
        isFirstLevel || (levelIndex > 0 && selectionState.getSelection(activeLevels[levelIndex - 1].levelCode) != null);

    return PositionLabeledField(
      label: level.getLabel(),
      isRequired: level.isMandatory,
      child: InkWell(
        onTap: isEnabled
            ? () async {
                if (options.isEmpty && !isLoading && error == null) {
                  ref.read(selectionProvider.notifier).loadOptionsForLevel(level.levelCode);
                }

                final result = await showDialog<OrgUnit>(
                  context: context,
                  barrierDismissible: false,
                  builder: (dialogContext) => Consumer(
                    builder: (ctx, dialogRef, _) {
                      final state = dialogRef.watch(selectionProvider);
                      final dialogOptions = state.getOptions(level.levelCode);
                      final dialogIsLoading = state.isLoading(level.levelCode);
                      final dialogError = state.getError(level.levelCode);
                      final currentPage = state.getPage(level.levelCode);
                      final totalPages = state.getTotalPages(level.levelCode);
                      final totalItems = state.getTotalItems(level.levelCode);
                      final pageSize = state.getPageSize(level.levelCode);
                      final hasNext = state.hasNext(level.levelCode);
                      final hasPrevious = state.hasPrevious(level.levelCode);
                      final dialogSelectedUnit = state.getSelection(level.levelCode);

                      return DigifySingleSelectDialog<OrgUnit>(
                        title: level.levelName,
                        subtitle: 'Select ${level.levelName}',
                        items: dialogOptions,
                        selectedId: dialogSelectedUnit?.orgUnitId,
                        idBuilder: (unit) => unit.orgUnitId,
                        labelBuilder: (unit) => unit.orgUnitNameEn,
                        descriptionBuilder: (unit) => unit.orgUnitCode,
                        isLoading: dialogIsLoading,
                        errorMessage: dialogError,
                        onRetry: () => dialogRef.read(selectionProvider.notifier).loadOptionsForLevel(level.levelCode),
                        pagination: DigifySingleSelectPagination(
                          currentPage: currentPage,
                          totalPages: totalPages,
                          totalItems: totalItems,
                          pageSize: pageSize,
                          hasNext: hasNext,
                          hasPrevious: hasPrevious,
                        ),
                        onPreviousPage: hasPrevious
                            ? () =>
                                  dialogRef.read(selectionProvider.notifier).goToPage(level.levelCode, currentPage - 1)
                            : null,
                        onNextPage: hasNext
                            ? () =>
                                  dialogRef.read(selectionProvider.notifier).goToPage(level.levelCode, currentPage + 1)
                            : null,
                        onPageTap: (page) => dialogRef.read(selectionProvider.notifier).goToPage(level.levelCode, page),
                      );
                    },
                  ),
                );

                if (result != null) {
                  onSelectionChanged(level.levelCode, result.orgUnitId);
                }
              }
            : null,
        child: Container(
          height: 48.h,
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
                  selectedUnit?.orgUnitNameEn ?? 'Select ${level.levelName}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: selectedUnit != null
                        ? AppColors.textPrimary
                        : AppColors.textSecondary.withValues(alpha: 0.6),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: isEnabled ? AppColors.textSecondary : AppColors.textSecondary.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
