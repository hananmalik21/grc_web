import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/services/responsive_service.dart';

class CyberScreenLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? filterBar;
  final Widget child;
  final bool isScrollable;
  final EdgeInsetsGeometry? customPadding;

  const CyberScreenLayout({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.filterBar,
    required this.child,
    this.isScrollable = true,
    this.customPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;
    final defaultPadding = ResponsiveHelper.getPagePadding(context);
    final effectivePadding = customPadding ?? defaultPadding;

    final header = LayoutBuilder(
      builder: (context, constraints) {
        final titleSection = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF0F172A), // Dark slate title
                fontSize: isMobile ? 20.sp : 24.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            if (subtitle != null) ...[
              const Gap(4),
              Text(
                subtitle!,
                style: TextStyle(
                  color: const Color(0xFF64748B), // Muted grey subtitle
                  fontSize: isMobile ? 11.5.sp : 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ],
        );

        if (actions == null || actions!.isEmpty) {
          return titleSection;
        }

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleSection,
              const Gap(12),
              Wrap(spacing: 8.w, runSpacing: 8.h, children: actions!),
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: titleSection),
            const Gap(16),
            Row(mainAxisSize: MainAxisSize.min, children: actions!),
          ],
        );
      },
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        if (filterBar != null) ...[const Gap(16), filterBar!],
        const Gap(20),
        child,
      ],
    );

    return ColoredBox(
      color: const Color(0xFFF8FAFC), // Solid light mode background
      child: isScrollable
          ? SingleChildScrollView(
              padding: effectivePadding.add(EdgeInsets.only(bottom: 24.h)),
              child: content,
            )
          : Padding(padding: effectivePadding, child: content),
    );
  }
}
