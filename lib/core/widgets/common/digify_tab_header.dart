import 'package:grc/core/services/responsive_service.dart';
import 'package:flutter/material.dart';

class DigifyTabHeader extends StatelessWidget {
  final String title;
  final String? description;
  final Widget? trailing;

  const DigifyTabHeader({super.key, required this.title, this.description, this.trailing});

  @override
  Widget build(BuildContext context) {
    if (trailing == null) return const SizedBox.shrink();

    // Title and description are intentionally hidden.
    // final titleSection = Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(title, style: context.textTheme.displaySmall),
    //     if (description != null) ...[
    //       Gap(descriptionGap),
    //       Text(
    //         description!,
    //         style: context.textTheme.bodyMedium?.copyWith(
    //           color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
    //         ),
    //       ),
    //     ],
    //   ],
    // );

    if (context.isMobileLayout) {
      return Align(alignment: Alignment.topRight, child: trailing!);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [trailing!],
    );
  }
}
