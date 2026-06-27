import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/utils/input_formatters.dart';
import 'package:flutter/services.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/forms/date_selection_field.dart';
import 'package:grc/core/widgets/forms/digify_select_field_with_label.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/leave_management/domain/models/abs_lookup_code.dart';
import 'package:grc/features/leave_management/domain/models/abs_lookup_value.dart';
import 'package:grc/features/leave_management/domain/models/policy_detail.dart';
import 'package:grc/features/leave_management/presentation/providers/tab_lookups_providers.dart';
import 'package:grc/features/leave_management/presentation/providers/policy_draft_provider.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/expandable_config_section.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/responsive_field_row.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:grc/features/leave_management/presentation/widgets/policy_configuration/skeletons/grade_based_entitlements_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GradeBasedEntitlementsSection extends ConsumerWidget {
  final bool isDark;
  final List<GradeEntitlement> gradeRows;
  final DateTime? effectiveStartDate;
  final DateTime? effectiveEndDate;
  final bool enableProRata;
  final String accrualMethodCode;
  final bool isEditing;

  const GradeBasedEntitlementsSection({
    super.key,
    required this.isDark,
    required this.gradeRows,
    required this.effectiveStartDate,
    required this.effectiveEndDate,
    required this.enableProRata,
    required this.accrualMethodCode,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lookupsAsync = ref.watch(policyConfigurationTabLookupsPreloadProvider);
    final accrualOptions = ref.watch(policyConfigurationTabLookupValuesForCodeProvider(AbsLookupCode.accrualMethod));
    final draftNotifier = ref.read(policyDraftProvider.notifier);

    return lookupsAsync.when(
      data: (_) => _buildContent(accrualOptions, draftNotifier),
      loading: () => GradeBasedEntitlementsSkeleton(isDark: isDark),
      error: (_, _) => _buildContent(accrualOptions, draftNotifier),
    );
  }

  Widget _buildContent(List<AbsLookupValue> accrualOptions, PolicyDraftNotifier draftNotifier) {
    return ExpandableConfigSection(
      title: 'Grade-Based Entitlements & Accrual',
      iconPath: Assets.icons.leaveManagementIcon.path,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16.h,
        children: [
          ...List.generate(gradeRows.length, (index) {
            return _GradeRowCard(
              key: ValueKey('grade-$index-${gradeRows[index].entitlementId}'),
              index: index,
              grade: gradeRows[index],
              policyAccrualCode: accrualMethodCode,
              accrualOptions: accrualOptions,
              isDark: isDark,
              isEditing: isEditing,
              onUpdate: (updated) => draftNotifier.updateGradeRowAt(index, updated),
              onRemove: gradeRows.length > 1 ? () => draftNotifier.removeGradeRowAt(index) : null,
            );
          }),
          if (isEditing)
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: AppButton.primary(
                label: 'Add Grade',
                svgPath: Assets.icons.addDivisionIcon.path,
                onPressed: () => draftNotifier.addGradeRow(),
              ),
            ),
          _EffectiveDateCard(
            effectiveStartDate: effectiveStartDate,
            effectiveEndDate: effectiveEndDate,
            isDark: isDark,
            isEditing: isEditing,
          ),
          _ProRataCard(
            enableProRata: enableProRata,
            isDark: isDark,
            isEditing: isEditing,
            onChanged: isEditing ? (v) => draftNotifier.updateEnableProRata(v) : null,
          ),
        ],
      ),
    );
  }
}

class _GradeRowCard extends StatefulWidget {
  final int index;
  final GradeEntitlement grade;
  final String policyAccrualCode;
  final List<AbsLookupValue> accrualOptions;
  final bool isDark;
  final bool isEditing;
  final ValueChanged<GradeEntitlement> onUpdate;
  final VoidCallback? onRemove;

  const _GradeRowCard({
    super.key,
    required this.index,
    required this.grade,
    required this.policyAccrualCode,
    required this.accrualOptions,
    required this.isDark,
    required this.isEditing,
    required this.onUpdate,
    this.onRemove,
  });

  @override
  State<_GradeRowCard> createState() => _GradeRowCardState();
}

class _GradeRowCardState extends State<_GradeRowCard> {
  late TextEditingController _gradeFromController;
  late TextEditingController _gradeToController;
  late TextEditingController _daysController;
  late TextEditingController _accrualRateController;

  static String _gradeToDisplay(int? v) => v == null ? '' : v.toString();

  @override
  void initState() {
    super.initState();
    _gradeFromController = TextEditingController(text: widget.grade.gradeFrom?.toString() ?? '');
    _gradeToController = TextEditingController(text: _gradeToDisplay(widget.grade.gradeTo));
    _daysController = TextEditingController(text: widget.grade.entitlementDays.toString());
    _accrualRateController = TextEditingController(
      text: widget.grade.accrualRate != null ? widget.grade.accrualRate!.toStringAsFixed(2) : '',
    );
  }

  @override
  void didUpdateWidget(_GradeRowCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.grade == widget.grade) return;
    final fromStr = widget.grade.gradeFrom?.toString() ?? '';
    if (int.tryParse(_gradeFromController.text) != widget.grade.gradeFrom) {
      _gradeFromController.text = fromStr;
    }
    final toStr = _gradeToDisplay(widget.grade.gradeTo);
    if ((_gradeToController.text.isEmpty ? null : int.tryParse(_gradeToController.text)) != widget.grade.gradeTo) {
      _gradeToController.text = toStr;
    }
    if (int.tryParse(_daysController.text) != widget.grade.entitlementDays) {
      _daysController.text = widget.grade.entitlementDays.toString();
    }
    final rateParsed = double.tryParse(_accrualRateController.text);
    final rateFromGrade = widget.grade.accrualRate;
    final rateMatch =
        (rateFromGrade == null && (rateParsed == null || _accrualRateController.text.isEmpty)) ||
        (rateFromGrade != null && rateParsed != null && (rateFromGrade - rateParsed).abs() < 0.005);
    if (!rateMatch) {
      _accrualRateController.text = rateFromGrade != null ? rateFromGrade.toStringAsFixed(2) : '';
    }
  }

  @override
  void dispose() {
    _gradeFromController.dispose();
    _gradeToController.dispose();
    _daysController.dispose();
    _accrualRateController.dispose();
    super.dispose();
  }

  void _emitUpdate({
    int? gradeFrom,
    int? gradeTo,
    int? entitlementDays,
    double? accrualRate,
    bool? isActive,
    String? accrualMethodCode,
  }) {
    final g = widget.grade.copyWith(
      gradeFrom: gradeFrom,
      gradeTo: gradeTo,
      entitlementDays: entitlementDays ?? widget.grade.entitlementDays,
      accrualRate: accrualRate,
      isActive: isActive,
      accrualMethodCode: accrualMethodCode,
    );
    widget.onUpdate(g);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final isEditing = widget.isEditing;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.workforce.fillRate.path,
                width: 20.w,
                height: 20.h,
                color: AppColors.primary,
              ),
              if (widget.onRemove != null && isEditing) ...[
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 22.r, color: AppColors.error),
                  onPressed: widget.onRemove,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12.h,
            children: [
              ResponsiveFieldRow(
                children: [
                  DigifyTextField.number(
                    controller: _gradeFromController,
                    labelText: 'Grade From',
                    hintText: '1',
                    filled: true,
                    fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                    readOnly: !isEditing,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: isEditing ? (v) => _emitUpdate(gradeFrom: int.tryParse(v)) : null,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DigifyTextField.number(
                        controller: _gradeToController,
                        labelText: 'Grade To',
                        hintText: '0',
                        filled: true,
                        fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                        readOnly: !isEditing,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: isEditing ? (v) => _emitUpdate(gradeTo: v.isEmpty ? null : int.tryParse(v)) : null,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Leave empty for "and above"',
                        style: context.textTheme.labelSmall?.copyWith(
                          fontSize: 11.sp,
                          color: isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder,
                        ),
                      ),
                    ],
                  ),
                  DigifyTextField.number(
                    controller: _daysController,
                    labelText: 'Days',
                    hintText: '0',
                    filled: true,
                    fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                    readOnly: !isEditing,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: isEditing ? (v) => _emitUpdate(entitlementDays: int.tryParse(v) ?? 0) : null,
                  ),
                  DigifyTextField(
                    controller: _accrualRateController,
                    labelText: 'Accrual Rate',
                    hintText: '0.00',
                    filled: true,
                    fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                    readOnly: !isEditing,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [AppInputFormatters.decimalWithTwoPlaces()],
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 15.h),
                    onChanged: isEditing ? (v) => _emitUpdate(accrualRate: double.tryParse(v)) : null,
                  ),
                ],
              ),
              ResponsiveFieldRow(
                children: [
                  _buildAccrualMethodDropdown(context),
                  _buildStatusDropdown(context),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccrualMethodDropdown(BuildContext context) {
    final code = (widget.grade.accrualMethodCode ?? widget.policyAccrualCode).trim().toUpperCase();
    AbsLookupValue? selected;
    if (code.isNotEmpty) {
      for (final v in widget.accrualOptions) {
        if (v.lookupValueCode.trim().toUpperCase() == code) {
          selected = v;
          break;
        }
      }
    }
    return DigifySelectFieldWithLabel<AbsLookupValue>(
      label: 'Accrual Method',
      items: widget.accrualOptions,
      itemLabelBuilder: (v) => v.lookupValueName,
      value: selected,
      onChanged: widget.isEditing ? (v) => _emitUpdate(accrualMethodCode: v?.lookupValueCode) : null,
    );
  }

  Widget _buildStatusDropdown(BuildContext context) {
    final statusOptions = ['Active', 'Inactive'];
    final currentStatus = widget.grade.isActive ? 'Active' : 'Inactive';

    return DigifySelectFieldWithLabel<String>(
      label: 'Status',
      items: statusOptions,
      itemLabelBuilder: (item) => item,
      value: currentStatus,
      onChanged: widget.isEditing ? (v) => _emitUpdate(isActive: v == 'Active') : null,
    );
  }
}

class _EffectiveDateCard extends ConsumerWidget {
  final DateTime? effectiveStartDate;
  final DateTime? effectiveEndDate;
  final bool isDark;
  final bool isEditing;

  const _EffectiveDateCard({
    required this.effectiveStartDate,
    required this.effectiveEndDate,
    required this.isDark,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftNotifier = ref.read(policyDraftProvider.notifier);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.lightWhiteBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: ResponsiveFieldRow(
        children: [
          DateSelectionField(
            label: 'Effective Start Date',
            labelIconPath: Assets.icons.clockIcon.path,
            date: effectiveStartDate,
            hintText: 'Select start date',
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            onDateSelected: isEditing ? (d) => draftNotifier.updateEffectiveStartDate(d) : (_) {},
            enabled: isEditing,
          ),
          DateSelectionField(
            label: 'Effective End Date',
            labelIconPath: Assets.icons.clockIcon.path,
            date: effectiveEndDate,
            hintText: 'Select end date',
            firstDate: effectiveStartDate ?? DateTime(2000),
            lastDate: DateTime(2100),
            onDateSelected: isEditing ? (d) => draftNotifier.updateEffectiveEndDate(d) : (_) {},
            enabled: isEditing,
          ),
        ],
      ),
    );
  }
}

class _ProRataCard extends StatelessWidget {
  final bool enableProRata;
  final bool isDark;
  final bool isEditing;
  final ValueChanged<bool>? onChanged;

  const _ProRataCard({required this.enableProRata, required this.isDark, this.isEditing = false, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.2) : AppColors.roleBadgeBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.permissionBadgeBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyCheckbox(value: enableProRata, onChanged: isEditing ? (v) => onChanged?.call(v ?? false) : null),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                Text(
                  'Enable Pro-Rata Calculation',
                  style: context.textTheme.titleSmall?.copyWith(
                    color: isDark ? AppColors.infoTextDark : AppColors.statIconBlue,
                  ),
                ),
                Text(
                  'Calculate leave entitlement proportionally for partial years (new joiners, resignations)',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontSize: 12.sp,
                    color: isDark ? AppColors.infoTextDark.withValues(alpha: 0.8) : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
