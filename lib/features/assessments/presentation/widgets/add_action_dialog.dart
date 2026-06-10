import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/l10n/app_localizations.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_select_field.dart';
import 'package:grc_web/core/widgets/app_text_field.dart';

Future<void> showAddActionDialog({
  required BuildContext context,
  List<String> sections = const [],
}) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    builder: (context) => AddActionDialog(sections: sections),
  );
}

class AddActionDialog extends StatefulWidget {
  const AddActionDialog({super.key, this.sections = const []});

  final List<String> sections;

  static const _dialogWidth = 672.0;

  @override
  State<AddActionDialog> createState() => _AddActionDialogState();
}

class _AddActionDialogState extends State<AddActionDialog> {
  late String _relatedSection;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  late String _priority;
  late String _status;
  DateTime? _dueDate;
  final _ownerController = TextEditingController();

  bool _initialised = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialised) return;
    final l10n = context.l10n;
    _relatedSection = l10n.selectSectionHint;
    _priority = l10n.optionMedium;
    _status = l10n.optionOpen;
    _initialised = true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _ownerController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  String get _dueDateText {
    final d = _dueDate;
    if (d == null) return '';
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final screenW = MediaQuery.sizeOf(context).width;
    final hPad = ((screenW - AddActionDialog._dialogWidth.w) / 2)
        .clamp(16.0, double.infinity);

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: hPad, vertical: 40.h),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        width: AddActionDialog._dialogWidth.w,
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
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 16.w, 16.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.addRemediationAction,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                height: 28 / 18,
                letterSpacing: -0.45,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              borderRadius: BorderRadius.circular(10.r),
              child: SizedBox(
                width: 32.r,
                height: 32.r,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/figma/library/svg/close_white.svg',
                    width: 20.r,
                    height: 20.r,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textBody,
                      BlendMode.srcIn,
                    ),
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
    final sectionItems = <String>[l10n.selectSectionHint, ...widget.sections];
    final priorityItems = <String>[l10n.optionHigh, l10n.optionMedium, l10n.optionLow];
    final statusItems = <String>[l10n.optionOpen, l10n.optionInProgress, l10n.optionCompleted];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSelectField<String>(
          label: l10n.relatedSectionLabel,
          value: _relatedSection,
          items: sectionItems,
          itemLabel: (v) => v,
          onChanged: (v) => setState(() => _relatedSection = v ?? _relatedSection),
        ),
        SizedBox(height: 16.h),
        AppTextField.normal(
          controller: _titleController,
          label: l10n.actionTitleLabel,
          hint: l10n.actionTitleHint,
        ),
        SizedBox(height: 16.h),
        AppTextArea(
          controller: _descriptionController,
          label: l10n.actionDescriptionLabel,
          hint: l10n.actionDescriptionHint,
          minLines: 3,
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppSelectField<String>(
                label: l10n.priorityLabel,
                value: _priority,
                items: priorityItems,
                itemLabel: (v) => v,
                onChanged: (v) => setState(() => _priority = v ?? _priority),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: AppSelectField<String>(
                label: l10n.statusLabel,
                value: _status,
                items: statusItems,
                itemLabel: (v) => v,
                onChanged: (v) => setState(() => _status = v ?? _status),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppTextField(
                controller: TextEditingController(text: _dueDateText),
                label: l10n.dueDateLabel,
                hint: 'dd/mm/yyyy',
                readOnly: true,
                onTap: _pickDate,
                suffixIcon: Padding(
                  padding: EdgeInsetsDirectional.only(end: 13.w),
                  child: SvgPicture.asset(
                    'assets/figma/assessments/svg/calendar.svg',
                    width: 16.r,
                    height: 16.r,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: AppTextField.normal(
                controller: _ownerController,
                label: l10n.ownerLabel,
                hint: l10n.ownerHint,
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
                label: l10n.createAction,
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
