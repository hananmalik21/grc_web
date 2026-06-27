import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/shared/configuration_summary_widget.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/shared/hierarchy_level_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'hierarchy_preview_section.dart';

class ViewModeContent extends StatelessWidget {
  final AppLocalizations localizations;
  final List<HierarchyLevel> levels;
  final String structureName;
  final String description;

  const ViewModeContent({
    super.key,
    required this.localizations,
    required this.levels,
    required this.structureName,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final hasActiveLevels = levels.any((l) => l.isActive);
    final status = hasActiveLevels ? PositionStatus.active : PositionStatus.inactive;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyTextField(
          labelText: localizations.structureName,
          isRequired: true,
          initialValue: structureName,
          readOnly: true,
          filled: true,
        ),
        Gap(16.h),
        DigifyTextField(
          labelText: localizations.description,
          isRequired: true,
          initialValue: description,
          readOnly: true,
          maxLines: 4,
          filled: true,
        ),
        Gap(16.h),
        DigifySelectFieldWithLabel<PositionStatus>(
          label: localizations.status,
          value: status,
          items: const [PositionStatus.active, PositionStatus.inactive],
          itemLabelBuilder: (s) => s == PositionStatus.active ? 'Active' : 'Inactive',
          onChanged: null,
          isRequired: true,
        ),
        Gap(24.h),
        if (levels.isEmpty)
          Padding(
            padding: EdgeInsetsDirectional.all(16.w),
            child: Center(
              child: Text(
                'No structure levels found',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? AppColors.textSecondaryDark : const Color(0xFF4A5565),
                ),
              ),
            ),
          )
        else
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.organizationalHierarchyLevels,
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 15.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Gap(16.h),
              ...levels.map(
                (level) => Padding(
                  padding: EdgeInsetsDirectional.only(bottom: 12.h),
                  child: HierarchyLevelCard(
                    name: level.name,
                    icon: level.icon,
                    levelNumber: level.level,
                    isMandatory: level.isMandatory,
                    isActive: level.isActive,
                    canMoveUp: false,
                    canMoveDown: false,
                    onMoveUp: null,
                    onMoveDown: null,
                    onToggleActive: null,
                    showArrows: false,
                  ),
                ),
              ),
            ],
          ),
        Gap(12.h),
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
