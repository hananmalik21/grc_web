import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/time_management/presentation/widgets/common/time_management_empty_state_widget.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/public_holidays_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PublicHolidaysContent extends StatelessWidget {
  const PublicHolidaysContent({
    required this.padding,
    required this.sectionSpacing,
    required this.header,
    required this.enterpriseSelector,
    required this.enterpriseId,
    super.key,
  });

  final EdgeInsetsGeometry padding;
  final double sectionSpacing;
  final Widget header;
  final Widget enterpriseSelector;
  final int? enterpriseId;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      color: isDark ? AppColors.backgroundDark : AppColors.background,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header,
            Gap(sectionSpacing),
            enterpriseSelector,
            Gap(sectionSpacing),
            if (enterpriseId != null)
              const PublicHolidaysContentWidget()
            else
              const Center(
                child: TimeManagementEmptyStateWidget(message: 'Please select an enterprise to view public holidays'),
              ),
          ],
        ),
      ),
    );
  }
}
