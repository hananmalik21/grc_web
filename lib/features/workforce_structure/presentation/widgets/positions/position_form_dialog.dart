import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/presentation/providers/grade_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_form_state.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/position_form_sections.dart';
import 'package:grc/features/workforce_structure/presentation/providers/org_structure_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/position_providers.dart';
import 'package:grc/features/workforce_structure/presentation/providers/positions_enterprise_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PositionFormDialog extends ConsumerStatefulWidget {
  final Position initialPosition;
  final bool isEdit;
  final bool isSheet;

  const PositionFormDialog({super.key, required this.initialPosition, required this.isEdit, this.isSheet = false});

  static Future<void> show(BuildContext context, {required Position position, required bool isEdit}) {
    final title = isEdit ? AppLocalizations.of(context)!.editPosition : 'Add New Position';

    if (context.isMobileLayout) {
      return DigifyBottomSheet.show<void>(
        context,
        type: DigifyBottomSheetType.form,
        title: title,
        barrierDismissible: false,
        child: PositionFormDialog(initialPosition: position, isEdit: isEdit, isSheet: true),
      );
    }

    return showDialog(
      context: context,
      builder: (context) => PositionFormDialog(initialPosition: position, isEdit: isEdit),
    );
  }

  @override
  ConsumerState<PositionFormDialog> createState() => _PositionFormDialogState();
}

class _PositionFormDialogState extends ConsumerState<PositionFormDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(positionFormNotifierProvider.notifier)
          .initialize(position: widget.initialPosition, isEdit: widget.isEdit);
    });
  }

  bool _hasOrgUnitSelected() {
    final orgStructureState = ref.read(orgStructureNotifierProvider);
    final formState = ref.read(positionFormNotifierProvider);
    final levels = orgStructureState.orgStructure?.activeLevels ?? [];
    for (final level in levels) {
      if (formState.selectedUnitIds[level.levelCode] != null) return true;
    }
    return false;
  }

  Future<void> _handleSave() async {
    final localizations = AppLocalizations.of(context)!;
    final notifier = ref.read(positionFormNotifierProvider.notifier);
    final isValid = notifier.validateForm(context, hasOrgUnitSelected: _hasOrgUnitSelected(), l: localizations);
    if (!isValid) return;

    final formState = ref.read(positionFormNotifierProvider);
    final effectiveBudget = ref.read(effectiveBudgetForPositionFormProvider);
    final orgStructureState = ref.read(orgStructureNotifierProvider);

    String? lastUnitId;
    final levels = orgStructureState.orgStructure?.activeLevels ?? [];
    for (final level in levels) {
      final id = formState.selectedUnitIds[level.levelCode];
      if (id != null) {
        lastUnitId = id;
      }
    }

    final payload = {
      if (!widget.isEdit) "position_code": formState.code,
      "position_title_en": formState.titleEnglish,
      "position_title_ar": formState.titleArabic,
      "status": formState.isActive ? "ACTIVE" : "INACTIVE",
      "org_structure_id": orgStructureState.orgStructure?.structureId,
      "org_unit_id": lastUnitId,
      "cost_center": formState.costCenter,
      "location": formState.location,
      "job_family_id": formState.jobFamily!.id,
      "job_level_id": formState.jobLevel!.id,
      "grade_id": formState.grade!.id,
      "step_no": formState.stepNoListForPayload,
      "number_of_positions": int.tryParse(formState.positions) ?? 0,
      "filled_positions": int.tryParse(formState.filled) ?? 0,
      "employment_type": formState.employmentType,
      "budgeted_min_kd": double.tryParse(effectiveBudget.budgetedMin) ?? 0.0,
      "budgeted_max_kd": double.tryParse(effectiveBudget.budgetedMax) ?? 0.0,
      "actual_avg_kd": double.tryParse(effectiveBudget.actualAverage) ?? 0.0,
      "last_update_login": "HR_ADMIN",
      "reports_to_position_id": formState.selectedReportsToPosition?.id,
    };

    notifier.setIsSaving(true);

    try {
      if (widget.isEdit) {
        await ref.read(positionNotifierProvider.notifier).updatePosition(widget.initialPosition.id, payload);
      } else {
        await ref.read(positionNotifierProvider.notifier).createPosition(payload);
      }

      if (mounted) {
        context.pop();
        ToastService.success(
          context,
          widget.isEdit ? 'Position updated successfully' : 'Position created successfully',
          title: 'Success',
        );
      }
    } catch (e) {
      if (mounted) {
        ToastService.error(
          context,
          'Failed to ${widget.isEdit ? 'update' : 'create'} position: ${e.toString()}',
          title: 'Error',
        );
      }
    } finally {
      if (mounted) {
        ref.read(positionFormNotifierProvider.notifier).setIsSaving(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final formState = ref.watch(positionFormNotifierProvider);
    final notifier = ref.read(positionFormNotifierProvider.notifier);
    final formContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BasicInfoSection(
          localizations: localizations,
          code: formState.code,
          titleEnglish: formState.titleEnglish,
          titleArabic: formState.titleArabic,
          isEdit: formState.isEdit,
          isActive: formState.isActive,
          onCodeChanged: notifier.setCode,
          onTitleEnglishChanged: notifier.setTitleEnglish,
          onTitleArabicChanged: notifier.setTitleArabic,
          onStatusChanged: (val) => notifier.setIsActive(val ?? true),
        ),
        Gap(24.h),
        OrganizationalSection(
          localizations: localizations,
          selectedUnitIds: formState.selectedUnitIds,
          onEnterpriseSelectionChanged: (levelCode, unitId) => notifier.setSelectedUnitId(levelCode, unitId),
          costCenter: formState.costCenter,
          location: formState.location,
          onCostCenterChanged: notifier.setCostCenter,
          onLocationChanged: notifier.setLocation,
          initialSelections: widget.initialPosition.orgPathRefs,
        ),
        Gap(24.h),
        JobClassificationSection(localizations: localizations),
        Gap(24.h),
        HeadcountSection(
          localizations: localizations,
          positions: formState.positions,
          filled: formState.filled,
          selectedEmploymentType: formState.employmentType,
          onPositionsChanged: notifier.setPositions,
          onFilledChanged: notifier.setFilled,
          onEmploymentTypeChanged: notifier.setEmploymentType,
        ),
        Gap(24.h),
        SalarySection(localizations: localizations),
        Gap(24.h),
        ReportingSection(
          localizations: localizations,
          tenantId: ref.watch(positionsEnterpriseIdProvider),
          selectedReportsToPosition: formState.selectedReportsToPosition,
          onReportsToPositionSelected: notifier.setSelectedReportsToPosition,
        ),
      ],
    );

    if (widget.isSheet) {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 16.h),
              child: formContent,
            ),
          ),
          const DigifyDivider.horizontal(),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
            child: Row(
              children: [
                Expanded(
                  child: AppButton.outline(
                    label: localizations.cancel,
                    onPressed: formState.isSaving ? null : () => context.pop(),
                  ),
                ),
                Gap(12.w),
                Expanded(
                  child: AppButton.primary(
                    label: widget.isEdit ? localizations.saveUpdates : localizations.saveChanges,
                    isLoading: formState.isSaving,
                    onPressed: formState.isSaving ? null : _handleSave,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return AppDialog(
      title: widget.isEdit ? localizations.editPosition : 'Add New Position',
      width: 1050.w,
      onClose: () => context.pop(),
      content: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [formContent]),
      actions: [
        AppButton.outline(label: localizations.cancel, onPressed: formState.isSaving ? null : () => context.pop()),
        Gap(12.w),
        AppButton.primary(
          label: widget.isEdit ? localizations.saveUpdates : localizations.saveChanges,
          svgPath: formState.isSaving ? null : Assets.icons.saveIcon.path,
          isLoading: formState.isSaving,
          onPressed: formState.isSaving ? null : _handleSave,
        ),
      ],
    );
  }
}
