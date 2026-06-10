import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/l10n/app_localizations.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
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

  static const _dialogWidth = 672.0;

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
    final screenW = MediaQuery.sizeOf(context).width;
    final hPad = ((screenW - CreateAssessmentDialog._dialogWidth.w) / 2)
        .clamp(16.0, double.infinity);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: hPad, vertical: 40.h),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        width: CreateAssessmentDialog._dialogWidth.w,
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          elevation: 25,
          shadowColor: Colors.black.withValues(alpha: 0.15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _header(l10n),
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24.w),
                    child: _form(l10n),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(AppLocalizations l10n) {
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
              l10n.caTitle,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                height: 28 / 20,
                letterSpacing: -0.46,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(10.r),
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: SvgPicture.asset(
                  'assets/figma/library/svg/close_white.svg',
                  width: 20.r,
                  height: 20.r,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _form(AppLocalizations l10n) {
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
        SizedBox(height: 16.h),
        AppTextArea(
          controller: _descriptionController,
          label: l10n.caDescriptionLabel,
          hint: l10n.caDescriptionHint,
          minLines: 3,
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppSelectField<String>(
                label: l10n.category,
                value: _category,
                items: categoryItems,
                itemLabel: (v) => v,
                onChanged: (v) => setState(() => _category = v ?? _category),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: AppSelectField<String>(
                label: l10n.caColorThemeLabel,
                value: _colorTheme,
                items: themeItems,
                itemLabel: (v) => v,
                onChanged: (v) => setState(() => _colorTheme = v ?? _colorTheme),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
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
        ),
        SizedBox(height: 22.h),
        Container(
          padding: EdgeInsets.only(top: 17.h),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
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
