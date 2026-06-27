import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/security_manager/domain/models/security_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class SecurityFunctionListSummary extends StatelessWidget {
  const SecurityFunctionListSummary({super.key, required this.function});

  final SecurityFunction function;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final titleColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final secondaryStyle = (context.textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: secondaryColor,
      fontSize: 12.sp,
    );

    final metaRows = <({String label, String value})>[
      if (function.functionCode.isNotEmpty) (label: 'Code', value: function.functionCode),
      if (function.moduleName.isNotEmpty) (label: 'Module', value: function.moduleName),
      if (function.permissionKey.isNotEmpty) (label: 'Permission', value: function.permissionKey),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          function.functionName,
          style: context.textTheme.titleSmall?.copyWith(color: titleColor),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (metaRows.isNotEmpty) ...[
          Gap(4.h),
          for (var i = 0; i < metaRows.length; i++) ...[
            if (i > 0) Gap(2.h),
            _LabeledMetaLine(style: secondaryStyle, label: metaRows[i].label, value: metaRows[i].value),
          ],
        ],
      ],
    );
  }
}

class _LabeledMetaLine extends StatelessWidget {
  const _LabeledMetaLine({required this.style, required this.label, required this.value});

  final TextStyle style;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(
            text: '$label: ',
            style: style.copyWith(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: value),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
