import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PersonResultTaskDetailMessagesTableFooter extends StatelessWidget {
  const PersonResultTaskDetailMessagesTableFooter({
    required this.totalCount,
    required this.warningCount,
    required this.errorCount,
    required this.infoCount,
    required this.isMobile,
    super.key,
  });

  final int totalCount;
  final int warningCount;
  final int errorCount;
  final int infoCount;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final footerBg = isDark ? AppColors.grayBgDark.withValues(alpha: 0.35) : AppColors.tableHeaderBackground;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.borderGrey;
    final summaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    final severitySummary = Wrap(
      spacing: 16.w,
      runSpacing: 8.h,
      alignment: WrapAlignment.end,
      children: [
        PersonResultTaskDetailMessagesFooterSeverityItem(
          iconPath: Assets.icons.securityManager.warning.path,
          label: loc.payrollPersonResultsTaskDetailMessagesFooterWarnings(warningCount),
          color: AppColors.warning,
        ),
        PersonResultTaskDetailMessagesFooterSeverityItem(
          iconPath: Assets.icons.closeDialogIcon.path,
          label: loc.payrollPersonResultsTaskDetailMessagesFooterErrors(errorCount),
          color: AppColors.error,
        ),
        PersonResultTaskDetailMessagesFooterSeverityItem(
          iconPath: Assets.icons.infoCircleBlue.path,
          label: loc.payrollPersonResultsTaskDetailMessagesFooterInfo(infoCount),
          color: AppColors.info,
        ),
      ],
    );

    return Container(
      decoration: BoxDecoration(
        color: footerBg,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 14.h, 20.w, 13.h),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  loc.payrollPersonResultsTaskDetailMessagesCount(totalCount),
                  style: context.textTheme.bodyMedium?.copyWith(fontSize: 13.sp, color: summaryColor),
                ),
                Gap(10.h),
                Align(alignment: AlignmentDirectional.centerEnd, child: severitySummary),
              ],
            )
          : Row(
              children: [
                Text(
                  loc.payrollPersonResultsTaskDetailMessagesCount(totalCount),
                  style: context.textTheme.bodyMedium?.copyWith(fontSize: 13.sp, color: summaryColor),
                ),
                const Spacer(),
                severitySummary,
              ],
            ),
    );
  }
}

class PersonResultTaskDetailMessagesFooterSeverityItem extends StatelessWidget {
  const PersonResultTaskDetailMessagesFooterSeverityItem({
    required this.iconPath,
    required this.label,
    required this.color,
    super.key,
  });

  final String iconPath;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyAsset(assetPath: iconPath, width: 14, height: 14, color: color),
        Gap(6.w),
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(fontSize: 13.sp, fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }
}
