import 'dart:math' as math;

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_field.dart';
import 'package:grc_web/core/widgets/app_text_metrics.dart';
import 'package:grc_web/features/library/domain/entities/library_entities.dart';

Future<void> showManageCategoriesDialog({
  required BuildContext context,
  required LibraryData data,
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => ManageCategoriesDialog(data: data),
  );
}

class ManageCategoriesDialog extends StatefulWidget {
  const ManageCategoriesDialog({super.key, required this.data});

  final LibraryData data;

  static const _textHeight = AppTextMetrics.textHeight;

  @override
  State<ManageCategoriesDialog> createState() => _ManageCategoriesDialogState();
}

class _ManageCategoriesDialogState extends State<ManageCategoriesDialog> {
  bool _showNewCategoryForm = false;

  int get _totalWeight => widget.data.sections.fold(0, (sum, s) => sum + s.weightPercent);

  String get _libraryId {
    final framework = widget.data.frameworks.firstWhere((f) => f.id == widget.data.selectedFrameworkId);
    return framework.id == 'sox' ? 'sox-library' : framework.id;
  }

  void _openNewCategoryForm() => setState(() => _showNewCategoryForm = true);

  void _closeNewCategoryForm() => setState(() => _showNewCategoryForm = false);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screen = MediaQuery.sizeOf(context);
    final dialogWidth = math.min(936.w, screen.width - 48.w);
    final dialogHeight = math.min(screen.height - 48.h, screen.height * 0.92);
    final data = widget.data;

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
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 25,
                  offset: Offset(0, 20),
                ),
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 10,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                _DialogHeader(
                  title: l10n.manageCategories,
                  subtitle: l10n.manageCategoriesSubtitle(_libraryId, data.sections.length),
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
                          _WeightSummaryBanner(
                            totalWeight: _totalWeight,
                            label: l10n.totalCategoryWeight,
                            hint: l10n.categoryWeightHint,
                          ),
                          SizedBox(height: 24.h),
                          if (_showNewCategoryForm)
                            _NewCategoryForm(
                              onCancel: _closeNewCategoryForm,
                              onSave: _closeNewCategoryForm,
                            )
                          else
                            _AddCategoryButton(
                              label: l10n.addNewCategory,
                              onTap: _openNewCategoryForm,
                            ),
                          SizedBox(height: 24.h),
                          for (int i = 0; i < data.sections.length; i++) ...[
                            _CategoryCard(
                              code: 'sox-${data.sections[i].id}',
                              title: data.sections[i].title,
                              subtitle: data.sections[i].subtitle,
                              weightPercent: data.sections[i].weightPercent,
                              questionCount: data.sections[i].questionCount,
                              questionsLabel: l10n.questionsLower,
                            ),
                            if (i != data.sections.length - 1) SizedBox(height: 12.h),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                _DialogFooter(
                  summary: l10n.categoriesFooterSummary(data.sections.length, _totalWeight),
                  cancelLabel: l10n.cancel,
                  saveLabel: l10n.saveAllChanges,
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

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.title,
    required this.subtitle,
    required this.onClose,
  });

  final String title;
  final String subtitle;
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
              children: [
                Text(
                  title,
                  style: textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.46,
                  ),
                  strutStyle: AppTextMetrics.strut(fontSize: 20, lineHeight: 28),
                  textHeightBehavior: ManageCategoriesDialog._textHeight,
                ),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.154,
                  ),
                  strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                  textHeightBehavior: ManageCategoriesDialog._textHeight,
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

class _WeightSummaryBanner extends StatelessWidget {
  const _WeightSummaryBanner({
    required this.totalWeight,
    required this.label,
    required this.hint,
  });

  final int totalWeight;
  final String label;
  final String hint;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.weightWarningBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.weightWarningBorder, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.154,
                ),
                strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                textHeightBehavior: ManageCategoriesDialog._textHeight,
              ),
              Text(
                '$totalWeight%',
                style: textTheme.titleMedium?.copyWith(
                  color: AppColors.weightWarningValue,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.45,
                ),
                strutStyle: AppTextMetrics.strut(fontSize: 18, lineHeight: 28),
                textHeightBehavior: ManageCategoriesDialog._textHeight,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            hint,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.weightWarningHint,
              fontWeight: FontWeight.w400,
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
            textHeightBehavior: ManageCategoriesDialog._textHeight,
          ),
        ],
      ),
    );
  }
}

class _AddCategoryButton extends StatelessWidget {
  const _AddCategoryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: Radius.circular(10.r),
        color: AppColors.borderInput,
        strokeWidth: 2,
        dashPattern: const [6, 4],
        padding: EdgeInsets.zero,
        stackFit: StackFit.passthrough,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52.h,
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10.r),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10.r),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/figma/library/svg/add_category.svg',
                    width: 24.r,
                    height: 24.r,
                    colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    label,
                    style: textTheme.titleSmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.32,
                      height: 24 / 16,
                    ),
                    strutStyle: AppTextMetrics.strut(fontSize: 16, lineHeight: 24),
                    textHeightBehavior: ManageCategoriesDialog._textHeight,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NewCategoryForm extends StatefulWidget {
  const _NewCategoryForm({
    required this.onCancel,
    required this.onSave,
  });

  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  State<_NewCategoryForm> createState() => _NewCategoryFormState();
}

class _NewCategoryFormState extends State<_NewCategoryForm> {
  late final TextEditingController _categoryIdController;
  late final TextEditingController _categoryNameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _categoryIdController = TextEditingController();
    _categoryNameController = TextEditingController();
    _descriptionController = TextEditingController();
    _weightController = TextEditingController(text: '20');
  }

  @override
  void dispose() {
    _categoryIdController.dispose();
    _categoryNameController.dispose();
    _descriptionController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(26.w),
      decoration: BoxDecoration(
        color: AppColors.primaryLightBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.bannerBorder, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.newCategory,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.45,
            ),
            strutStyle: AppTextMetrics.strut(fontSize: 18, lineHeight: 28),
            textHeightBehavior: ManageCategoriesDialog._textHeight,
          ),
          SizedBox(height: 16.h),
          AppField.text(
            label: l10n.categoryId,
            isRequired: true,
            labelSpacing: 4,
            controller: _categoryIdController,
            hint: l10n.categoryIdPlaceholder,
          ),
          SizedBox(height: 16.h),
          AppField.text(
            label: l10n.categoryName,
            isRequired: true,
            labelSpacing: 4,
            controller: _categoryNameController,
            hint: l10n.categoryNamePlaceholder,
          ),
          SizedBox(height: 16.h),
          AppField.text(
            label: l10n.categoryDescription,
            labelSpacing: 4,
            controller: _descriptionController,
            minLines: 2,
            hint: l10n.categoryDescriptionPlaceholder,
          ),
          SizedBox(height: 16.h),
          AppField.text(
            label: l10n.weightPercent,
            isRequired: true,
            labelSpacing: 4,
            controller: _weightController,
            keyboardType: TextInputType.number,
            helperText: l10n.categoryWeightContributionHint,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: l10n.saveCategory,
                  iconAsset: 'assets/figma/library/svg/save_changes.svg',
                  iconColor: Colors.white,
                  size: AppButtonSize.save,
                  fullWidth: true,
                  onPressed: widget.onSave,
                ),
              ),
              SizedBox(width: 8.w),
              AppButton(
                label: l10n.cancel,
                variant: AppButtonVariant.outlined,
                onPressed: widget.onCancel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.weightPercent,
    required this.questionCount,
    required this.questionsLabel,
  });

  final String code;
  final String title;
  final String subtitle;
  final int weightPercent;
  final int questionCount;
  final String questionsLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      code,
                      style: textTheme.bodySmall?.copyWith(
                        fontFamily: 'Menlo',
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                      strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
                      textHeightBehavior: ManageCategoriesDialog._textHeight,
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLightBg,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        '$weightPercent%',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                        strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
                        textHeightBehavior: ManageCategoriesDialog._textHeight,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Flexible(
                      child: Text(
                        '$questionCount $questionsLabel',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                        strutStyle: AppTextMetrics.strut(fontSize: 12, lineHeight: 16),
                        textHeightBehavior: ManageCategoriesDialog._textHeight,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.32,
                    height: 24 / 16,
                  ),
                  strutStyle: AppTextMetrics.strut(fontSize: 16, lineHeight: 24),
                  textHeightBehavior: ManageCategoriesDialog._textHeight,
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.154,
                  ),
                  strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
                  textHeightBehavior: ManageCategoriesDialog._textHeight,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton.icon(
                  iconAsset: 'assets/figma/library/svg/edit_question.svg',
                  borderColor: AppColors.editBorderBlue,
                  onPressed: () {},
                ),
                SizedBox(width: 8.w),
                AppButton.icon(
                  iconAsset: 'assets/figma/library/svg/delete_question.svg',
                  borderColor: AppColors.deleteBorderRed,
                  backgroundColor: AppColors.deleteLightBg,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DialogFooter extends StatelessWidget {
  const _DialogFooter({
    required this.summary,
    required this.cancelLabel,
    required this.saveLabel,
    required this.onCancel,
    required this.onSave,
  });

  final String summary;
  final String cancelLabel;
  final String saveLabel;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 17.h, 24.w, 16.h),
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              summary,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.textBody,
                letterSpacing: -0.154,
              ),
              strutStyle: AppTextMetrics.strut(fontSize: 14, lineHeight: 20),
              textHeightBehavior: ManageCategoriesDialog._textHeight,
            ),
          ),
          AppButton(
            label: cancelLabel,
            variant: AppButtonVariant.outlined,
            onPressed: onCancel,
          ),
          SizedBox(width: 12.w),
          AppButton(
            label: saveLabel,
            iconAsset: 'assets/figma/library/svg/save_changes.svg',
            iconColor: Colors.white,
            variant: AppButtonVariant.primary,
            size: AppButtonSize.save,
            onPressed: onSave,
          ),
        ],
      ),
    );
  }
}
