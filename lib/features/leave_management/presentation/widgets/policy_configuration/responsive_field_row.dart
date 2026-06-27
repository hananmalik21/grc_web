import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Horizontal on tablet/desktop; vertical stack on mobile.
/// In row mode each child is wrapped in [Expanded] to share equal width.
class ResponsiveFieldRow extends StatelessWidget {
  const ResponsiveFieldRow({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: children,
      );
    }
    return Row(
      spacing: 12.w,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.map((c) => Expanded(child: c)).toList(),
    );
  }
}
