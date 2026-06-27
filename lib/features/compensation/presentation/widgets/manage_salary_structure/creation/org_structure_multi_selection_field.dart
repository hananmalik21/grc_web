import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/forms/digify_multi_select_dialog.dart';
import 'package:grc/core/widgets/forms/digify_selection_field_with_label.dart';
import 'package:grc/features/compensation/presentation/providers/manage_salary_structure_enterprise_selection_notifier.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrgStructureMultiSelectionField extends ConsumerWidget {
  final OrgStructureLevel level;
  final StateNotifierProvider<
    ManageSalaryStructureEnterpriseSelectionNotifier,
    ManageSalaryStructureEnterpriseSelectionState
  >
  selectionProvider;
  final bool isEnabled;
  final bool isRequired;
  final List<String> selectedUnitIds;
  final ValueChanged<List<String>> onSelectionChanged;

  const OrgStructureMultiSelectionField({
    super.key,
    required this.level,
    required this.selectionProvider,
    required this.isEnabled,
    this.isRequired = true,
    required this.selectedUnitIds,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(selectionProvider);
    final options = selectionState.getOptions(level.levelCode);
    final isLoading = selectionState.isLoading(level.levelCode);
    final error = selectionState.getError(level.levelCode);
    return DigifyMultiSelectFieldWithLabel(
      label: level.getLabel(),
      hint: 'Select ${level.levelName}',
      selectedCount: selectedUnitIds.length,
      isRequired: isRequired,
      isEnabled: isEnabled,
      borderColor: error != null ? AppColors.error : null,
      backgroundColor: isEnabled ? Colors.white : AppColors.inputBg.withValues(alpha: 0.5),
      onTap: isEnabled
          ? () async {
              if (options.isEmpty && !isLoading) {
                ref.read(selectionProvider.notifier).loadOptionsForLevel(level.levelCode);
              }

              final selected = await DigifyMultiSelectDialog.showAdaptive<List<String>>(
                context: context,
                barrierDismissible: false,
                child: Consumer(
                  builder: (context, ref, _) {
                    final liveState = ref.watch(selectionProvider);
                    final liveOptions = liveState.getOptions(level.levelCode);
                    final liveError = liveState.getError(level.levelCode);
                    final liveLoading = liveState.isLoading(level.levelCode);

                    return DigifyMultiSelectDialog<OrgUnit>(
                      title: 'Select ${level.levelName}',
                      subtitle: '${selectedUnitIds.length} selected',
                      items: liveOptions,
                      selectedIds: selectedUnitIds,
                      idBuilder: (item) => item.orgUnitId,
                      labelBuilder: (item) => item.orgUnitNameEn,
                      searchHint: 'Search ${level.levelName.toLowerCase()}...',
                      emptyMessage: 'No options available',
                      headerIcon: Icons.business_rounded,
                      isLoading: liveLoading,
                      errorMessage: liveError,
                      onRetry: () {
                        ref.read(selectionProvider.notifier).loadOptionsForLevel(level.levelCode);
                      },
                      showSelectAllAction: true,
                    );
                  },
                ),
              );

              if (selected != null) {
                onSelectionChanged(selected);
              }
            }
          : null,
    );
  }
}
