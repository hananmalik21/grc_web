import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/enterprise_structure/data/models/edit_dialog_params.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/shared/configuration_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'enterprise_structure_dialog_mode.dart';
import 'enterprise_structure_dialog_providers.dart';
import 'hierarchy_preview_section.dart';
import 'organizational_hierarchy_levels_section.dart';

class EditFormBody extends ConsumerWidget {
  final EditEnterpriseStructureState editState;
  final EditDialogParams params;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final AppLocalizations localizations;

  const EditFormBody({
    super.key,
    required this.editState,
    required this.params,
    required this.nameController,
    required this.descriptionController,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levels = editState.levels;
    final formNotifier = ref.read(editEnterpriseStructureDialogProvider(params).notifier);

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
          value: editState.isActive ? PositionStatus.active : PositionStatus.inactive,
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
        OrganizationalHierarchyLevelsSection(
          mode: EnterpriseStructureDialogMode.edit,
          levels: levels,
          formState: editState,
          formNotifier: formNotifier,
          dialogState: null,
        ),
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
    );
  }
}
