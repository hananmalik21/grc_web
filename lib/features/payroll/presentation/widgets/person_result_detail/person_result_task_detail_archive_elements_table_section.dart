import 'dart:math' as math;

import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

enum PersonResultTaskDetailArchiveElementClassification {
  standardEarnings,
  information,
  voluntaryDeductions,
  employerCharges,
}

class PersonResultTaskDetailArchiveElementsTableSection extends StatelessWidget {
  const PersonResultTaskDetailArchiveElementsTableSection({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = context.screenLayout.isMobile;
    final rows = buildArchiveElementRows(loc);
    final totalValue = loc.payrollPersonResultsTaskDetailArchivedElementsTotalValue;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder.withValues(alpha: 0.1)),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ArchiveElementsTableHeader(isMobile: isMobile),
          if (isMobile)
            _ArchiveElementsMobileList(rows: rows, totalValue: totalValue)
          else
            _ArchiveElementsDesktopTable(rows: rows, totalValue: totalValue),
        ],
      ),
    );
  }
}

List<PersonResultTaskDetailArchiveElementRowData> buildArchiveElementRows(AppLocalizations loc) {
  return [
    PersonResultTaskDetailArchiveElementRowData(
      elementName: loc.payrollPersonResultsTaskDetailElementBasicSalaryKw,
      classification: PersonResultTaskDetailArchiveElementClassification.standardEarnings,
      classificationLabel: loc.payrollAddElementStandardEarnings,
      inputValueName: loc.payrollAddElementPayValue,
      amount: loc.payrollPersonResultsTaskDetailBasicSalaryAmount,
    ),
    PersonResultTaskDetailArchiveElementRowData(
      elementName: loc.payrollPersonResultsTaskDetailElementHousingAllowanceKw,
      classification: PersonResultTaskDetailArchiveElementClassification.standardEarnings,
      classificationLabel: loc.payrollAddElementStandardEarnings,
      inputValueName: loc.payrollAddElementPayValue,
      amount: loc.payrollPersonResultsTaskDetailHousingAllowanceAmount,
    ),
    PersonResultTaskDetailArchiveElementRowData(
      elementName: loc.payrollPersonResultsTaskDetailKuwaitGrossSalaryKw,
      classification: PersonResultTaskDetailArchiveElementClassification.information,
      classificationLabel: loc.payrollPersonResultsTaskDetailClassificationInformation,
      inputValueName: loc.payrollPersonResultsTaskDetailInputGrossPay,
      amount: loc.payrollPersonResultsTaskDetailArchivedKuwaitGrossSalaryAmount,
    ),
    PersonResultTaskDetailArchiveElementRowData(
      elementName: loc.payrollPersonResultsTaskDetailTelephoneDeduction,
      classification: PersonResultTaskDetailArchiveElementClassification.voluntaryDeductions,
      classificationLabel: loc.payrollPersonResultsTaskDetailClassificationVoluntaryDeductions,
      inputValueName: loc.payrollPersonResultsTaskDetailInputDeductionAmount,
      amount: loc.payrollPersonResultsTaskDetailArchivedTelephoneDeductionAmount,
    ),
    PersonResultTaskDetailArchiveElementRowData(
      elementName: loc.payrollPersonResultsTaskDetailNrvRecovery,
      classification: PersonResultTaskDetailArchiveElementClassification.voluntaryDeductions,
      classificationLabel: loc.payrollPersonResultsTaskDetailClassificationVoluntaryDeductions,
      inputValueName: loc.payrollPersonResultsTaskDetailInputRecoveryAmount,
      amount: loc.payrollPersonResultsTaskDetailArchivedNrvRecoveryAmount,
    ),
    PersonResultTaskDetailArchiveElementRowData(
      elementName: loc.payrollPersonResultsTaskDetailLeaveProvisioning,
      classification: PersonResultTaskDetailArchiveElementClassification.employerCharges,
      classificationLabel: loc.payrollPersonResultsTaskDetailClassificationEmployerCharges,
      inputValueName: loc.payrollPersonResultsTaskDetailInputProvisionAmount,
      amount: loc.payrollPersonResultsTaskDetailArchivedLeaveProvisioningAmount,
    ),
    PersonResultTaskDetailArchiveElementRowData(
      elementName: loc.payrollPersonResultsTaskDetailNetPayKw,
      classification: PersonResultTaskDetailArchiveElementClassification.standardEarnings,
      classificationLabel: loc.payrollAddElementStandardEarnings,
      inputValueName: loc.payrollPersonResultsTaskDetailInputNetPay,
      amount: loc.payrollPersonResultsTaskDetailNetPayValue,
    ),
    PersonResultTaskDetailArchiveElementRowData(
      elementName: loc.payrollPersonResultsTaskDetailAirTicketInfo,
      classification: PersonResultTaskDetailArchiveElementClassification.information,
      classificationLabel: loc.payrollPersonResultsTaskDetailClassificationInformation,
      inputValueName: loc.payrollPersonResultsTaskDetailInputEntitlementValue,
      amount: loc.payrollPersonResultsTaskDetailArchivedAirTicketInfoAmount,
      isZeroAmount: true,
    ),
  ];
}

class PersonResultTaskDetailArchiveElementRowData {
  const PersonResultTaskDetailArchiveElementRowData({
    required this.elementName,
    required this.classification,
    required this.classificationLabel,
    required this.inputValueName,
    required this.amount,
    this.isZeroAmount = false,
  });

  final String elementName;
  final PersonResultTaskDetailArchiveElementClassification classification;
  final String classificationLabel;
  final String inputValueName;
  final String amount;
  final bool isZeroAmount;
}

class _ArchiveElementsColumnWidths {
  const _ArchiveElementsColumnWidths({this.multiplier = 1.0});

  final double multiplier;

  double get elementName => 240.w * multiplier;
  double get classification => 220.w * multiplier;
  double get inputValueName => 200.w * multiplier;
  double get amount => 180.w * multiplier;
  double get status => 150.w * multiplier;

  double get total => elementName + classification + inputValueName + amount + status;

  static double get horizontalPadding => 40.w;

  double get totalWithPadding => total + horizontalPadding;

  static const _ArchiveElementsColumnWidths base = _ArchiveElementsColumnWidths();
}

class _ArchiveElementsDesktopTable extends StatelessWidget {
  const _ArchiveElementsDesktopTable({required this.rows, required this.totalValue});

  final List<PersonResultTaskDetailArchiveElementRowData> rows;
  final String totalValue;

  @override
  Widget build(BuildContext context) {
    const baseWidths = _ArchiveElementsColumnWidths.base;

    return LayoutBuilder(
      builder: (context, constraints) {
        final baseContentWidth = baseWidths.totalWithPadding;
        final availableWidth = constraints.hasBoundedWidth && constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : baseContentWidth;
        final widthMultiplier = availableWidth > baseContentWidth
            ? (availableWidth - _ArchiveElementsColumnWidths.horizontalPadding) / baseWidths.total
            : 1.0;
        final columnWidths = _ArchiveElementsColumnWidths(multiplier: widthMultiplier);
        final tableWidth = math.max(baseContentWidth, availableWidth);

        return ScrollableSingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: tableWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ArchiveElementsTableColumnHeader(columnWidths: columnWidths),
                for (var index = 0; index < rows.length; index++)
                  _ArchiveElementsTableRow(data: rows[index], isAlternate: index.isOdd, columnWidths: columnWidths),
                _ArchiveElementsTableFooter(totalValue: totalValue, columnWidths: columnWidths),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ArchiveElementsMobileList extends StatelessWidget {
  const _ArchiveElementsMobileList({required this.rows, required this.totalValue});

  final List<PersonResultTaskDetailArchiveElementRowData> rows;
  final String totalValue;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsetsDirectional.fromSTEB(12.w, 12.h, 12.w, 12.h),
          itemCount: rows.length,
          separatorBuilder: (_, _) => Gap(10.h),
          itemBuilder: (context, index) => _ArchiveElementMobileCard(data: rows[index]),
        ),
        _ArchiveElementsMobileFooter(totalValue: totalValue, isDark: isDark),
      ],
    );
  }
}

class _ArchiveElementMobileCard extends StatelessWidget {
  const _ArchiveElementMobileCard({required this.data});

  final PersonResultTaskDetailArchiveElementRowData data;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final tileBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final amountColor = data.isZeroAmount
        ? (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder)
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);

    return Container(
      padding: EdgeInsetsDirectional.all(14.w),
      decoration: BoxDecoration(
        color: tileBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: tileBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.elementName,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(12.h),
          _ArchiveElementInfoLine(
            label: loc.payrollPersonResultsTaskDetailElementClassification,
            color: subtitleColor,
            child: _ArchiveClassificationChip(label: data.classificationLabel, classification: data.classification),
          ),
          Gap(8.h),
          _ArchiveElementInfoLine(
            label: loc.payrollPersonResultsTaskDetailInputValueName,
            value: data.inputValueName,
            color: subtitleColor,
          ),
          Gap(8.h),
          _ArchiveElementInfoLine(
            label: loc.payrollPersonResultsTaskDetailAmount,
            value: data.amount,
            color: amountColor,
            isEmphasized: true,
          ),
          Gap(8.h),
          _ArchiveElementInfoLine(
            label: loc.payrollPersonResultsTaskDetailStatus,
            color: subtitleColor,
            child: _ArchivedStatusChip(label: loc.payrollPersonResultsTaskDetailArchivedStatus),
          ),
        ],
      ),
    );
  }
}

class _ArchiveElementInfoLine extends StatelessWidget {
  const _ArchiveElementInfoLine({
    required this.label,
    required this.color,
    this.value,
    this.isEmphasized = false,
    this.child,
  });

  final String label;
  final Color color;
  final String? value;
  final bool isEmphasized;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final valueStyle = isEmphasized
        ? context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: color)
        : context.textTheme.bodySmall?.copyWith(color: color);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120.w,
          child: Text(label, style: context.textTheme.labelSmall?.copyWith(color: color)),
        ),
        Expanded(
          child: child != null
              ? Align(alignment: AlignmentDirectional.centerStart, child: child)
              : Text(value ?? '', style: valueStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class _ArchiveElementsMobileFooter extends StatelessWidget {
  const _ArchiveElementsMobileFooter({required this.totalValue, required this.isDark});

  final String totalValue;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final footerBg = isDark ? AppColors.grayBgDark.withValues(alpha: 0.35) : AppColors.tableHeaderBackground;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      decoration: BoxDecoration(
        color: footerBg,
        border: Border(top: BorderSide(color: borderColor, width: 2)),
      ),
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 15.h, 16.w, 14.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              loc.reviewTotal,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            totalValue,
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _ArchiveElementsTableHeader extends StatelessWidget {
  const _ArchiveElementsTableHeader({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loc.payrollPersonResultsTaskDetailArchivedPayrollElementsTitle,
          style: context.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(3.h),
        Text(
          loc.payrollPersonResultsTaskDetailArchivedPayrollElementsSubtitle,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ],
    );

    final actions = Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        AppButton.outline(
          label: loc.payrollPersonResultsTaskDetailExport,
          svgPath: Assets.icons.downloadIcon.path,
          onPressed: () {},
        ),
        AppButton.outline(label: loc.payrollPersonResultsPrint, icon: Icons.print_outlined, onPressed: () {}),
      ],
    );

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(28.w, 22.h, 28.w, 17.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder)),
      ),
      child: isMobile
          ? Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [titleBlock, Gap(12.h), actions])
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: titleBlock),
                actions,
              ],
            ),
    );
  }
}

class _ArchiveElementsTableColumnHeader extends StatelessWidget {
  const _ArchiveElementsTableColumnHeader({required this.columnWidths});

  final _ArchiveElementsColumnWidths columnWidths;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final headerBg = isDark ? AppColors.grayBgDark.withValues(alpha: 0.35) : AppColors.tableHeaderBackground;
    final headerColor = isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText;
    final headerStyle = context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, color: headerColor);

    return Container(
      color: headerBg,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 14.h),
      child: Row(
        children: [
          SizedBox(
            width: columnWidths.elementName,
            child: Text(loc.payrollPersonResultsTaskDetailElementName, style: headerStyle),
          ),
          SizedBox(
            width: columnWidths.classification,
            child: Text(loc.payrollPersonResultsTaskDetailElementClassification, style: headerStyle),
          ),
          SizedBox(
            width: columnWidths.inputValueName,
            child: Text(loc.payrollPersonResultsTaskDetailInputValueName, style: headerStyle),
          ),
          SizedBox(
            width: columnWidths.amount,
            child: Text(loc.payrollPersonResultsTaskDetailAmount, style: headerStyle),
          ),
          SizedBox(
            width: columnWidths.status,
            child: Text(loc.payrollPersonResultsTaskDetailStatus, style: headerStyle),
          ),
        ],
      ),
    );
  }
}

class _ArchiveElementsTableRow extends StatelessWidget {
  const _ArchiveElementsTableRow({required this.data, required this.isAlternate, required this.columnWidths});

  final PersonResultTaskDetailArchiveElementRowData data;
  final bool isAlternate;
  final _ArchiveElementsColumnWidths columnWidths;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final rowBg = isAlternate
        ? (isDark ? AppColors.grayBgDark.withValues(alpha: 0.2) : AppColors.grayBg)
        : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground);
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBackgroundGrey;
    final elementNameColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final inputValueColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final amountColor = data.isZeroAmount
        ? (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder)
        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary);

    return Container(
      decoration: BoxDecoration(
        color: rowBg,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w, vertical: 18.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: columnWidths.elementName,
            child: Text(
              data.elementName,
              style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: elementNameColor),
            ),
          ),
          SizedBox(
            width: columnWidths.classification,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: _ArchiveClassificationChip(label: data.classificationLabel, classification: data.classification),
            ),
          ),
          SizedBox(
            width: columnWidths.inputValueName,
            child: Text(data.inputValueName, style: context.textTheme.bodyMedium?.copyWith(color: inputValueColor)),
          ),
          SizedBox(
            width: columnWidths.amount,
            child: Text(
              data.amount,
              style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: amountColor),
            ),
          ),
          SizedBox(
            width: columnWidths.status,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: _ArchivedStatusChip(label: loc.payrollPersonResultsTaskDetailArchivedStatus),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArchiveClassificationChip extends StatelessWidget {
  const _ArchiveClassificationChip({required this.label, required this.classification});

  final String label;
  final PersonResultTaskDetailArchiveElementClassification classification;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final colors = _classificationColors(isDark, classification);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyCapsule(
          label: label,
          backgroundColor: colors.background,
          textColor: colors.foreground,
          padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 1.h),
          textStyle: context.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: colors.foreground),
        ),
      ],
    );
  }

  ({Color background, Color foreground}) _classificationColors(
    bool isDark,
    PersonResultTaskDetailArchiveElementClassification classification,
  ) {
    return switch (classification) {
      PersonResultTaskDetailArchiveElementClassification.standardEarnings => (
        background: isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : AppColors.infoBg,
        foreground: isDark ? AppColors.info : AppColors.infoTextSecondary,
      ),
      PersonResultTaskDetailArchiveElementClassification.information => (
        background: isDark ? AppColors.grayBgDark : AppColors.cardBackgroundGrey,
        foreground: isDark ? AppColors.textSecondaryDark : AppColors.textDarkSlate,
      ),
      PersonResultTaskDetailArchiveElementClassification.voluntaryDeductions => (
        background: isDark ? AppColors.warningBgDark.withValues(alpha: 0.35) : AppColors.warningBg,
        foreground: isDark ? AppColors.warningTextDark : AppColors.warningText,
      ),
      PersonResultTaskDetailArchiveElementClassification.employerCharges => (
        background: isDark ? AppColors.purpleBgDark.withValues(alpha: 0.35) : AppColors.purpleBg,
        foreground: isDark ? AppColors.purpleTextDark : AppColors.purpleTextSecondary,
      ),
    };
  }
}

class _ArchivedStatusChip extends StatelessWidget {
  const _ArchivedStatusChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyCapsule(
          label: label,
          backgroundColor: isDark ? AppColors.successBgDark.withValues(alpha: 0.35) : AppColors.greenBg,
          textColor: isDark ? AppColors.successTextDark : AppColors.alertResolvedText,
        ),
      ],
    );
  }
}

class _ArchiveElementsTableFooter extends StatelessWidget {
  const _ArchiveElementsTableFooter({required this.totalValue, required this.columnWidths});

  final String totalValue;
  final _ArchiveElementsColumnWidths columnWidths;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final footerBg = isDark ? AppColors.grayBgDark.withValues(alpha: 0.35) : AppColors.tableHeaderBackground;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      decoration: BoxDecoration(
        color: footerBg,
        border: Border(top: BorderSide(color: borderColor, width: 2)),
      ),
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 15.h, 20.w, 14.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              loc.reviewTotal,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
          ),
          SizedBox(
            width: columnWidths.amount + columnWidths.status,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                totalValue,
                style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
