import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Horizontally scrollable row for chips, stat cards, and similar compact content.
class AppHorizontalScrollRow extends StatelessWidget {
  const AppHorizontalScrollRow({
    super.key,
    required this.children,
    this.spacing = 8,
    this.trailingSpace = 4,
    this.controller,
  });

  final List<Widget> children;
  final double spacing;
  final double trailingSpace;
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.stylus,
              PointerDeviceKind.trackpad,
            },
          ),
          child: SizedBox(
            width: constraints.maxWidth,
            child: SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              clipBehavior: Clip.none,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < children.length; i++) ...[
                    children[i],
                    if (i != children.length - 1) SizedBox(width: spacing.w),
                  ],
                  SizedBox(width: trailingSpace.w),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
