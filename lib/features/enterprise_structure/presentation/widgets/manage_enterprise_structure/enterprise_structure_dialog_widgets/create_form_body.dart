import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/shared/configuration_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'enterprise_structure_dialog_mode.dart';
import 'enterprise_structure_dialog_providers.dart';
import 'hierarchy_loading_placeholder.dart';
import 'hierarchy_preview_section.dart';
import 'organizational_hierarchy_levels_section.dart';

class CreateFormBody extends ConsumerWidget {
  final EditEnterpriseStructureState formState;
  final EditEnterpriseStructureNotifier formNotifier;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final AppLocalizations localizations;

  const CreateFormBody({
    super.key,
    required this.formState,
    required this.formNotifier,
    required this.nameController,
    required this.descriptionController,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final levels = formState.levels;
    final hierarchyLevelsAsync = ref.watch(structureLevelsForCreateProvider);
    final isHierarchyLoading = hierarchyLevelsAsync.isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyTextField(
          labelText: localizations.structureName,
          isRequired: true,
          controller: nameController,
          hintText: localizations.structureNamePlaceholder,
          onChanged: formNotifier.updateStructureName,
        ),
        Gap(16.h),
        DigifyTextArea(
          labelText: localizations.description,
          isRequired: true,
          controller: descriptionController,
          hintText: localizations.descriptionPlaceholder,
          onChanged: formNotifier.updateDescription,
          maxLines: 4,
        ),
        Gap(16.h),
        DigifySelectFieldWithLabel<PositionStatus>(
          label: localizations.status,
          value: formState.isActive ? PositionStatus.active : PositionStatus.inactive,
          items: const [PositionStatus.active, PositionStatus.inactive],
          itemLabelBuilder: (s) => s == PositionStatus.active ? 'Active' : 'Inactive',
          onChanged: (value) {
            if (value != null) {
              formNotifier.updateIsActive(value == PositionStatus.active);
            }
          },
          isRequired: true,
        ),
        Gap(16.h),
        if (isHierarchyLoading)
          HierarchyLoadingPlaceholder(isDark: isDark)
        else ...[
          _buildLevelsSection(context, isDark, levels),
          Gap(24.h),
          HierarchyPreviewSection(levels: levels),
          Gap(24.h),
          ConfigurationSummaryWidget(
            totalLevels: levels.length,
            activeLevels: levels.where((l) => l.isActive).length,
            hierarchyDepth: levels.where((l) => l.isActive).length,
            topLevel: levels.isNotEmpty ? levels.first.name : '',
          ),
        ],
      ],
    );
  }

  Widget _buildLevelsSection(BuildContext context, bool isDark, List<HierarchyLevel> levels) {
    if (levels.isEmpty) {
      return Padding(
        padding: EdgeInsetsDirectional.all(16.w),
        child: Center(
          child: Text(
            'No structure levels found',
            style: TextStyle(fontSize: 14.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
          ),
        ),
      );
    }
    return OrganizationalHierarchyLevelsSection(
      mode: EnterpriseStructureDialogMode.create,
      levels: levels,
      formState: formState,
      formNotifier: formNotifier,
      dialogState: null,
    );
  }
}
