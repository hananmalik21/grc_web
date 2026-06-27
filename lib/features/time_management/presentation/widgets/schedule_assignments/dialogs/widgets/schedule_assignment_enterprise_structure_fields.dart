import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/features/workforce_structure/presentation/providers/enterprise_selection_provider.dart';
import 'package:grc/features/time_management/presentation/providers/active_org_structure_provider.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/org_unit_selection_field.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/form/specialized_org_unit_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleAssignmentEnterpriseStructureFields extends ConsumerStatefulWidget {
  final AppLocalizations localizations;
  final int enterpriseId;
  final Map<String, String?> selectedUnitIds;
  final Function(String levelCode, String? unitId) onSelectionChanged;

  const ScheduleAssignmentEnterpriseStructureFields({
    super.key,
    required this.localizations,
    required this.enterpriseId,
    required this.selectedUnitIds,
    required this.onSelectionChanged,
  });

  @override
  ConsumerState<ScheduleAssignmentEnterpriseStructureFields> createState() =>
      _ScheduleAssignmentEnterpriseStructureFieldsState();
}

class _ScheduleAssignmentEnterpriseStructureFieldsState
    extends ConsumerState<ScheduleAssignmentEnterpriseStructureFields> {
  StateNotifierProvider<EnterpriseSelectionNotifier, EnterpriseSelectionState>? _cachedSelectionProvider;
  String? _cachedStructureId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(scheduleAssignmentActiveOrgStructureProvider(widget.enterpriseId).notifier);
      final state = ref.read(scheduleAssignmentActiveOrgStructureProvider(widget.enterpriseId));
      if (state.orgStructure == null && !state.isLoading) {
        notifier.fetchActiveOrgStructure();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orgStructureState = ref.watch(scheduleAssignmentActiveOrgStructureProvider(widget.enterpriseId));
    final activeLevels = orgStructureState.orgStructure?.activeLevels ?? [];

    if (orgStructureState.isLoading) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            Gap(16.h),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: AppLoadingIndicator(type: LoadingType.fadingCircle, size: 24.r),
              ),
            ),
          ],
        ),
      );
    }

    if (orgStructureState.error != null) {
      return _buildErrorBox(orgStructureState.error!);
    }

    if (activeLevels.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            Gap(16.h),
            Text(
              'No organizational structure found for this enterprise',
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    final structureId = orgStructureState.orgStructure!.structureId;

    if (_cachedSelectionProvider == null || _cachedStructureId != structureId) {
      _cachedStructureId = structureId;
      _cachedSelectionProvider = scheduleAssignmentEnterpriseSelectionProvider((
        levels: activeLevels,
        structureId: structureId,
        enterpriseId: widget.enterpriseId,
      ));
    }

    final selectionProvider = _cachedSelectionProvider!;
    final selectionState = ref.watch(selectionProvider);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          Gap(16.h),
          if (activeLevels.isNotEmpty) ...[
            CompanySelectionField(
              level: activeLevels[0],
              selectionProvider: selectionProvider,
              onSelectionChanged: widget.onSelectionChanged,
            ),
            Gap(16.h),
          ],
          if (activeLevels.length > 1) ...[
            BusinessUnitSelectionField(
              level: activeLevels[1],
              selectionProvider: selectionProvider,
              isEnabled: selectionState.getSelection(activeLevels[0].levelCode) != null,
              onSelectionChanged: widget.onSelectionChanged,
            ),
            if (activeLevels.length > 2) Gap(16.h),
          ],
          if (activeLevels.length > 2)
            ...activeLevels.asMap().entries.skip(2).map((entry) {
              final index = entry.key;
              final level = entry.value;
              final parentLevel = activeLevels[index - 1];
              final isEnabled = selectionState.getSelection(parentLevel.levelCode) != null;

              return Column(
                children: [
                  OrgUnitSelectionField(
                    level: level,
                    selectionProvider: selectionProvider,
                    isEnabled: isEnabled,
                    onSelectionChanged: widget.onSelectionChanged,
                  ),
                  if (index < activeLevels.length - 1) Gap(16.h),
                ],
              );
            }),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Enterprise Structure',
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.primary),
    );
  }

  Widget _buildErrorBox(String error) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Enterprise Structure',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.error),
          ),
          Gap(8.h),
          Text(
            'Failed to load structure levels: $error',
            style: TextStyle(fontSize: 12.sp, color: AppColors.error),
          ),
        ],
      ),
    );
  }
}
