import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_select_field.dart';
import 'package:grc_web/core/widgets/app_text_field.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';

Future<void> showAddRiskDialog({required BuildContext context}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => const AddRiskDialog(),
  );
}

// ─── Colors not in AppColors ─────────────────────────────────────────────────
const _kResidualColor = Color(0xFFF54900);   // orange-red VAR in controls step
const _kInherentRedColor = Color(0xFFE7000B); // red VAR in mitigation summary

// ─── Dialog widget ────────────────────────────────────────────────────────────

class AddRiskDialog extends StatefulWidget {
  const AddRiskDialog({super.key});

  static const _dialogWidth = 984.0;

  @override
  State<AddRiskDialog> createState() => _AddRiskDialogState();
}

class _AddRiskDialogState extends State<AddRiskDialog> {
  // ── Navigation ─────────────────────────────────────────────
  int _currentStep = 0;
  static const _totalSteps = 5;

  // ── Step 0: Identification ──────────────────────────────────
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _category = 'cyberSecurity';
  final _subcategoryController = TextEditingController();
  final Set<String> _selectedAssets = {};
  final _tagController = TextEditingController();
  final List<String> _tags = [];
  final _rootCauseController = TextEditingController();
  final _consequenceController = TextEditingController();
  final List<String> _consequences = [];
  final _vulnerabilityController = TextEditingController();
  final List<String> _vulnerabilities = [];
  final _threatController = TextEditingController();
  final List<String> _threats = [];
  final _ownerController = TextEditingController();
  final _ownerRoleController = TextEditingController();
  final _departmentController = TextEditingController();

  // ── Step 1: Assessment ──────────────────────────────────────
  int _likelihood = 3;
  int _impact = 3;
  final _financialImpactController = TextEditingController(text: '1000000');

  // ── Step 2: Treatment ───────────────────────────────────────
  String _treatmentStrategy = 'mitigate';
  String _treatmentStatus = 'identified';
  String _riskAppetite = 'cautious';
  final _riskToleranceController = TextEditingController(text: '0');
  final _treatmentPlanController = TextEditingController();

  // ── Step 3: Controls ────────────────────────────────────────
  double _controlEffectiveness = 0;

  // ── Step 4: Mitigation ──────────────────────────────────────
  final _notesController = TextEditingController();

  // ── Computed values ─────────────────────────────────────────
  static const _mockAssets = [
    'Customer Database', 'Payment Gateway API', 'ERP System',
    'AWS Production VPC', 'Analytics Platform', 'Auth Service',
    'Vendor Portal', 'Log Aggregation',
  ];

  static const _categories = [
    'cyberSecurity', 'dataSecurity', 'operational', 'cloudSecurity',
    'accessControl', 'thirdPartyRisk', 'technology',
  ];

  static const _treatmentStrategies = ['mitigate', 'transfer', 'accept', 'avoid'];
  static const _statuses = ['identified', 'assessed', 'treated', 'monitored'];
  static const _appetites = ['cautious', 'moderate', 'aggressive'];

  int get _riskScore => _likelihood * _impact;

  double get _valueAtRisk {
    final f = double.tryParse(_financialImpactController.text) ?? 0;
    return f * _impact;
  }

  double get _residualVAR => _valueAtRisk * (1 - _controlEffectiveness / 100);

  int get _residualScore {
    final factor = 1 - _controlEffectiveness / 100;
    return (_riskScore * factor).round().clamp(0, 25);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _subcategoryController.dispose();
    _tagController.dispose();
    _rootCauseController.dispose();
    _consequenceController.dispose();
    _vulnerabilityController.dispose();
    _threatController.dispose();
    _ownerController.dispose();
    _ownerRoleController.dispose();
    _departmentController.dispose();
    _financialImpactController.dispose();
    _riskToleranceController.dispose();
    _treatmentPlanController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addItem(TextEditingController c, List<String> list) {
    final t = c.text.trim();
    if (t.isEmpty) return;
    setState(() { list.add(t); c.clear(); });
  }

  void _goNext() {
    if (_currentStep < _totalSteps - 1) setState(() => _currentStep++);
  }

  void _goPrevious() {
    if (_currentStep > 0) setState(() => _currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.sizeOf(context);
    final dialogWidth = math.min(AddRiskDialog._dialogWidth.w, screen.width - 48.w);
    final dialogHeight = screen.height * 0.92;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10.r),
          clipBehavior: Clip.antiAlias,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: const [
                BoxShadow(color: Color(0x1A000000), blurRadius: 25, offset: Offset(0, 20)),
                BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 8)),
              ],
            ),
            child: Column(
              children: [
                _AddRiskHeader(
                  riskId: 'R-1779130981039',
                  onClose: () => Navigator.of(context).pop(),
                ),
                _AddRiskStepper(currentStep: _currentStep),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
                    child: _buildStepContent(context),
                  ),
                ),
                _AddRiskFooter(
                  currentStep: _currentStep,
                  isLastStep: _currentStep == _totalSteps - 1,
                  onPrevious: _goPrevious,
                  onCancel: () => Navigator.of(context).pop(),
                  onNext: _goNext,
                  onSave: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent(BuildContext context) {
    return switch (_currentStep) {
      0 => _IdentificationStepContent(
          titleController: _titleController,
          descriptionController: _descriptionController,
          category: _category,
          onCategoryChanged: (v) { if (v != null) setState(() => _category = v); },
          categories: _categories,
          categoryLabel: _categoryLabel,
          subcategoryController: _subcategoryController,
          mockAssets: _mockAssets,
          selectedAssets: _selectedAssets,
          onToggleAsset: (a) => setState(() {
            _selectedAssets.contains(a) ? _selectedAssets.remove(a) : _selectedAssets.add(a);
          }),
          tagController: _tagController,
          tags: _tags,
          onAddTag: () => _addItem(_tagController, _tags),
          rootCauseController: _rootCauseController,
          consequenceController: _consequenceController,
          consequences: _consequences,
          onAddConsequence: () => _addItem(_consequenceController, _consequences),
          vulnerabilityController: _vulnerabilityController,
          vulnerabilities: _vulnerabilities,
          onAddVulnerability: () => _addItem(_vulnerabilityController, _vulnerabilities),
          threatController: _threatController,
          threats: _threats,
          onAddThreat: () => _addItem(_threatController, _threats),
          ownerController: _ownerController,
          ownerRoleController: _ownerRoleController,
          departmentController: _departmentController,
        ),
      1 => _AssessmentStepContent(
          likelihood: _likelihood,
          impact: _impact,
          onLikelihoodChanged: (v) => setState(() => _likelihood = v),
          onImpactChanged: (v) => setState(() => _impact = v),
          financialImpactController: _financialImpactController,
          riskScore: _riskScore,
          valueAtRisk: _valueAtRisk,
        ),
      2 => _TreatmentStepContent(
          treatmentStrategy: _treatmentStrategy,
          onStrategyChanged: (v) { if (v != null) setState(() => _treatmentStrategy = v); },
          treatmentStatus: _treatmentStatus,
          onStatusChanged: (v) { if (v != null) setState(() => _treatmentStatus = v); },
          riskAppetite: _riskAppetite,
          onAppetiteChanged: (v) { if (v != null) setState(() => _riskAppetite = v); },
          riskToleranceController: _riskToleranceController,
          treatmentPlanController: _treatmentPlanController,
          strategies: _treatmentStrategies,
          statuses: _statuses,
          appetites: _appetites,
        ),
      3 => _ControlsStepContent(
          controlEffectiveness: _controlEffectiveness,
          onEffectivenessChanged: (v) => setState(() => _controlEffectiveness = v),
          likelihood: _likelihood,
          impact: _impact,
          residualScore: _residualScore,
          residualVAR: _residualVAR,
          reductionPct: _controlEffectiveness,
        ),
      4 => _MitigationStepContent(
          notesController: _notesController,
          titleValue: _titleController.text.isEmpty
              ? null : _titleController.text,
          categoryValue: _categoryLabel(context, _category),
          inherentScore: _riskScore,
          inherentVAR: _valueAtRisk,
          residualScore: _residualScore,
          residualVAR: _residualVAR,
          treatmentValue: _treatmentStrategyLabel(context, _treatmentStrategy),
          ownerValue: _ownerController.text.isEmpty ? null : _ownerController.text,
        ),
      _ => const SizedBox.shrink(),
    };
  }

  String _categoryLabel(BuildContext context, String v) {
    final l10n = context.l10n;
    return switch (v) {
      'cyberSecurity' => l10n.categoryCyberSecurity,
      'dataSecurity' => l10n.categoryDataSecurity,
      'operational' => l10n.categoryOperational,
      'cloudSecurity' => l10n.categoryCloudSecurity,
      'accessControl' => l10n.categoryAccessControl,
      'thirdPartyRisk' => l10n.categoryThirdPartyRisk,
      _ => l10n.categoryTechnology,
    };
  }

  String _treatmentStrategyLabel(BuildContext context, String v) {
    final l10n = context.l10n;
    return switch (v) {
      'transfer' => l10n.treatmentTransfer,
      'accept' => l10n.treatmentAccept,
      'avoid' => l10n.treatmentAvoid,
      _ => l10n.treatmentMitigate,
    };
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

class _AddRiskHeader extends StatelessWidget {
  const _AddRiskHeader({required this.riskId, required this.onClose});
  final String riskId;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 17.h),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.addNewRisk,
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: -0.46),
                  strutStyle: AppTextMetrics.strut(fontSize: 20, lineHeight: 28),
                  textHeightBehavior: AppTextMetrics.textHeight,
                ),
                SizedBox(height: 4.h),
                Text(
                  riskId,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w400, letterSpacing: -0.154),
                  strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                  textHeightBehavior: AppTextMetrics.textHeight,
                ),
              ],
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(10.r),
              child: SizedBox(
                width: 32.r, height: 32.r,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/figma/library/svg/close_white.svg',
                    width: 20.r, height: 20.r,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stepper ─────────────────────────────────────────────────────────────────

class _AddRiskStepper extends StatelessWidget {
  const _AddRiskStepper({required this.currentStep});
  final int currentStep;

  static const _steps = [
    ('step_identification', 'Identification'),
    ('step_assessment', 'Assessment'),
    ('step_treatment', 'Treatment'),
    ('step_controls', 'Controls'),
    ('step_mitigation', 'Mitigation'),
  ];

  @override
  Widget build(BuildContext context) {
    final labels = [
      context.l10n.stepIdentification,
      context.l10n.stepAssessment,
      context.l10n.stepTreatment,
      context.l10n.stepControls,
      context.l10n.stepMitigation,
    ];
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 17.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          for (int i = 0; i < _steps.length; i++) ...[
            _StepButton(
              svgName: _steps[i].$1,
              label: labels[i],
              isDone: i <= currentStep,
            ),
            if (i < _steps.length - 1)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Container(
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: i < currentStep ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.svgName, required this.label, required this.isDone});
  final String svgName;
  final String label;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final bg = isDone ? AppColors.primaryTint : AppColors.rowDivider;
    final fg = isDone ? AppColors.primary : AppColors.textBody;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/figma/risks/svg/$svgName.svg',
            width: 16.r, height: 16.r,
            colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
          ),
          SizedBox(width: 8.w),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: fg, fontWeight: FontWeight.w500, letterSpacing: -0.154),
            strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
        ],
      ),
    );
  }
}

// ─── Footer ──────────────────────────────────────────────────────────────────

class _AddRiskFooter extends StatelessWidget {
  const _AddRiskFooter({
    required this.currentStep,
    required this.isLastStep,
    required this.onPrevious,
    required this.onCancel,
    required this.onNext,
    required this.onSave,
  });
  final int currentStep;
  final bool isLastStep;
  final VoidCallback onPrevious;
  final VoidCallback onCancel;
  final VoidCallback onNext;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24.w, 17.h, 24.w, 16.h),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (currentStep > 0)
            AppButton(
              label: l10n.previous,
              variant: AppButtonVariant.outlined,
              onPressed: onPrevious,
            )
          else
            const SizedBox.shrink(),
          Row(
            children: [
              AppButton(
                label: l10n.cancel,
                variant: AppButtonVariant.outlined,
                onPressed: onCancel,
              ),
              SizedBox(width: 8.w),
              if (isLastStep)
                AppButton(
                  label: l10n.saveRisk,
                  iconAsset: 'assets/figma/risks/svg/save_icon.svg',
                  variant: AppButtonVariant.primary,
                  iconSize: 16.r,
                  onPressed: onSave,
                )
              else
                AppButton(
                  label: l10n.next,
                  variant: AppButtonVariant.primary,
                  onPressed: onNext,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  STEP 0 — IDENTIFICATION
// ═══════════════════════════════════════════════════════════════════════

class _IdentificationStepContent extends StatelessWidget {
  const _IdentificationStepContent({
    required this.titleController,
    required this.descriptionController,
    required this.category,
    required this.onCategoryChanged,
    required this.categories,
    required this.categoryLabel,
    required this.subcategoryController,
    required this.mockAssets,
    required this.selectedAssets,
    required this.onToggleAsset,
    required this.tagController,
    required this.tags,
    required this.onAddTag,
    required this.rootCauseController,
    required this.consequenceController,
    required this.consequences,
    required this.onAddConsequence,
    required this.vulnerabilityController,
    required this.vulnerabilities,
    required this.onAddVulnerability,
    required this.threatController,
    required this.threats,
    required this.onAddThreat,
    required this.ownerController,
    required this.ownerRoleController,
    required this.departmentController,
  });

  final TextEditingController titleController;
  final TextEditingController descriptionController;
  final String category;
  final ValueChanged<String?> onCategoryChanged;
  final List<String> categories;
  final String Function(BuildContext, String) categoryLabel;
  final TextEditingController subcategoryController;
  final List<String> mockAssets;
  final Set<String> selectedAssets;
  final ValueChanged<String> onToggleAsset;
  final TextEditingController tagController;
  final List<String> tags;
  final VoidCallback onAddTag;
  final TextEditingController rootCauseController;
  final TextEditingController consequenceController;
  final List<String> consequences;
  final VoidCallback onAddConsequence;
  final TextEditingController vulnerabilityController;
  final List<String> vulnerabilities;
  final VoidCallback onAddVulnerability;
  final TextEditingController threatController;
  final List<String> threats;
  final VoidCallback onAddThreat;
  final TextEditingController ownerController;
  final TextEditingController ownerRoleController;
  final TextEditingController departmentController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(l10n.riskIdentificationTitle),
        SizedBox(height: 24.h),
        AppTextField(
          label: l10n.riskTitleLabel, isRequired: true, labelSpacing: 4,
          controller: titleController, hint: l10n.riskTitlePlaceholder,
        ),
        SizedBox(height: 16.h),
        AppTextField(
          label: l10n.assetDescription, isRequired: true, labelSpacing: 4,
          controller: descriptionController, hint: l10n.riskDescriptionPlaceholder,
          minLines: 3, maxLines: 6,
        ),
        SizedBox(height: 16.h),
        _TwoCol(gap: 16.w,
          left: AppSelectField<String>(
            label: l10n.category, isRequired: true, value: category,
            items: categories, itemLabel: (v) => categoryLabel(context, v),
            onChanged: onCategoryChanged,
          ),
          right: AppTextField(
            label: l10n.riskSubcategoryLabel, labelSpacing: 4,
            controller: subcategoryController, hint: l10n.riskSubcategoryPlaceholder,
          ),
        ),
        SizedBox(height: 16.h),
        _TwoCol(gap: 16.w,
          left: _AffectedAssetsField(
            label: l10n.affectedAssets, assets: mockAssets, selected: selectedAssets,
            hint: l10n.holdCtrlToSelectMultiple, onToggle: onToggleAsset,
          ),
          right: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _AddItemField(label: l10n.assetTags, controller: tagController,
              hint: l10n.addTagPlaceholder, onAdd: onAddTag),
            if (tags.isNotEmpty) ...[
              SizedBox(height: 6.h),
              _TagsRow(items: tags, color: AppColors.primaryTint),
            ],
          ]),
        ),
        SizedBox(height: 24.h),
        _TwoCol(gap: 24.w,
          left: AppTextField(
            label: l10n.rootCause, labelSpacing: 4,
            controller: rootCauseController, hint: l10n.rootCausePlaceholder,
            minLines: 3, maxLines: 5,
          ),
          right: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _AddItemField(label: l10n.consequences, controller: consequenceController,
              hint: l10n.addConsequencePlaceholder, onAdd: onAddConsequence),
            if (consequences.isNotEmpty) ...[
              SizedBox(height: 6.h),
              _TagsRow(items: consequences, color: AppColors.primaryTint),
            ],
          ]),
        ),
        SizedBox(height: 24.h),
        _TwoCol(gap: 24.w,
          left: _AddItemField(label: l10n.vulnerabilities, controller: vulnerabilityController,
            hint: l10n.addVulnerabilityPlaceholder, onAdd: onAddVulnerability),
          right: _AddItemField(label: l10n.threats, controller: threatController,
            hint: l10n.addThreatPlaceholder, onAdd: onAddThreat),
        ),
        if (vulnerabilities.isNotEmpty || threats.isNotEmpty) ...[
          SizedBox(height: 6.h),
          _TwoCol(gap: 24.w,
            left: vulnerabilities.isNotEmpty
                ? _TagsRow(items: vulnerabilities, color: AppColors.primaryTint)
                : const SizedBox.shrink(),
            right: threats.isNotEmpty
                ? _TagsRow(items: threats, color: AppColors.primaryTint)
                : const SizedBox.shrink(),
          ),
        ],
        SizedBox(height: 24.h),
        _ThreeCol(gap: 16.w, children: [
          AppTextField(label: l10n.riskOwner, isRequired: true, labelSpacing: 4,
            controller: ownerController, hint: l10n.riskOwnerPlaceholder),
          AppTextField(label: l10n.ownerRole, labelSpacing: 4,
            controller: ownerRoleController, hint: l10n.ownerRolePlaceholder),
          AppTextField(label: l10n.department, labelSpacing: 4,
            controller: departmentController, hint: l10n.departmentPlaceholder),
        ]),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  STEP 1 — ASSESSMENT
// ═══════════════════════════════════════════════════════════════════════

class _AssessmentStepContent extends StatelessWidget {
  const _AssessmentStepContent({
    required this.likelihood,
    required this.impact,
    required this.onLikelihoodChanged,
    required this.onImpactChanged,
    required this.financialImpactController,
    required this.riskScore,
    required this.valueAtRisk,
  });

  final int likelihood;
  final int impact;
  final ValueChanged<int> onLikelihoodChanged;
  final ValueChanged<int> onImpactChanged;
  final TextEditingController financialImpactController;
  final int riskScore;
  final double valueAtRisk;

  static const _likelihoodOpts = [
    (1, '1 - Very Low', '20% probability'),
    (2, '2 - Low', '40% probability'),
    (3, '3 - Medium', '60% probability'),
    (4, '4 - High', '80% probability'),
    (5, '5 - Very High', '100% probability'),
  ];

  static const _impactOpts = [
    (1, '1 - Very Low'),
    (2, '2 - Low'),
    (3, '3 - Medium'),
    (4, '4 - High'),
    (5, '5 - Very High'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SectionTitle(l10n.riskAssessmentTitle),
        SizedBox(height: 24.h),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _SelectionPanel(
            title: l10n.inherentLikelihood,
            children: _likelihoodOpts.map((o) => _LikelihoodCard(
              level: o.$1, label: o.$2, subtitle: o.$3,
              isSelected: likelihood == o.$1,
              onTap: () => onLikelihoodChanged(o.$1),
            )).toList(),
          )),
          SizedBox(width: 24.w),
          Expanded(child: _SelectionPanel(
            title: l10n.inherentImpact,
            children: _impactOpts.map((o) => _ImpactCard(
              level: o.$1, label: o.$2,
              isSelected: impact == o.$1,
              onTap: () => onImpactChanged(o.$1),
            )).toList(),
          )),
        ]),
        SizedBox(height: 24.h),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l10n.financialImpactUsd,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textLabel, fontWeight: FontWeight.w500, letterSpacing: -0.154),
            strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          SizedBox(height: 4.h),
          SizedBox(
            height: AppTextField.fieldHeight.h,
            child: TextField(
              controller: financialImpactController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: AppTextField.decoration(
                hint: '0',
                prefixIcon: Padding(
                  padding: EdgeInsetsDirectional.only(start: 12.w, end: 9.w),
                  child: SvgPicture.asset(
                    'assets/figma/risks/svg/dollar_icon.svg',
                    width: 20.r, height: 20.r,
                  ),
                ),
                contentPadding: EdgeInsets.fromLTRB(41.w, 9.h, 13.w, 9.h),
              ),
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.textDark, letterSpacing: -0.32),
            ),
          ),
          SizedBox(height: 4.h),
          Text(l10n.financialImpactHint,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary, fontWeight: FontWeight.w400, fontSize: 12.sp),
            strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
        ]),
        SizedBox(height: 24.h),
        _InherentRiskScoreCard(score: riskScore, valueAtRisk: valueAtRisk),
      ],
    );
  }
}

// ─── Selection panel wrapper ─────────────────────────────────────────────────

class _SelectionPanel extends StatelessWidget {
  const _SelectionPanel({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(color: AppColors.bg, borderRadius: BorderRadius.circular(10.r)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.textPrimary, fontWeight: FontWeight.w600,
            fontSize: 16.sp, letterSpacing: -0.32),
          strutStyle: AppTextMetrics.strut(fontSize: 16, lineHeight: 24),
          textHeightBehavior: AppTextMetrics.textHeight,
        ),
        SizedBox(height: 16.h),
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (int i = 0; i < children.length; i++) ...[
            children[i],
            if (i < children.length - 1) SizedBox(height: 12.h),
          ],
        ]),
      ]),
    );
  }
}

// ─── Likelihood option card ───────────────────────────────────────────────────

class _LikelihoodCard extends StatelessWidget {
  const _LikelihoodCard({
    required this.level, required this.label, required this.subtitle,
    required this.isSelected, required this.onTap,
  });
  final int level;
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLightBg : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.borderInput, width: 2),
        ),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600,
                fontSize: 16.sp, letterSpacing: -0.32),
              strutStyle: AppTextMetrics.strut(fontSize: 16, lineHeight: 24),
              textHeightBehavior: AppTextMetrics.textHeight,
            ),
            Text(subtitle,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textBody, fontWeight: FontWeight.w500, fontSize: 12.sp),
              strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
              textHeightBehavior: AppTextMetrics.textHeight,
            ),
          ])),
          if (isSelected)
            SvgPicture.asset('assets/figma/risks/svg/check_icon.svg',
              width: 20.r, height: 20.r,
              colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)),
        ]),
      ),
    );
  }
}

// ─── Impact option card ───────────────────────────────────────────────────────

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({
    required this.level, required this.label, required this.isSelected, required this.onTap,
  });
  final int level;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.deleteLightBg : Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: isSelected ? AppColors.deletePrimary : AppColors.borderInput, width: 2),
        ),
        child: Row(children: [
          Expanded(child: Text(label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary, fontWeight: FontWeight.w600,
              fontSize: 16.sp, letterSpacing: -0.32),
            strutStyle: AppTextMetrics.strut(fontSize: 16, lineHeight: 24),
            textHeightBehavior: AppTextMetrics.textHeight,
          )),
          if (isSelected)
            SvgPicture.asset('assets/figma/risks/svg/check_icon.svg',
              width: 20.r, height: 20.r,
              colorFilter: const ColorFilter.mode(AppColors.deletePrimary, BlendMode.srcIn)),
        ]),
      ),
    );
  }
}

// ─── Inherent Risk Score card ─────────────────────────────────────────────────

class _InherentRiskScoreCard extends StatelessWidget {
  const _InherentRiskScoreCard({required this.score, required this.valueAtRisk});
  final int score;
  final double valueAtRisk;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final rating = _ratingFor(score);
    final (ratingBg, ratingFg) = _ratingColors(rating);

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFEF2F2), Color(0xFFFFF7ED)]),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l10n.inherentRiskScore,
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.textPrimary, fontWeight: FontWeight.w600,
            fontSize: 16.sp, letterSpacing: -0.32),
          strutStyle: AppTextMetrics.strut(fontSize: 16, lineHeight: 24),
          textHeightBehavior: AppTextMetrics.textHeight,
        ),
        SizedBox(height: 16.h),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _ScoreColumn(label: l10n.score, child:
            Text('$score',
              style: textTheme.headlineMedium?.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700,
                fontSize: 24.sp, letterSpacing: 0.072),
              strutStyle: AppTextMetrics.strut(fontSize: 24, lineHeight: 32),
              textHeightBehavior: AppTextMetrics.textHeight,
            ),
          )),
          Expanded(child: _ScoreColumn(label: l10n.rating, child:
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(color: ratingBg, borderRadius: BorderRadius.circular(9999.r)),
              child: Text(_ratingLabel(rating),
                style: textTheme.bodyMedium?.copyWith(
                  color: ratingFg, fontWeight: FontWeight.w500, letterSpacing: -0.154),
                strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
            ),
          )),
          Expanded(child: _ScoreColumn(label: l10n.valueAtRisk, child:
            Text(_formatVAR(valueAtRisk),
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700,
                fontSize: 18.sp, letterSpacing: -0.45),
              strutStyle: AppTextMetrics.strut(fontSize: 18, lineHeight: 28),
              textHeightBehavior: AppTextMetrics.textHeight,
            ),
          )),
        ]),
      ]),
    );
  }

  static String _ratingFor(int s) {
    if (s >= 15) return 'critical';
    if (s >= 10) return 'high';
    if (s >= 5) return 'medium';
    return 'low';
  }

  static (Color, Color) _ratingColors(String r) => switch (r) {
    'critical' => (AppColors.statusCriticalBg, AppColors.statusCriticalFg),
    'high' => (AppColors.statusHighBg, AppColors.statusHighFg),
    'medium' => (AppColors.statusMediumBg, AppColors.statusMediumFg),
    _ => (AppColors.statusLowBg, AppColors.statusLowFg),
  };

  static String _ratingLabel(String r) => switch (r) {
    'critical' => 'Critical',
    'high' => 'High',
    'medium' => 'Medium',
    _ => 'Low',
  };

  static String _formatVAR(double v) {
    if (v >= 1e9) return '\$${(v / 1e9).toStringAsFixed(2)}B';
    if (v >= 1e6) return '\$${(v / 1e6).toStringAsFixed(2)}M';
    if (v >= 1e3) return '\$${(v / 1e3).toStringAsFixed(2)}K';
    return '\$${v.toStringAsFixed(0)}';
  }
}

class _ScoreColumn extends StatelessWidget {
  const _ScoreColumn({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textBody, fontWeight: FontWeight.w400, fontSize: 12.sp),
        strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
        textHeightBehavior: AppTextMetrics.textHeight,
      ),
      SizedBox(height: 4.h),
      child,
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  STEP 2 — TREATMENT
// ═══════════════════════════════════════════════════════════════════════

class _TreatmentStepContent extends StatelessWidget {
  const _TreatmentStepContent({
    required this.treatmentStrategy,
    required this.onStrategyChanged,
    required this.treatmentStatus,
    required this.onStatusChanged,
    required this.riskAppetite,
    required this.onAppetiteChanged,
    required this.riskToleranceController,
    required this.treatmentPlanController,
    required this.strategies,
    required this.statuses,
    required this.appetites,
  });

  final String treatmentStrategy;
  final ValueChanged<String?> onStrategyChanged;
  final String treatmentStatus;
  final ValueChanged<String?> onStatusChanged;
  final String riskAppetite;
  final ValueChanged<String?> onAppetiteChanged;
  final TextEditingController riskToleranceController;
  final TextEditingController treatmentPlanController;
  final List<String> strategies;
  final List<String> statuses;
  final List<String> appetites;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _SectionTitle(l10n.riskTreatmentStrategyTitle),
      SizedBox(height: 24.h),
      _TwoCol(gap: 16.w,
        left: AppSelectField<String>(
          label: l10n.treatmentStrategyLabel, isRequired: true,
          value: treatmentStrategy,
          items: strategies,
          itemLabel: (v) => _strategyLabel(l10n, v),
          onChanged: onStrategyChanged,
        ),
        right: AppSelectField<String>(
          label: l10n.statusLabel, isRequired: true,
          value: treatmentStatus,
          items: statuses,
          itemLabel: (v) => _statusLabel(l10n, v),
          onChanged: onStatusChanged,
        ),
      ),
      SizedBox(height: 16.h),
      _TwoCol(gap: 16.w,
        left: AppSelectField<String>(
          label: l10n.riskAppetite,
          value: riskAppetite,
          items: appetites,
          itemLabel: (v) => _appetiteLabel(l10n, v),
          onChanged: onAppetiteChanged,
        ),
        right: AppTextField(
          label: l10n.riskToleranceUsd, labelSpacing: 4,
          controller: riskToleranceController,
          hint: '0',
          keyboardType: TextInputType.number,
        ),
      ),
      SizedBox(height: 16.h),
      AppTextField(
        label: l10n.treatmentPlan, labelSpacing: 4,
        controller: treatmentPlanController,
        hint: l10n.treatmentPlanPlaceholder,
        minLines: 4, maxLines: 7,
      ),
    ]);
  }

  static String _strategyLabel(dynamic l10n, String v) => switch (v) {
    'transfer' => l10n.treatmentTransfer,
    'accept' => l10n.treatmentAccept,
    'avoid' => l10n.treatmentAvoid,
    _ => l10n.treatmentMitigate,
  };

  static String _statusLabel(dynamic l10n, String v) => switch (v) {
    'assessed' => l10n.statusAssessed,
    'treated' => l10n.statusTreated,
    'monitored' => l10n.statusMonitored,
    _ => l10n.statusIdentified,
  };

  static String _appetiteLabel(dynamic l10n, String v) => switch (v) {
    'moderate' => l10n.appetiteModerate,
    'aggressive' => l10n.appetiteAggressive,
    _ => l10n.appetiteCautious,
  };
}

// ═══════════════════════════════════════════════════════════════════════
//  STEP 3 — CONTROLS
// ═══════════════════════════════════════════════════════════════════════

class _ControlsStepContent extends StatelessWidget {
  const _ControlsStepContent({
    required this.controlEffectiveness,
    required this.onEffectivenessChanged,
    required this.likelihood,
    required this.impact,
    required this.residualScore,
    required this.residualVAR,
    required this.reductionPct,
  });

  final double controlEffectiveness;
  final ValueChanged<double> onEffectivenessChanged;
  final int likelihood;
  final int impact;
  final int residualScore;
  final double residualVAR;
  final double reductionPct;

  static const _levelLabels = ['', '1 - Very Low', '2 - Low', '3 - Medium', '4 - High', '5 - Very High'];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _SectionTitle(l10n.controlEffectivenessTitle),
      SizedBox(height: 24.h),
      // ── Slider section ───────────────────────────────────────
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(l10n.overallControlEffectiveness,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textLabel, fontWeight: FontWeight.w500, letterSpacing: -0.154),
          strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
          textHeightBehavior: AppTextMetrics.textHeight,
        ),
        SizedBox(height: 10.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.primary,
            inactiveTrackColor: AppColors.borderInput,
            thumbColor: AppColors.primary,
            overlayColor: AppColors.primary.withValues(alpha: 0.12),
            trackHeight: 4.h,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
          ),
          child: Slider(
            value: controlEffectiveness,
            min: 0,
            max: 100,
            onChanged: onEffectivenessChanged,
          ),
        ),
        SizedBox(height: 4.h),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('0%',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textBody, letterSpacing: -0.154),
            strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          Text('${controlEffectiveness.toStringAsFixed(0)}%',
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.primary, fontWeight: FontWeight.w600,
              fontSize: 18.sp, letterSpacing: -0.45),
            strutStyle: AppTextMetrics.strut(fontSize: 18, lineHeight: 28),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          Text('100%',
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textBody, letterSpacing: -0.154),
            strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
        ]),
      ]),
      SizedBox(height: 24.h),
      // ── Residual Risk card ───────────────────────────────────
      Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFFFF7ED), Color(0xFFFEFCE8)]),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l10n.residualRiskAfterControls,
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary, fontWeight: FontWeight.w600,
              fontSize: 16.sp, letterSpacing: -0.32),
            strutStyle: AppTextMetrics.strut(fontSize: 16, lineHeight: 24),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          SizedBox(height: 16.h),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Likelihood
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _MiniLabel(l10n.likelihood),
              SizedBox(height: 4.h),
              _BoldValue(_levelLabels[likelihood.clamp(1, 5)]),
            ])),
            // Impact
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _MiniLabel(l10n.impact),
              SizedBox(height: 4.h),
              _BoldValue(_levelLabels[impact.clamp(1, 5)]),
            ])),
            // Score
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _MiniLabel(l10n.score),
              SizedBox(height: 4.h),
              Text('$residualScore',
                style: textTheme.headlineMedium?.copyWith(
                  color: AppColors.textPrimary, fontWeight: FontWeight.w700,
                  fontSize: 24.sp, letterSpacing: 0.072),
                strutStyle: AppTextMetrics.strut(fontSize: 24, lineHeight: 32),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
              SizedBox(height: 4.h),
              _RatingBadge(score: residualScore),
            ])),
            // VAR
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _MiniLabel(l10n.valueAtRisk),
              SizedBox(height: 4.h),
              Text(_InherentRiskScoreCard._formatVAR(residualVAR),
                style: textTheme.titleLarge?.copyWith(
                  color: _kResidualColor, fontWeight: FontWeight.w700,
                  fontSize: 18.sp, letterSpacing: -0.45),
                strutStyle: AppTextMetrics.strut(fontSize: 18, lineHeight: 28),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
              SizedBox(height: 2.h),
              Text('↓ ${reductionPct.toStringAsFixed(1)}% reduction',
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.statusLowFg, fontWeight: FontWeight.w400, fontSize: 12.sp),
                strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
                textHeightBehavior: AppTextMetrics.textHeight,
              ),
            ])),
          ]),
        ]),
      ),
      SizedBox(height: 16.h),
      // ── Note box ────────────────────────────────────────────
      Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.primaryLightBg,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: RichText(
          text: TextSpan(
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.textBody, fontWeight: FontWeight.w400, letterSpacing: -0.154),
            children: [
              TextSpan(text: 'Note: ', style: const TextStyle(fontWeight: FontWeight.w700)),
              TextSpan(text: 'Link specific controls in the next step to track individual control effectiveness and test results.'),
            ],
          ),
        ),
      ),
    ]);
  }
}

class _MiniLabel extends StatelessWidget {
  const _MiniLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: AppColors.textBody, fontWeight: FontWeight.w400, fontSize: 12.sp),
      strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
      textHeightBehavior: AppTextMetrics.textHeight,
    );
  }
}

class _BoldValue extends StatelessWidget {
  const _BoldValue(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: AppColors.textPrimary, fontWeight: FontWeight.w700,
        fontSize: 18.sp, letterSpacing: -0.45),
      strutStyle: AppTextMetrics.strut(fontSize: 18, lineHeight: 28),
      textHeightBehavior: AppTextMetrics.textHeight,
    );
  }
}

class _RatingBadge extends StatelessWidget {
  const _RatingBadge({required this.score});
  final int score;

  @override
  Widget build(BuildContext context) {
    final rating = _InherentRiskScoreCard._ratingFor(score);
    final (bg, fg) = _InherentRiskScoreCard._ratingColors(rating);
    final label = _InherentRiskScoreCard._ratingLabel(rating);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(9999.r)),
      child: Text(label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: fg, fontWeight: FontWeight.w500, fontSize: 12.sp),
        strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
        textHeightBehavior: AppTextMetrics.textHeight,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  STEP 4 — MITIGATION
// ═══════════════════════════════════════════════════════════════════════

class _MitigationStepContent extends StatelessWidget {
  const _MitigationStepContent({
    required this.notesController,
    required this.titleValue,
    required this.categoryValue,
    required this.inherentScore,
    required this.inherentVAR,
    required this.residualScore,
    required this.residualVAR,
    required this.treatmentValue,
    required this.ownerValue,
  });

  final TextEditingController notesController;
  final String? titleValue;
  final String categoryValue;
  final int inherentScore;
  final double inherentVAR;
  final int residualScore;
  final double residualVAR;
  final String treatmentValue;
  final String? ownerValue;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    final inherentRating = _InherentRiskScoreCard._ratingLabel(
        _InherentRiskScoreCard._ratingFor(inherentScore));
    final residualRating = _InherentRiskScoreCard._ratingLabel(
        _InherentRiskScoreCard._ratingFor(residualScore));

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _SectionTitle(l10n.mitigationActionsTitle),
      SizedBox(height: 24.h),
      // ── Info box ─────────────────────────────────────────────
      Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.primaryLightBg,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Text(l10n.mitigationInfoText,
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textLabel, fontWeight: FontWeight.w400, letterSpacing: -0.154),
          strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
          textHeightBehavior: AppTextMetrics.textHeight,
        ),
      ),
      SizedBox(height: 24.h),
      // ── Notes textarea ────────────────────────────────────────
      AppTextField(
        label: l10n.notesLabel, labelSpacing: 4,
        controller: notesController, hint: l10n.notesPlaceholder,
        minLines: 4, maxLines: 7,
      ),
      SizedBox(height: 24.h),
      // ── Risk Summary card ─────────────────────────────────────
      Container(
        padding: EdgeInsets.all(24.r),
        decoration: BoxDecoration(
          color: AppColors.bg, borderRadius: BorderRadius.circular(10.r)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(l10n.riskSummary,
            style: textTheme.bodyLarge?.copyWith(
              color: AppColors.textPrimary, fontWeight: FontWeight.w600,
              fontSize: 16.sp, letterSpacing: -0.32),
            strutStyle: AppTextMetrics.strut(fontSize: 16, lineHeight: 24),
            textHeightBehavior: AppTextMetrics.textHeight,
          ),
          SizedBox(height: 16.h),
          _TwoCol(gap: 16.w,
            left: _SummaryItem(
              term: l10n.summaryTitle,
              value: titleValue ?? l10n.notSet,
              valueColor: AppColors.textPrimary,
            ),
            right: _SummaryItem(
              term: l10n.category,
              value: categoryValue,
              valueColor: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          _TwoCol(gap: 16.w,
            left: _SummaryItem(
              term: l10n.inherentRisk,
              value: '$inherentScore ($inherentRating) - ${_InherentRiskScoreCard._formatVAR(inherentVAR)}',
              valueColor: _kInherentRedColor,
            ),
            right: _SummaryItem(
              term: l10n.residualRisk,
              value: '$residualScore ($residualRating) - ${_InherentRiskScoreCard._formatVAR(residualVAR)}',
              valueColor: _kResidualColor,
            ),
          ),
          SizedBox(height: 16.h),
          _TwoCol(gap: 16.w,
            left: _SummaryItem(
              term: l10n.summaryTreatment,
              value: treatmentValue,
              valueColor: AppColors.textPrimary,
            ),
            right: _SummaryItem(
              term: l10n.summaryOwner,
              value: ownerValue ?? l10n.notSet,
              valueColor: AppColors.textPrimary,
            ),
          ),
        ]),
      ),
    ]);
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({required this.term, required this.value, required this.valueColor});
  final String term;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(term,
        style: textTheme.bodyMedium?.copyWith(
          color: AppColors.textBody, fontWeight: FontWeight.w400, letterSpacing: -0.154),
        strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
        textHeightBehavior: AppTextMetrics.textHeight,
      ),
      SizedBox(height: 4.h),
      Text(value,
        style: textTheme.bodyMedium?.copyWith(
          color: valueColor, fontWeight: FontWeight.w500, letterSpacing: -0.154),
        strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
        textHeightBehavior: AppTextMetrics.textHeight,
      ),
    ]);
  }
}

// ═══════════════════════════════════════════════════════════════════════
//  SHARED HELPERS
// ═══════════════════════════════════════════════════════════════════════

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: AppColors.textPrimary, fontWeight: FontWeight.w600, letterSpacing: -0.45),
      strutStyle: AppTextMetrics.strut(fontSize: 18, lineHeight: 28),
      textHeightBehavior: AppTextMetrics.textHeight,
    );
  }
}

class _TwoCol extends StatelessWidget {
  const _TwoCol({required this.left, required this.right, required this.gap});
  final Widget left;
  final Widget right;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(child: left), SizedBox(width: gap), Expanded(child: right),
    ]);
  }
}

class _ThreeCol extends StatelessWidget {
  const _ThreeCol({required this.children, required this.gap});
  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      items.add(Expanded(child: children[i]));
      if (i < children.length - 1) items.add(SizedBox(width: gap));
    }
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: items);
  }
}

class _AffectedAssetsField extends StatelessWidget {
  const _AffectedAssetsField({
    required this.label, required this.assets, required this.selected,
    required this.hint, required this.onToggle,
  });
  final String label;
  final List<String> assets;
  final Set<String> selected;
  final String hint;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _FieldLabel(label: label),
      SizedBox(height: 4.h),
      Container(
        height: 98.h,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderInput),
          borderRadius: BorderRadius.circular(10.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: ListView.builder(
          padding: EdgeInsets.fromLTRB(13.w, 11.5.h, 13.w, 9.h),
          itemCount: assets.length,
          itemBuilder: (context, i) {
            final a = assets[i];
            final sel = selected.contains(a);
            return GestureDetector(
              onTap: () => onToggle(a),
              child: Container(
                color: sel ? AppColors.primaryTint.withValues(alpha: 0.6) : Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 1.h),
                child: Text(a,
                  style: textTheme.bodyLarge?.copyWith(
                    color: sel ? AppColors.primaryDark : AppColors.textDark,
                    fontWeight: FontWeight.w400, letterSpacing: -0.32),
                  strutStyle: AppTextMetrics.strut(fontSize: 16, lineHeight: 22),
                  textHeightBehavior: AppTextMetrics.textHeight,
                ),
              ),
            );
          },
        ),
      ),
      SizedBox(height: 5.5.h),
      Text(hint,
        style: textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary, fontWeight: FontWeight.w400, fontSize: 12.sp),
        strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
        textHeightBehavior: AppTextMetrics.textHeight,
      ),
    ]);
  }
}

class _AddItemField extends StatelessWidget {
  const _AddItemField({
    required this.label, required this.controller, required this.hint, required this.onAdd,
  });
  final String label;
  final TextEditingController controller;
  final String hint;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _FieldLabel(label: label),
      SizedBox(height: 4.h),
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(child: SizedBox(
          height: AppTextField.fieldHeight.h,
          child: TextField(
            controller: controller,
            onSubmitted: (_) => onAdd(),
            decoration: AppTextField.decoration(hint: hint),
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.textDark, letterSpacing: -0.32),
          ),
        )),
        SizedBox(width: 8.w),
        _PlusButton(onTap: onAdd),
      ]),
    ]);
  }
}

class _PlusButton extends StatelessWidget {
  const _PlusButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: SizedBox(
          width: AppTextField.fieldHeight.h, height: AppTextField.fieldHeight.h,
          child: Center(child: SvgPicture.asset(
            'assets/figma/risks/svg/add_risk.svg',
            width: 16.r, height: 16.r,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          )),
        ),
      ),
    );
  }
}

class _TagsRow extends StatelessWidget {
  const _TagsRow({required this.items, required this.color});
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6.w, runSpacing: 4.h,
      children: items.map((item) => Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6.r)),
        child: Text(item,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.primaryDark, fontWeight: FontWeight.w500, fontSize: 12.sp),
        ),
      )).toList(),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.textLabel, fontWeight: FontWeight.w500, letterSpacing: -0.154),
      strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
      textHeightBehavior: AppTextMetrics.textHeight,
    );
  }
}
