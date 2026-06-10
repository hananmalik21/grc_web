import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/l10n/app_localizations.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_field.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';
import 'package:grc_web/features/library/domain/entities/library_entities.dart';

enum QuestionFormMode { add, edit }

Future<void> showEditQuestionDialog({
  required BuildContext context,
  required LibraryQuestion question,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => QuestionFormDialog(mode: QuestionFormMode.edit, question: question),
  );
}

Future<void> showAddQuestionDialog({
  required BuildContext context,
  LibrarySection? section,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => QuestionFormDialog(mode: QuestionFormMode.add, section: section),
  );
}

class QuestionFormDialog extends StatefulWidget {
  const QuestionFormDialog({
    super.key,
    required this.mode,
    this.question,
    this.section,
  }) : assert(
          mode == QuestionFormMode.add || question != null,
          'Edit mode requires a question.',
        );

  final QuestionFormMode mode;
  final LibraryQuestion? question;
  final LibrarySection? section;

  static const _textHeight = AppTextMetrics.textHeight;

  bool get isAddMode => mode == QuestionFormMode.add;

  @override
  State<QuestionFormDialog> createState() => _QuestionFormDialogState();
}

class _QuestionFormDialogState extends State<QuestionFormDialog> {
  late final TextEditingController _questionIdController;
  late final TextEditingController _questionTextController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _weightController;
  late final TextEditingController _categoryController;
  late final TextEditingController _subcategoryController;
  late final TextEditingController _guidanceNotesController;
  late final TextEditingController _tagInputController;
  late final TextEditingController _controlInputController;

  late String _questionType;
  late bool _requiresEvidence;
  late Set<String> _selectedCriteria;
  late List<String> _tags;
  late List<String> _relatedControls;

  @override
  void initState() {
    super.initState();
    if (widget.isAddMode) {
      _questionIdController = TextEditingController();
      _questionTextController = TextEditingController();
      _descriptionController = TextEditingController();
      _weightController = TextEditingController(text: '5');
      _categoryController = TextEditingController();
      _subcategoryController = TextEditingController();
      _guidanceNotesController = TextEditingController();
      _questionType = 'yes-no';
      _requiresEvidence = false;
      _selectedCriteria = {'Documentation', 'Implementation'};
      _tags = [];
      _relatedControls = [];
    } else {
      final question = widget.question!;
      _questionIdController = TextEditingController(text: question.code);
      _questionTextController = TextEditingController(text: question.title);
      _descriptionController = TextEditingController(text: question.description);
      _weightController = TextEditingController(text: '${question.weight}');
      _categoryController = TextEditingController(
        text: question.categoryChips.isNotEmpty ? question.categoryChips.first : '',
      );
      _subcategoryController = TextEditingController(
        text: question.categoryChips.length > 1 ? question.categoryChips[1] : '',
      );
      _guidanceNotesController = TextEditingController(text: question.guidanceNotes);
      _questionType = question.typeChip == 'yes-no' ? 'yes-no' : question.typeChip;
      _requiresEvidence = question.requiresEvidence;
      _selectedCriteria = question.evaluationCriteria.map((c) => c.title).toSet();
      _tags = List<String>.from(question.tags);
      _relatedControls = List<String>.from(question.relatedControls);
    }
    _tagInputController = TextEditingController();
    _controlInputController = TextEditingController();
  }

  @override
  void dispose() {
    _questionIdController.dispose();
    _questionTextController.dispose();
    _descriptionController.dispose();
    _weightController.dispose();
    _categoryController.dispose();
    _subcategoryController.dispose();
    _guidanceNotesController.dispose();
    _tagInputController.dispose();
    _controlInputController.dispose();
    super.dispose();
  }

  List<_CriteriaOption> _criteriaOptions(AppLocalizations l10n) {
    return [
      _CriteriaOption('Documentation', l10n.criteriaDocumentation, l10n.criteriaDocumentationDesc, 20),
      _CriteriaOption('Implementation', l10n.criteriaImplementation, l10n.criteriaImplementationDesc, 30),
      _CriteriaOption('Effectiveness', l10n.criteriaEffectiveness, l10n.criteriaEffectivenessDesc, 25),
      _CriteriaOption('Monitoring', l10n.criteriaMonitoring, l10n.criteriaMonitoringDesc, 15),
      _CriteriaOption(
        'Continuous Improvement',
        l10n.criteriaContinuousImprovement,
        l10n.criteriaContinuousImprovementDesc,
        10,
      ),
    ];
  }

  void _toggleCriteria(String title) {
    setState(() {
      if (_selectedCriteria.contains(title)) {
        _selectedCriteria.remove(title);
      } else {
        _selectedCriteria.add(title);
      }
    });
  }

  void _addTag() {
    final value = _tagInputController.text.trim();
    if (value.isEmpty || _tags.contains(value)) return;
    setState(() {
      _tags.add(value.startsWith('#') ? value : '#$value');
      _tagInputController.clear();
    });
  }

  void _addControl() {
    final value = _controlInputController.text.trim();
    if (value.isEmpty || _relatedControls.contains(value)) return;
    setState(() {
      _relatedControls.add(value);
      _controlInputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final screen = MediaQuery.sizeOf(context);
    final dialogWidth = math.min(936.w, screen.width - 48.w);
    final dialogHeight = math.min(screen.height - 48.h, screen.height * 0.92);
    final criteria = _criteriaOptions(l10n);
    final questionIdPlaceholder = widget.isAddMode ? l10n.questionIdPlaceholder : null;

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
                _EditDialogHeader(
                  title: widget.isAddMode ? l10n.addNewQuestion : l10n.editQuestion,
                  onClose: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: ColoredBox(
                    color: AppColors.surface,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SectionTitle(title: l10n.basicInformation),
                          SizedBox(height: 16.h),
                          AppField.text(
                            label: l10n.questionId,
                            isRequired: true,
                            labelSpacing: 4,
                            controller: _questionIdController,
                            hint: widget.isAddMode ? questionIdPlaceholder : null,
                            readOnly: !widget.isAddMode,
                            helperText: widget.isAddMode ? null : l10n.questionIdHint,
                          ),
                          SizedBox(height: 16.h),
                          AppField.text(
                            label: l10n.questionText,
                            isRequired: true,
                            labelSpacing: 4,
                            controller: _questionTextController,
                            minLines: 3,
                            hint: widget.isAddMode ? l10n.questionTextPlaceholder : null,
                          ),
                          SizedBox(height: 16.h),
                          AppField.text(
                            label: l10n.descriptionOptional,
                            labelSpacing: 4,
                            controller: _descriptionController,
                            minLines: 2,
                            hint: widget.isAddMode ? l10n.descriptionPlaceholder : null,
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AppField.select<String>(
                                  label: l10n.questionType,
                                  isRequired: true,
                                  labelSpacing: 4,
                                  value: _questionType,
                                  items: const ['yes-no'],
                                  itemLabel: (value) =>
                                      value == 'yes-no' ? l10n.questionTypeYesNo : value,
                                  onChanged: (value) {
                                    if (value != null) setState(() => _questionType = value);
                                  },
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: AppField.text(
                                  label: l10n.weightRange,
                                  isRequired: true,
                                  labelSpacing: 4,
                                  controller: _weightController,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: AppField.text(
                                  label: l10n.category,
                                  isRequired: true,
                                  labelSpacing: 4,
                                  controller: _categoryController,
                                  hint: widget.isAddMode ? l10n.categoryPlaceholder : null,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: AppField.text(
                                  label: l10n.subcategoryOptional,
                                  labelSpacing: 4,
                                  controller: _subcategoryController,
                                  hint: widget.isAddMode ? l10n.subcategoryPlaceholder : null,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 32.h),
                          _SectionTitle(title: l10n.evaluationCriteria),
                          SizedBox(height: 16.h),
                          Text(
                            l10n.evaluationCriteriaHint,
                            style: textTheme.bodyMedium?.copyWith(
                              color: AppColors.textBody,
                              fontWeight: FontWeight.w400,
                              letterSpacing: -0.154,
                            ),
                            strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                            textHeightBehavior: QuestionFormDialog._textHeight,
                          ),
                          SizedBox(height: 16.h),
                          for (final option in criteria) ...[
                            _CriteriaCard(
                              title: option.label,
                              description: option.description,
                              weightLabel: l10n.criteriaWeightLabel(option.weightPercent),
                              selected: _selectedCriteria.contains(option.id),
                              onTap: () => _toggleCriteria(option.id),
                            ),
                            if (option != criteria.last) SizedBox(height: 8.h),
                          ],
                          SizedBox(height: 32.h),
                          _SectionTitle(title: l10n.tags),
                          SizedBox(height: 16.h),
                          _AddItemRow(
                            controller: _tagInputController,
                            hint: l10n.addTagPlaceholder,
                            onAdd: _addTag,
                          ),
                          if (_tags.isNotEmpty) ...[
                            SizedBox(height: 16.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: [
                                for (final tag in _tags)
                                  _TagChip(
                                    label: tag,
                                    onRemove: () => setState(() => _tags.remove(tag)),
                                  ),
                              ],
                            ),
                          ],
                          SizedBox(height: 32.h),
                          _SectionTitle(title: l10n.relatedControlsOptional),
                          SizedBox(height: 16.h),
                          _AddItemRow(
                            controller: _controlInputController,
                            hint: l10n.addControlPlaceholder,
                            onAdd: _addControl,
                          ),
                          if (_relatedControls.isNotEmpty) ...[
                            SizedBox(height: 16.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: [
                                for (final control in _relatedControls)
                                  _ControlChip(
                                    label: control,
                                    onRemove: () => setState(() => _relatedControls.remove(control)),
                                  ),
                              ],
                            ),
                          ],
                          SizedBox(height: 32.h),
                          _SectionTitle(title: l10n.additionalSettings),
                          SizedBox(height: 16.h),
                          _RequireEvidenceCard(
                            title: l10n.requireEvidence,
                            description: l10n.requireEvidenceDescription,
                            selected: _requiresEvidence,
                            onTap: () => setState(() => _requiresEvidence = !_requiresEvidence),
                          ),
                          SizedBox(height: 16.h),
                          AppField.text(
                            label: l10n.guidanceNotesOptional,
                            labelSpacing: 4,
                            controller: _guidanceNotesController,
                            minLines: 3,
                            hint: widget.isAddMode ? l10n.guidanceNotesPlaceholder : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _EditDialogFooter(
                  cancelLabel: l10n.cancel,
                  saveLabel: widget.isAddMode ? l10n.addQuestion : l10n.saveChanges,
                  saveIconAsset: widget.isAddMode
                      ? 'assets/figma/library/svg/add_question.svg'
                      : 'assets/figma/library/svg/save_changes.svg',
                  onCancel: () => Navigator.of(context).pop(),
                  onSave: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CriteriaOption {
  const _CriteriaOption(this.id, this.label, this.description, this.weightPercent);

  final String id;
  final String label;
  final String description;
  final int weightPercent;
}

class _EditDialogHeader extends StatelessWidget {
  const _EditDialogHeader({required this.title, required this.onClose});

  final String title;
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
            child: Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.46,
              ),
              strutStyle: AppTextMetrics.strut(fontSize: 20, lineHeight: 28),
              textHeightBehavior: QuestionFormDialog._textHeight,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onClose,
              borderRadius: BorderRadius.circular(10.r),
              child: SizedBox(
                width: 32.r,
                height: 32.r,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/figma/library/svg/close_white.svg',
                    width: 20.r,
                    height: 20.r,
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

class _EditDialogFooter extends StatelessWidget {
  const _EditDialogFooter({
    required this.cancelLabel,
    required this.saveLabel,
    required this.saveIconAsset,
    required this.onCancel,
    required this.onSave,
  });

  final String cancelLabel;
  final String saveLabel;
  final String saveIconAsset;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 17.h, 24.w, 16.h),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          AppButton(
            label: cancelLabel,
            variant: AppButtonVariant.outlined,
            onPressed: onCancel,
          ),
          SizedBox(width: 12.w),
          AppButton(
            label: saveLabel,
            iconAsset: saveIconAsset,
            iconColor: Colors.white,
            size: AppButtonSize.save,
            onPressed: onSave,
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.45,
          ),
      strutStyle: AppTextMetrics.strut(fontSize: 18, lineHeight: 28),
      textHeightBehavior: QuestionFormDialog._textHeight,
    );
  }
}

class _CriteriaCard extends StatelessWidget {
  const _CriteriaCard({
    required this.title,
    required this.description,
    required this.weightLabel,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final String weightLabel;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: selected ? AppColors.primaryLightBg : AppColors.surface,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
              width: 2,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: _CheckboxIndicator(selected: selected, size: 13.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.32,
                      ),
                      strutStyle: AppTextMetrics.strut(fontSize: 16, lineHeight: 24),
                      textHeightBehavior: QuestionFormDialog._textHeight,
                    ),
                    Text(
                      description,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textBody,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.154,
                      ),
                      strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                      textHeightBehavior: QuestionFormDialog._textHeight,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      weightLabel,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                      strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
                      textHeightBehavior: QuestionFormDialog._textHeight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequireEvidenceCard extends StatelessWidget {
  const _RequireEvidenceCard({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: AppColors.weightWarningBg,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.all(17.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: AppColors.weightWarningBorder),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CheckboxIndicator(selected: selected, size: 16.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.32,
                      ),
                      strutStyle: AppTextMetrics.strut(fontSize: 16, lineHeight: 24),
                      textHeightBehavior: QuestionFormDialog._textHeight,
                    ),
                    Text(
                      description,
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.textBody,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.154,
                      ),
                      strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                      textHeightBehavior: QuestionFormDialog._textHeight,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckboxIndicator extends StatelessWidget {
  const _CheckboxIndicator({required this.selected, required this.size});

  final bool selected;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: selected ? AppColors.checkboxBlue : AppColors.surface,
        borderRadius: BorderRadius.circular(2.5.r),
        border: selected ? null : Border.all(color: AppColors.checkboxBorder),
      ),
    );
  }
}

class _AddItemRow extends StatelessWidget {
  const _AddItemRow({
    required this.controller,
    required this.hint,
    required this.onAdd,
  });

  final TextEditingController controller;
  final String hint;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AppField.text(
            controller: controller,
            hint: hint,
            onSubmitted: (_) => onAdd(),
          ),
        ),
        SizedBox(width: 8.w),
        Material(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(10.r),
          child: InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(10.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
              child: SvgPicture.asset(
                'assets/figma/library/svg/add_plus.svg',
                width: 16.r,
                height: 16.r,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.chipNeutralBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.tagChipFg,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.154,
                ),
            strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
            textHeightBehavior: QuestionFormDialog._textHeight,
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: onRemove,
            child: SvgPicture.asset(
              'assets/figma/library/svg/chip_remove.svg',
              width: 12.r,
              height: 12.r,
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlChip extends StatelessWidget {
  const _ControlChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.relatedControlChipBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontFamily: 'Menlo',
                  color: AppColors.relatedControlChipFg,
                  fontWeight: FontWeight.w400,
                ),
            strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
            textHeightBehavior: QuestionFormDialog._textHeight,
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap: onRemove,
            child: SvgPicture.asset(
              'assets/figma/library/svg/chip_remove_control.svg',
              width: 12.r,
              height: 12.r,
            ),
          ),
        ],
      ),
    );
  }
}
