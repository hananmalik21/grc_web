import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_document_card.dart';
import 'package:grc/features/hiring/presentation/providers/requisitions/create_requisition/create_requisition_provider.dart';
import 'package:grc/features/leave_management/presentation/providers/document_provider.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'create_requisition_section_card.dart';
import 'package:grc/core/localization/locale_provider.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value.dart';
import 'package:grc/features/hiring/domain/models/rec_lookups/rec_lookup_value_extensions.dart';

import 'create_requisition_rec_lookup_select_field.dart';
import 'dashed_border.dart';

class CreateRequisitionBudgetCompStep extends ConsumerStatefulWidget {
  const CreateRequisitionBudgetCompStep({super.key});

  @override
  ConsumerState<CreateRequisitionBudgetCompStep> createState() => _CreateRequisitionBudgetCompStepState();
}

class _CreateRequisitionBudgetCompStepState extends ConsumerState<CreateRequisitionBudgetCompStep> {
  late final TextEditingController _minSalaryController;
  late final TextEditingController _maxSalaryController;
  late final TextEditingController _additionalBenefitsController;
  late final TextEditingController _budgetCodeController;
  late final TextEditingController _approvedAmountController;

  @override
  void initState() {
    super.initState();
    final state = ref.read(createRequisitionProvider);
    _minSalaryController = TextEditingController(text: state.salaryRangeMin);
    _maxSalaryController = TextEditingController(text: state.salaryRangeMax);
    _additionalBenefitsController = TextEditingController(text: state.additionalBenefits);
    _budgetCodeController = TextEditingController(text: state.budgetCode);
    _approvedAmountController = TextEditingController(text: state.approvedBudgetAmount);
  }

  @override
  void dispose() {
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    _additionalBenefitsController.dispose();
    _budgetCodeController.dispose();
    _approvedAmountController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final documentRepository = ref.read(documentRepositoryProvider);
    final notifier = ref.read(createRequisitionProvider.notifier);
    try {
      final doc = await documentRepository.pickFile();
      if (!mounted) return;
      if (doc != null) {
        notifier.addAttachment(doc);
        ToastService.success(context, 'Document added');
      }
    } catch (e) {
      if (!mounted) return;
      ToastService.error(context, e.toString());
    }
  }

  Widget _buildResponsiveRow({required List<Widget> children, required BuildContext context}) {
    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children.asMap().entries.map((entry) {
          final index = entry.key;
          final widget = entry.value;
          final isLast = index == children.length - 1;

          Widget effectiveWidget = widget;
          if (widget is Expanded) {
            effectiveWidget = widget.child;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [effectiveWidget, if (!isLast) Gap(16.h)],
          );
        }).toList(),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final widget = entry.value;
        final isLast = index == children.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(child: widget is Expanded ? widget.child : widget),
              if (!isLast) Gap(16.w),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _currencyPlaceholder(String? currencyCode, List<RecLookupValue> currencyLookups, bool isRtl) {
    final trimmed = currencyCode?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return '—';
    }
    return currencyLookups.labelForCode(trimmed, isRtl: isRtl) ?? trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(createRequisitionProvider);
    final notifier = ref.read(createRequisitionProvider.notifier);
    final isDark = context.isDark;
    final isRtl = ref.watch(localeProvider).languageCode == 'ar';

    final currencyLookups = ref.watch(createRequisitionCurrencyLookupValuesProvider).valueOrNull ?? const [];
    final compTypeLookups = ref.watch(createRequisitionCompTypeLookupValuesProvider).valueOrNull ?? const [];

    final currencyPh = _currencyPlaceholder(state.currency, currencyLookups, isRtl);

    final compensationRangeCard = CreateRequisitionSectionCard(
      title: 'Compensation Range',
      subtitle: 'Define the salary range for this position',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResponsiveRow(
            context: context,
            children: [
              CreateRequisitionRecLookupSelectField(
                label: l10n.hiringCreateRequisitionCurrency,
                isRequired: true,
                selectedKey: state.currency,
                hint: l10n.hiringCreateRequisitionCurrencyHint,
                lookups: currencyLookups,
                onChanged: (value) => notifier.updateBudgetAndComp(currency: value),
              ),
              CreateRequisitionRecLookupSelectField(
                label: l10n.hiringCreateRequisitionCompensationType,
                isRequired: true,
                selectedKey: state.compensationType,
                hint: l10n.hiringCreateRequisitionCompensationTypeHint,
                lookups: compTypeLookups,
                onChanged: (value) => notifier.updateBudgetAndComp(compensationType: value),
              ),
            ],
          ),
          Gap(16.h),
          _buildResponsiveRow(
            context: context,
            children: [
              DigifyTextField(
                controller: _minSalaryController,
                labelText: l10n.hiringCreateRequisitionMinimumSalaryWithCurrency(currencyPh),
                hintText: l10n.hiringCreateRequisitionBudgetAmountHint,
                isRequired: true,
                keyboardType: TextInputType.number,
                onChanged: (value) => notifier.updateBudgetAndComp(salaryRangeMin: value),
              ),
              DigifyTextField(
                controller: _maxSalaryController,
                labelText: l10n.hiringCreateRequisitionMaximumSalaryWithCurrency(currencyPh),
                hintText: l10n.hiringCreateRequisitionBudgetAmountHint,
                isRequired: true,
                keyboardType: TextInputType.number,
                onChanged: (value) => notifier.updateBudgetAndComp(salaryRangeMax: value),
              ),
            ],
          ),
        ],
      ),
    );

    final additionalCompCard = CreateRequisitionSectionCard(
      title: 'Additional Compensation',
      subtitle: 'Bonuses, equity, and other benefits',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResponsiveRow(
            context: context,
            children: [
              _CheckboxTile(
                label: 'Bonus Eligible',
                value: state.bonusEligible,
                onChanged: (value) => notifier.updateBudgetAndComp(bonusEligible: value),
              ),
              _CheckboxTile(
                label: 'Equity/Stock Options Eligible',
                value: state.equityEligible,
                onChanged: (value) => notifier.updateBudgetAndComp(equityEligible: value),
              ),
            ],
          ),
          Gap(16.h),
          DigifyTextArea(
            controller: _additionalBenefitsController,
            labelText: 'Additional Benefits',
            hintText: 'List any additional benefits (e.g., signing bonus, relocation assistance)...',
            maxLines: 4,
            minLines: 4,
            onChanged: (value) => notifier.updateBudgetAndComp(additionalBenefits: value),
          ),
        ],
      ),
    );

    final budgetInfoCard = CreateRequisitionSectionCard(
      title: 'Budget Information',
      subtitle: 'Internal budget tracking details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildResponsiveRow(
            context: context,
            children: [
              DigifyTextField(
                controller: _budgetCodeController,
                labelText: 'Budget Code',
                isRequired: true,
                hintText: 'e.g., BUD-2026-ENG-001',
                onChanged: (value) => notifier.updateBudgetAndComp(budgetCode: value),
              ),
              DigifyTextField(
                controller: _approvedAmountController,
                labelText: 'Approved Budget Amount',
                hintText: l10n.hiringCreateRequisitionBudgetAmountHint,
                keyboardType: TextInputType.number,
                onChanged: (value) => notifier.updateBudgetAndComp(approvedBudgetAmount: value),
              ),
            ],
          ),
        ],
      ),
    );

    final attachmentsCard = CreateRequisitionSectionCard(
      title: 'Attachments',
      subtitle: 'Upload any relevant documents',
      child: Column(
        children: [
          InkWell(
            onTap: _pickFile,
            borderRadius: BorderRadius.circular(14.r),
            child: SizedBox(
              width: double.infinity,
              child: DashedBorder(
                color: isDark ? AppColors.cardBorderDark : AppColors.borderGrey,
                strokeWidth: 2,
                dashLength: 4,
                gapLength: 4,
                borderRadius: BorderRadius.circular(14.r),
                child: Container(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      Container(
                        width: 52.w,
                        height: 52.h,
                        decoration: const BoxDecoration(color: AppColors.infoBg, shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: DigifyAsset(
                          assetPath: Assets.icons.bulkUploadIconFigma.path,
                          color: AppColors.primary,
                          width: 32,
                          height: 32,
                        ),
                      ),
                      Gap(8.h),
                      Text(
                        'Click to upload or drag and drop',
                        style: context.textTheme.titleSmall?.copyWith(
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                        ),
                      ),
                      Gap(4.h),
                      Text(
                        'PDF, DOC, XLS (max. 10MB)',
                        style: context.textTheme.labelSmall?.copyWith(
                          color: isDark ? AppColors.textTertiaryDark : AppColors.tableHeaderText,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (state.attachments.isNotEmpty) ...[
            Gap(16.h),
            ...state.attachments.map(
              (doc) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: EmployeeDocumentCard(
                  title: doc.name,
                  subtitle: doc.formattedSize,
                  icon: Icons.close,
                  iconBackgroundColor: AppColors.errorBg,
                  iconColor: AppColors.error,
                  onTap: () => notifier.removeAttachment(doc),
                ),
              ),
            ),
          ],
        ],
      ),
    );

    if (context.isMobile) {
      return Column(
        children: [
          compensationRangeCard,
          Gap(20.h),
          additionalCompCard,
          Gap(20.h),
          budgetInfoCard,
          Gap(20.h),
          attachmentsCard,
        ],
      );
    }

    return Column(
      children: [
        compensationRangeCard,
        Gap(24.h),
        additionalCompCard,
        Gap(24.h),
        budgetInfoCard,
        Gap(24.h),
        attachmentsCard,
      ],
    );
  }
}

class _CheckboxTile extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _CheckboxTile({required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: context.isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          DigifyCheckbox(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
