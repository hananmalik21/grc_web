import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/enterprise_structure/domain/models/structure_list_item.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/edit_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/save_enterprise_structure_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/providers/structure_list_provider.dart';
import 'package:grc/features/enterprise_structure/presentation/screens/manage_enterprise_structure/manage_enterprise_structure_permission_mixin.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/dialogs/enterprise_structure_dialog.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/helpers/structure_activate_handler.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/helpers/structure_delete_handler.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/helpers/structure_level_helper.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/structure_metrics_widget.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MobileStructureCardWidget extends StatelessWidget {
  const MobileStructureCardWidget({
    super.key,
    required this.context,
    required this.localizations,
    required this.isDark,
    required this.title,
    required this.description,
    required this.isActive,
    required this.levels,
    required this.levelCount,
    required this.components,
    required this.employees,
    required this.created,
    required this.modified,
    required this.showInfoMessage,
    required this.structureListProvider,
    required this.saveEnterpriseStructureProvider,
    this.structureLevels,
    this.enterpriseId,
    this.structureId,
  });

  final BuildContext context;
  final AppLocalizations localizations;
  final bool isDark;
  final String title;
  final String description;
  final bool isActive;
  final List<String> levels;
  final int levelCount;
  final int components;
  final int employees;
  final String created;
  final String modified;
  final bool showInfoMessage;
  final List<StructureLevelItem>? structureLevels;
  final int? enterpriseId;
  final String? structureId;
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> structureListProvider;
  final AutoDisposeStateNotifierProvider<SaveEnterpriseStructureNotifier, SaveEnterpriseStructureState>
  saveEnterpriseStructureProvider;

  @override
  Widget build(BuildContext context) {
    final accentColor = isActive ? AppColors.statIconGreen : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: AppShadows.cardShadow,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(18.w, 14.h, 14.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CardHeader(title: title, isActive: isActive, isDark: isDark),
                if (description.isNotEmpty) ...[Gap(6.h), _CardDescription(description: description, isDark: isDark)],
                Gap(10.h),
                _CardMetrics(
                  localizations: localizations,
                  isDark: isDark,
                  components: components,
                  employees: employees,
                  levelCount: levelCount,
                  created: created,
                ),
                Gap(12.h),
                DigifyDivider.horizontal(),
                Gap(8.h),
                _MobileActionButtons(
                  context: context,
                  localizations: localizations,
                  isDark: isDark,
                  isActive: isActive,
                  title: title,
                  description: description,
                  structureLevels: structureLevels,
                  enterpriseId: enterpriseId,
                  structureId: structureId,
                  structureListProvider: structureListProvider,
                  saveEnterpriseStructureProvider: saveEnterpriseStructureProvider,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: 4.w,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), bottomLeft: Radius.circular(10.r)),
            ),
          ),
        ),
      ],
    );
  }
}

class _CardHeader extends StatelessWidget {
  const _CardHeader({required this.title, required this.isActive, required this.isDark});

  final String title;
  final bool isActive;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Gap(8.w),
        DigifyStatusCapsule(status: isActive ? 'ACTIVE' : 'INACTIVE', showDotWhenActive: false),
      ],
    );
  }
}

class _CardDescription extends StatelessWidget {
  const _CardDescription({required this.description, required this.isDark});

  final String description;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: context.textTheme.bodyMedium?.copyWith(
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _CardMetrics extends StatelessWidget {
  const _CardMetrics({
    required this.localizations,
    required this.isDark,
    required this.components,
    required this.employees,
    required this.levelCount,
    required this.created,
  });

  final AppLocalizations localizations;
  final bool isDark;
  final int components;
  final int employees;
  final int levelCount;
  final String created;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: InfoRichText(label: localizations.components, value: components.toString(), isDark: isDark),
            ),
            Gap(8.w),
            Expanded(
              child: InfoRichText(label: localizations.employees, value: employees.toString(), isDark: isDark),
            ),
          ],
        ),
        Gap(4.h),
        Row(
          children: [
            Expanded(
              child: InfoRichText(label: localizations.levels, value: levelCount.toString(), isDark: isDark),
            ),
            Gap(8.w),
            Expanded(
              child: InfoRichText(label: localizations.created, value: created, isDark: isDark),
            ),
          ],
        ),
      ],
    );
  }
}

class _MobileActionButtons extends ConsumerWidget with ManageEnterpriseStructurePermissionMixin {
  const _MobileActionButtons({
    required this.context,
    required this.localizations,
    required this.isDark,
    required this.isActive,
    required this.title,
    required this.description,
    required this.structureListProvider,
    required this.saveEnterpriseStructureProvider,
    this.structureLevels,
    this.enterpriseId,
    this.structureId,
  });

  final BuildContext context;
  final AppLocalizations localizations;
  final bool isDark;
  final bool isActive;
  final String title;
  final String description;
  final List<StructureLevelItem>? structureLevels;
  final int? enterpriseId;
  final String? structureId;
  final AutoDisposeStateNotifierProvider<StructureListNotifier, StructureListState> structureListProvider;
  final AutoDisposeStateNotifierProvider<SaveEnterpriseStructureNotifier, SaveEnterpriseStructureState>
  saveEnterpriseStructureProvider;

  List<HierarchyLevel> get _viewLevels => (structureLevels?.isNotEmpty ?? false)
      ? structureLevels!.map(convertToHierarchyLevel).toList().cast<HierarchyLevel>()
      : <HierarchyLevel>[];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saveState = ref.watch(saveEnterpriseStructureProvider);
    final isActivating = saveState.isSaving && saveState.loadingStructureId == structureId;

    return Row(
      children: [
        if (!isActive && canActivateStructure) ...[
          AppMobileButton(
            svgPath: Assets.icons.checkIconGreen.path,
            backgroundColor: AppColors.editIconGreen,
            foregroundColor: AppColors.cardBackground,
            isLoading: isActivating,
            onPressed: isActivating
                ? null
                : () => handleStructureActivate(
                    context,
                    ref,
                    title: title,
                    description: description,
                    structureId: structureId,
                    enterpriseId: enterpriseId,
                    localizations: localizations,
                    saveEnterpriseStructureProvider: saveEnterpriseStructureProvider,
                    structureListProvider: structureListProvider,
                  ),
          ),
          Gap(8.w),
        ],
        if (canViewStructure)
          AppMobileButton(
            svgPath: Assets.icons.viewIconBlue.path,
            backgroundColor: AppColors.viewIconBlue,
            foregroundColor: AppColors.cardBackground,
            onPressed: () => EnterpriseStructureDialog.showViewMobile(
              context,
              structureName: title,
              description: description,
              enterpriseId: enterpriseId,
              initialLevels: _viewLevels,
              provider: structureListProvider,
            ),
          ),
        if (canUpdateStructure) ...[
          Gap(8.w),
          AppMobileButton(
            svgPath: Assets.icons.editIconGreen.path,
            backgroundColor: AppColors.editIconGreen,
            foregroundColor: AppColors.cardBackground,
            onPressed: () async {
              final updated = await EnterpriseStructureDialog.showEditMobile(
                context,
                structureName: title,
                description: description,
                initialLevels: _viewLevels,
                structureId: structureId,
                isActive: isActive,
                provider: structureListProvider,
              );
              if (updated) ref.read(structureListProvider.notifier).refresh();
            },
          ),
        ],
        if (!isActive && canDeleteStructure) ...[
          Gap(8.w),
          AppMobileButton(
            svgPath: Assets.icons.deleteIconRed.path,
            backgroundColor: AppColors.deleteIconRed,
            foregroundColor: AppColors.cardBackground,
            onPressed: () => handleStructureDelete(
              context,
              ref,
              title: title,
              structureId: structureId,
              localizations: localizations,
              structureListProvider: structureListProvider,
            ),
          ),
        ],
      ],
    );
  }
}
