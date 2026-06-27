import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DigifyMobileTabHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const DigifyMobileTabHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    final titleStyle = context.mobileTextTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(title, style: titleStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
        if (trailing != null) ...[Gap(12.w), trailing!],
      ],
    );
  }
}
