import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/payroll/domain/models/payroll_process_result_task.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

enum PersonResultTaskDetailArchiveFieldIconTone { info, warning, success }

class PersonResultTaskDetailArchiveSummarySection extends StatelessWidget {
  const PersonResultTaskDetailArchiveSummarySection({super.key, required this.task});

  final PayrollProcessResultTask task;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final fields = _buildFields(loc);

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ArchiveSummaryHeader(isMobile: context.screenLayout.isMobile),
          Gap(20.h),
          DigifyDivider.horizontal(),
          Gap(20.h),
          _ArchiveSummaryFieldsGrid(fields: fields),
        ],
      ),
    );
  }

  List<PersonResultTaskDetailArchiveSummaryFieldData> _buildFields(AppLocalizations loc) {
    final relationship = loc.payrollPersonResultsTaskDetailPayrollRelationshipNumberValue;

    return [
      PersonResultTaskDetailArchiveSummaryFieldData(
        label: loc.payrollPersonResultsTaskDetailArchiveReference,
        value: loc.payrollPersonResultsTaskDetailArchiveReferenceValue(relationship),
        iconPath: Assets.icons.compensation.fileList.path,
      ),
      PersonResultTaskDetailArchiveSummaryFieldData(
        label: loc.payrollPersonResultsTaskDetailPayrollFlow,
        value: task.flowName,
        iconPath: Assets.icons.payroll.process.path,
      ),
      PersonResultTaskDetailArchiveSummaryFieldData(
        label: loc.payrollPersonResultsPayrollPeriod,
        value: task.payrollPeriod,
        iconPath: Assets.icons.calendarIcon.path,
      ),
      PersonResultTaskDetailArchiveSummaryFieldData(
        label: loc.payrollPersonResultsArchiveDate,
        value: task.processDate,
        iconPath: Assets.icons.clockIcon.path,
        iconTone: PersonResultTaskDetailArchiveFieldIconTone.warning,
      ),
      PersonResultTaskDetailArchiveSummaryFieldData(
        label: loc.payrollPersonResultsTaskDetailPayrollRelationship,
        value: relationship,
        iconPath: Assets.icons.compensation.layers.path,
      ),
      PersonResultTaskDetailArchiveSummaryFieldData(
        label: loc.payrollPersonResultsTaskDetailConsolidationGroup,
        value: loc.payrollPersonResultsTaskDetailConsolidationGroupValue,
        iconPath: Assets.icons.employeeManagement.gridView.path,
      ),
      PersonResultTaskDetailArchiveSummaryFieldData(
        label: loc.payrollPersonResultsTaskDetailElementsArchived,
        value: loc.payrollPersonResultsTaskDetailElementsArchivedValue,
        iconPath: Assets.icons.analyticsIcon.path,
      ),
      PersonResultTaskDetailArchiveSummaryFieldData(
        label: loc.payrollPersonResultsTaskDetailTotalNetPay,
        value: loc.payrollPersonResultsTaskDetailNetPayValue,
        iconPath: Assets.icons.leaveManagement.dollar.path,
        iconTone: PersonResultTaskDetailArchiveFieldIconTone.success,
      ),
    ];
  }
}

class PersonResultTaskDetailArchiveSummaryFieldData {
  const PersonResultTaskDetailArchiveSummaryFieldData({
    required this.label,
    required this.value,
    required this.iconPath,
    this.iconTone = PersonResultTaskDetailArchiveFieldIconTone.info,
  });

  final String label;
  final String value;
  final String iconPath;
  final PersonResultTaskDetailArchiveFieldIconTone iconTone;
}

class _ArchiveSummaryHeader extends StatelessWidget {
  const _ArchiveSummaryHeader({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    final titleBlock = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.5) : AppColors.infoBg,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: DigifyAsset(
            assetPath: Assets.icons.compensation.fileList.path,
            width: 20,
            height: 20,
            color: AppColors.primary,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.payrollPersonResultsTaskDetailArchiveSummaryTitle,
                style: context.textTheme.headlineMedium?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Text(
                loc.payrollPersonResultsTaskDetailArchiveSummarySubtitle,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.grayBorderDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final badge = DigifyCapsule(
      label: loc.payrollPersonResultsTaskDetailArchiveVerified,
      backgroundColor: isDark ? AppColors.successBgDark.withValues(alpha: 0.35) : AppColors.successBg,
      textColor: isDark ? AppColors.successTextDark : AppColors.successText,
      borderColor: isDark ? AppColors.successBorder.withValues(alpha: 0.4) : AppColors.successBorder,
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          titleBlock,
          Gap(12.h),
          Align(alignment: AlignmentDirectional.centerStart, child: badge),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: titleBlock),
        badge,
      ],
    );
  }
}

class _ArchiveSummaryFieldsGrid extends StatelessWidget {
  const _ArchiveSummaryFieldsGrid({required this.fields});

  final List<PersonResultTaskDetailArchiveSummaryFieldData> fields;

  @override
  Widget build(BuildContext context) {
    final columnCount = _columnCount(context);
    final rowCount = (fields.length / columnCount).ceil();
    final horizontalGap = context.screenLayout.isMobile ? 0.0 : 24.w;
    final verticalGap = 20.h;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var row = 0; row < rowCount; row++) ...[
          if (row > 0) Gap(verticalGap),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var column = 0; column < columnCount; column++) ...[
                if (column > 0) Gap(horizontalGap),
                Expanded(
                  child: Align(
                    alignment: AlignmentDirectional.topStart,
                    child: _buildFieldAt(row: row, column: column, columnCount: columnCount),
                  ),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  int _columnCount(BuildContext context) {
    if (context.screenLayout.isMobile) return 1;
    if (context.screenLayout.isTablet) return 2;
    return 4;
  }

  Widget _buildFieldAt({required int row, required int column, required int columnCount}) {
    final index = row * columnCount + column;
    if (index >= fields.length) {
      return const SizedBox.shrink();
    }

    return PersonResultTaskDetailArchiveSummaryField(data: fields[index]);
  }
}

class PersonResultTaskDetailArchiveSummaryField extends StatelessWidget {
  const PersonResultTaskDetailArchiveSummaryField({super.key, required this.data});

  final PersonResultTaskDetailArchiveSummaryFieldData data;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final labelColor = isDark ? AppColors.grayTextDark : AppColors.grayBorderDark;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 28.w,
              height: 28.w,
              decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(10.r)),
              alignment: Alignment.center,
              child: DigifyAsset(assetPath: data.iconPath, width: 18, height: 18, color: AppColors.primary),
            ),
            Gap(7.w),
            Expanded(
              child: Text(
                data.label.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelMedium?.copyWith(fontSize: 11.sp, color: labelColor),
              ),
            ),
          ],
        ),
        Gap(8.h),
        Padding(
          padding: EdgeInsetsDirectional.only(start: 2.w),
          child: Text(
            data.value,
            style: context.textTheme.labelLarge?.copyWith(fontSize: 14.sp, color: valueColor),
          ),
        ),
      ],
    );
  }
}
