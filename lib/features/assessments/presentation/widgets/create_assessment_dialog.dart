import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/l10n/app_localizations.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_responsive_dialog_metrics.dart';
import 'package:grc_web/core/widgets/app_select_field.dart';
import 'package:grc_web/core/widgets/app_text_field.dart';

Future<void> showCreateAssessmentDialog({required BuildContext context}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => const CreateAssessmentDialog(),
  );
}

class CreateAssessmentDialog extends StatefulWidget {
  const CreateAssessmentDialog({super.key});

  static const double maxDialogWidth = 672;

  @override
  State<CreateAssessmentDialog> createState() => _CreateAssessmentDialogState();
}

class _CreateAssessmentDialogState extends State<CreateAssessmentDialog> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _questionsController = TextEditingController(text: '0');
  final _categoriesController = TextEditingController(text: '0');
  final _estTimeController = TextEditingController();

  late String _category;
  late String _colorTheme;

  bool _initialised = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialised) return;
    final l10n = context.l10n;
    _category = l10n.caSelectCategory;
    _colorTheme = l10n.themeBlue;
    _initialised = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _questionsController.dispose();
    _categoriesController.dispose();
    _estTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final viewport = MediaQuery.sizeOf(context);
    final insetPadding =
        AppResponsiveDialogMetrics.insetPaddingForViewport(viewport.width);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: insetPadding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final dialogWidth = math.min(
            constraints.maxWidth,
            CreateAssessmentDialog.maxDialogWidth,
          );
          final metrics = AppResponsiveDialogMetrics.fromContext(
            context,
            dialogWidth: dialogWidth,
            dialogHeight: constraints.maxHeight,
            wideMinWidth: AppResponsiveDialogMetrics.compactDialogWideMinWidth,
          );

          return Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: dialogWidth,
              height: metrics.maxHeight,
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
                      _header(l10n, metrics),
                      Expanded(
                        child: SingleChildScrollView(
                          padding: metrics.contentPadding,
                          child: _form(l10n, metrics),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _header(AppLocalizations l10n, AppResponsiveDialogMetrics metrics) {
    return Container(
      padding: metrics.headerPadding,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.caTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: metrics.isPhone ? 18.sp : 20.sp,
                fontWeight: FontWeight.w600,
                height: 28 / 20,
                letterSpacing: -0.46,
              ),
            ),
          ),
          AppButton.close(
            onPressed: () => Navigator.of(context).pop(),
            iconSize: 20.r,
          ),
        ],
      ),
    );
  }

  Widget _form(AppLocalizations l10n, AppResponsiveDialogMetrics metrics) {
    final categoryItems = <String>[
      l10n.caSelectCategory,
      l10n.caCatCompliance,
      l10n.caCatSecurity,
      l10n.caCatPrivacy,
      l10n.caCatOperational,
      l10n.caCatFinancial,
    ];
    final themeItems = <String>[
      l10n.themeBlue,
      l10n.themeGreen,
      l10n.themePurple,
      l10n.themeOrange,
      l10n.themeRed,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField.normal(
          controller: _nameController,
          label: l10n.caNameLabel,
          hint: l10n.caNameHint,
        ),
        SizedBox(height: metrics.fieldGap),
        AppTextArea(
          controller: _descriptionController,
          label: l10n.caDescriptionLabel,
          hint: l10n.caDescriptionHint,
          minLines: 3,
        ),
        SizedBox(height: metrics.fieldGap),
        _ResponsiveFieldRow(
          metrics: metrics,
          left: AppSelectField<String>(
            label: l10n.category,
            value: _category,
            items: categoryItems,
            itemLabel: (v) => v,
            onChanged: (v) => setState(() => _category = v ?? _category),
          ),
          right: AppSelectField<String>(
            label: l10n.caColorThemeLabel,
            value: _colorTheme,
            items: themeItems,
            itemLabel: (v) => v,
            onChanged: (v) => setState(() => _colorTheme = v ?? _colorTheme),
          ),
        ),
        SizedBox(height: metrics.fieldGap),
        if (metrics.isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField.normal(
                  controller: _questionsController,
                  label: l10n.caQuestionsLabel,
                  hint: '0',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: AppTextField.normal(
                  controller: _categoriesController,
                  label: l10n.categories,
                  hint: '0',
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: AppTextField.normal(
                  controller: _estTimeController,
                  label: l10n.caEstTimeLabel,
                  hint: l10n.caEstTimeHint,
                ),
              ),
            ],
          )
        else ...[
          _ResponsiveFieldRow(
            metrics: metrics,
            left: AppTextField.normal(
              controller: _questionsController,
              label: l10n.caQuestionsLabel,
              hint: '0',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            right: AppTextField.normal(
              controller: _categoriesController,
              label: l10n.categories,
              hint: '0',
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
          ),
          SizedBox(height: metrics.fieldGap),
          AppTextField.normal(
            controller: _estTimeController,
            label: l10n.caEstTimeLabel,
            hint: l10n.caEstTimeHint,
          ),
        ],
        SizedBox(height: metrics.sectionGap),
        Container(
          padding: metrics.footerPadding,
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: metrics.useStackedFooter
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppButton(
                      label: l10n.createAssessment,
                      variant: AppButtonVariant.primary,
                      fullWidth: true,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(height: 10.h),
                    AppButton(
                      label: l10n.cancel,
                      variant: AppButtonVariant.outlined,
                      fullWidth: true,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppButton(
                      label: l10n.cancel,
                      variant: AppButtonVariant.outlined,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: 12.w),
                    AppButton(
                      label: l10n.createAssessment,
                      variant: AppButtonVariant.primary,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _ResponsiveFieldRow extends StatelessWidget {
  const _ResponsiveFieldRow({
    required this.metrics,
    required this.left,
    required this.right,
  });

  final AppResponsiveDialogMetrics metrics;
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    if (metrics.isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          SizedBox(width: 16.w),
          Expanded(child: right),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        left,
        SizedBox(height: metrics.fieldGap),
        right,
      ],
    );
  }
}
