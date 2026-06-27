import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
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
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/hierarchy_levels_widget.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/structure_metrics_widget.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class StructureCardWidget extends StatelessWidget {
  const StructureCardWidget({
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < AppBreakpoints.tabletSmall;
        final borderColor = isActive
            ? AppColors.statIconGreen
            : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder);
        final cardPadding = EdgeInsetsDirectional.all(
          (isCompact ? (isActive ? 16.w : 18.w) : (isActive ? 20.w : 22.w)).toDouble(),
        );

        return Container(
          padding: cardPadding,
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
            border: Border.all(color: borderColor, width: 2),
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: AppShadows.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isCompact ? _buildMobileContent(context) : _buildDesktopContent(context),
              if (showInfoMessage) _buildInfoBanner(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8.h,
      children: [
        _buildTitleAndBadge(context),
        _buildDescription(context),
        HierarchyLevelsWidget(localizations: localizations, isDark: isDark, levels: levels, levelCount: levelCount),
        StructureMetricsWidget(
          localizations: localizations,
          isDark: isDark,
          components: components,
          employees: employees,
          created: created,
          modified: modified,
        ),
        _CardActionButtons(
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
    );
  }

  Widget _buildDesktopContent(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.h,
            children: [
              _buildTitleAndBadge(context),
              _buildDescription(context),
              HierarchyLevelsWidget(
                localizations: localizations,
                isDark: isDark,
                levels: levels,
                levelCount: levelCount,
              ),
              StructureMetricsWidget(
                localizations: localizations,
                isDark: isDark,
                components: components,
                employees: employees,
                created: created,
                modified: modified,
              ),
            ],
          ),
        ),
        Gap(16.w),
        SizedBox(
          width: 140.w,
          child: _CardActionButtons(
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
        ),
      ],
    );
  }

  Widget _buildTitleAndBadge(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: context.textTheme.headlineSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        Gap(12.w),
        DigifyStatusCapsule(status: isActive ? 'ACTIVE' : 'INACTIVE', showDotWhenActive: false),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      description,
      style: context.textTheme.bodyLarge?.copyWith(
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildInfoBanner(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyDivider.horizontal(
          color: isDark ? AppColors.successBorderDark : AppColors.activeStatusBorderLight,
          margin: EdgeInsets.symmetric(vertical: 17.h),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DigifyAsset(
              assetPath: Assets.icons.infoIconGreen.path,
              width: 16.w,
              height: 16.h,
              color: isDark ? AppColors.successTextDark : AppColors.activeStatusTextLight,
            ),
            Gap(8.w),
            Expanded(
              child: Text(
                localizations.currentlyActiveStructureMessage,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.successTextDark : AppColors.activeStatusTextLight,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CardActionButtons extends ConsumerWidget with ManageEnterpriseStructurePermissionMixin {
  const _CardActionButtons({
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8.h,
      children: [
        if (!isActive && canActivateStructure)
          AppButton(
            label: localizations.activate,
            backgroundColor: AppColors.editIconGreen,
            foregroundColor: AppColors.cardBackground,
            svgPath: Assets.icons.checkIconGreen.path,
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
        if (canViewStructure)
          AppButton(
            label: localizations.view,
            svgPath: Assets.icons.viewIconBlue.path,
            backgroundColor: AppColors.infoBg,
            foregroundColor: AppColors.primary,
            onPressed: () => EnterpriseStructureDialog.showView(
              context,
              structureName: title,
              description: description,
              enterpriseId: enterpriseId,
              initialLevels: _viewLevels,
              provider: structureListProvider,
            ),
          ),
        if (canUpdateStructure)
          AppButton(
            label: localizations.edit,
            svgPath: Assets.icons.editIconGreen.path,
            backgroundColor: AppColors.infoBg,
            foregroundColor: AppColors.primary,
            onPressed: () => EnterpriseStructureDialog.showEdit(
              context,
              structureName: title,
              description: description,
              initialLevels: _viewLevels,
              structureId: structureId,
              isActive: isActive,
              provider: structureListProvider,
            ),
          ),
        if (!isActive && canDeleteStructure)
          AppButton(
            label: localizations.delete,
            svgPath: Assets.icons.deleteIconRed.path,
            backgroundColor: AppColors.redBg,
            foregroundColor: AppColors.brandRed,
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
    );
  }
}
