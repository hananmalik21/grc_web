import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/l10n/app_localizations.dart';
import 'package:grc_web/core/theme/app_colors.dart';
import 'package:grc_web/core/widgets/app_button.dart';
import 'package:grc_web/core/widgets/app_responsive_dialog_metrics.dart';
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

  static const double maxDialogWidth = 672;

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
  final _dueDateController = TextEditingController();
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
    _dueDateController.dispose();
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
    if (picked == null) return;
    setState(() {
      _dueDate = picked;
      _dueDateController.text = _formatDueDate(picked);
    });
  }

  String _formatDueDate(DateTime d) {
    String two(int v) => v.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}';
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
            AddActionDialog.maxDialogWidth,
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                clipBehavior: Clip.antiAlias,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.fromLTRB(
                          metrics.contentPadding.left,
                          0,
                          metrics.contentPadding.right,
                          metrics.contentPadding.bottom,
                        ),
                        child: _footer(l10n, metrics),
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
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.addRemediationAction,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: metrics.isPhone ? 18.sp : 18.sp,
                fontWeight: FontWeight.w600,
                height: 28 / 18,
                letterSpacing: -0.45,
              ),
            ),
          ),
          AppButton.close(
            onPressed: () => Navigator.of(context).pop(),
            iconColor: AppColors.textBody,
            iconSize: 20.r,
            padding: EdgeInsets.all(6.r),
          ),
        ],
      ),
    );
  }

  Widget _form(AppLocalizations l10n, AppResponsiveDialogMetrics metrics) {
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
        SizedBox(height: metrics.fieldGap),
        AppTextField.normal(
          controller: _titleController,
          label: l10n.actionTitleLabel,
          hint: l10n.actionTitleHint,
        ),
        SizedBox(height: metrics.fieldGap),
        AppTextArea(
          controller: _descriptionController,
          label: l10n.actionDescriptionLabel,
          hint: l10n.actionDescriptionHint,
          minLines: 3,
        ),
        SizedBox(height: metrics.fieldGap),
        _ResponsiveFieldRow(
          metrics: metrics,
          left: AppSelectField<String>(
            label: l10n.priorityLabel,
            value: _priority,
            items: priorityItems,
            itemLabel: (v) => v,
            onChanged: (v) => setState(() => _priority = v ?? _priority),
          ),
          right: AppSelectField<String>(
            label: l10n.statusLabel,
            value: _status,
            items: statusItems,
            itemLabel: (v) => v,
            onChanged: (v) => setState(() => _status = v ?? _status),
          ),
        ),
        SizedBox(height: metrics.fieldGap),
        _ResponsiveFieldRow(
          metrics: metrics,
          left: AppTextField(
            controller: _dueDateController,
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
          right: AppTextField.normal(
            controller: _ownerController,
            label: l10n.ownerLabel,
            hint: l10n.ownerHint,
          ),
        ),
      ],
    );
  }

  Widget _footer(AppLocalizations l10n, AppResponsiveDialogMetrics metrics) {
    final createButton = AppButton(
      label: l10n.createAction,
      variant: AppButtonVariant.primary,
      fullWidth: metrics.useStackedFooter,
      onPressed: () => Navigator.of(context).pop(),
    );

    final cancelButton = AppButton(
      label: l10n.cancel,
      variant: AppButtonVariant.outlined,
      fullWidth: metrics.useStackedFooter,
      onPressed: () => Navigator.of(context).pop(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          padding: EdgeInsets.only(top: metrics.isPhone ? 20.h : 25.h),
          child: metrics.useStackedFooter
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    createButton,
                    SizedBox(height: 10.h),
                    cancelButton,
                  ],
                )
              : metrics.isCompact
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        createButton,
                        SizedBox(height: 10.h),
                        cancelButton,
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        cancelButton,
                        SizedBox(width: 12.w),
                        createButton,
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
