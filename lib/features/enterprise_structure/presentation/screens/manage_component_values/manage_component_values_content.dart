import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class ManageComponentValuesContent extends StatelessWidget {
  const ManageComponentValuesContent({
    required this.padding,
    required this.header,
    required this.enterpriseSelector,
    required this.child,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final Widget header;
  final Widget enterpriseSelector;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.background,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            SizedBox(height: sectionSpacing),
            enterpriseSelector,
            SizedBox(height: sectionSpacing),
            child,
          ],
        ),
      ),
    );
  }
}
