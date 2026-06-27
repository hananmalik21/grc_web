import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class StructureMetricsWidget extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isDark;
  final int components;
  final int employees;
  final String created;
  final String modified;

  const StructureMetricsWidget({
    super.key,
    required this.localizations,
    required this.isDark,
    required this.components,
    required this.employees,
    required this.created,
    required this.modified,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final items = [
      (localizations.components, components.toString()),
      (localizations.employees, employees.toString()),
      (localizations.created, created),
      (localizations.modified, modified),
    ];

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) Gap(4.h),
            InfoRichText(label: items[i].$1, value: items[i].$2, isDark: isDark),
          ],
        ],
      );
    }

    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) Gap(8.w),
          Expanded(
            child: InfoRichText(label: items[i].$1, value: items[i].$2, isDark: isDark),
          ),
        ],
      ],
    );
  }
}

class InfoRichText extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final TextAlign textAlign;
  final int maxLines;

  const InfoRichText({
    super.key,
    required this.label,
    required this.value,
    required this.isDark,
    this.textAlign = TextAlign.start,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark ? AppColors.textTertiaryDark : AppColors.grayText;
    final valueColor = isDark ? AppColors.textTertiaryDark : AppColors.dialogTitle;

    return RichText(
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: context.textTheme.bodyMedium?.copyWith(color: labelColor),
          ),
          TextSpan(
            text: value,
            style: context.textTheme.titleSmall?.copyWith(color: valueColor),
          ),
        ],
      ),
    );
  }
}
