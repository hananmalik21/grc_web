import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class AddEmployeeNameFieldsInfoBanner extends StatelessWidget {
  final String message;
  final List<String> boldPhrases;
  final String iconAssetPath;

  const AddEmployeeNameFieldsInfoBanner({
    super.key,
    required this.message,
    required this.boldPhrases,
    required this.iconAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final baseStyle = context.textTheme.bodySmall?.copyWith(color: AppColors.primary);
    final boldStyle = baseStyle?.copyWith(fontWeight: FontWeight.w600);

    int lastEnd = 0;
    final spans = <TextSpan>[];
    for (final phrase in boldPhrases) {
      final i = message.indexOf(phrase, lastEnd);
      if (i == -1) continue;
      if (i > lastEnd) {
        spans.add(TextSpan(text: message.substring(lastEnd, i)));
      }
      spans.add(TextSpan(text: phrase, style: boldStyle));
      lastEnd = i + phrase.length;
    }
    if (lastEnd < message.length) {
      spans.add(TextSpan(text: message.substring(lastEnd)));
    }

    final textWidget = spans.isEmpty
        ? Text(message, style: baseStyle)
        : Text.rich(TextSpan(style: baseStyle, children: spans));

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark : AppColors.tableHeaderBackground,
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          DigifyAsset(
            assetPath: iconAssetPath,
            width: 20,
            height: 20,
            color: isDark ? AppColors.infoTextDark : AppColors.primary,
          ),
          Gap(8.w),
          Expanded(child: textWidget),
        ],
      ),
    );
  }
}
