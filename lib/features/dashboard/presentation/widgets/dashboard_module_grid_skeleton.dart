import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/feedback/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardModuleGridSkeleton extends StatelessWidget {
  const DashboardModuleGridSkeleton({super.key});

  int _tileCountForLayout(ScreenLayout layout) {
    return switch (layout) {
      ScreenLayout.mobile => 6,
      ScreenLayout.tabletSmall => 8,
      ScreenLayout.tabletMedium => 10,
      ScreenLayout.tabletLarge => 12,
      ScreenLayout.desktop => 14,
    };
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final layout = AppBreakpoints.fromWidth(maxW);
        final spec = _gridSpecForWidth(maxW);
        final tileCount = _tileCountForLayout(layout);

        return Wrap(
          spacing: spec.spacing,
          runSpacing: layout.isMobile ? 4.h : 6.h,
          alignment: WrapAlignment.start,
          children: List.generate(tileCount, (index) {
            return SizedBox(
              key: ValueKey('dash-skeleton-$index'),
              width: spec.tileW,
              height: spec.tileH,
              child: const _DashboardModuleButtonSkeleton(),
            );
          }),
        );
      },
    );
  }
}

class _DashboardModuleButtonSkeleton extends StatelessWidget {
  const _DashboardModuleButtonSkeleton();

  @override
  Widget build(BuildContext context) {
    final double iconBoxSize = context.responsiveFine(
      mobile: 44.0,
      tabletSmall: 48.0,
      tabletMedium: 52.0,
      tabletLarge: 54.0,
      desktop: 56.0,
    );
    final double labelHeight = context.responsive(mobile: 32.0.h, tablet: 34.0.h, desktop: 36.0.h);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShimmerContainer(width: iconBoxSize, height: iconBoxSize, borderRadius: 14.r),
        SizedBox(height: 6.h),
        SizedBox(
          height: labelHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerContainer(width: iconBoxSize * 0.9, height: 10.h, borderRadius: 4.r),
              SizedBox(height: 4.h),
              ShimmerContainer(width: iconBoxSize * 0.65, height: 10.h, borderRadius: 4.r),
            ],
          ),
        ),
      ],
    );
  }
}

class _GridSpec {
  const _GridSpec({required this.columns, required this.spacing, required this.tileW, required this.tileH});

  final int columns;
  final double spacing;
  final double tileW;
  final double tileH;
}

_GridSpec _gridSpecForWidth(double maxW) {
  final layout = AppBreakpoints.fromWidth(maxW);
  final double spacing = layout.isMobile ? 4.w : 6.w;

  if (layout.isMobile) {
    const int columns = 2;
    final double totalSpacing = spacing * (columns - 1);
    final double tileW = ((maxW - totalSpacing) / columns).floorToDouble();
    final double tileH = (tileW * 1.05).clamp(140.h, 165.h).toDouble();
    return _GridSpec(columns: columns, spacing: spacing, tileW: tileW, tileH: tileH);
  }

  final double minTileW = layout.isDesktop ? 140.w : 120.w;
  final double maxTileW = layout.isDesktop ? 175.w : 155.w;

  int columns = ((maxW + spacing) / (minTileW + spacing)).floor();

  switch (layout) {
    case ScreenLayout.tabletSmall:
      columns = columns.clamp(3, 4);
    case ScreenLayout.tabletMedium:
      columns = columns.clamp(4, 5);
    case ScreenLayout.tabletLarge:
      columns = columns.clamp(5, 7);
    case ScreenLayout.desktop:
      columns = columns.clamp(6, 9);
    case ScreenLayout.mobile:
      break;
  }

  final double usableZone = maxW - (spacing * (columns - 1));
  final double tileW = (usableZone / columns).clamp(minTileW, maxTileW).toDouble();
  final double tileH = (tileW * 0.95).clamp(135.h, 160.h).toDouble();

  return _GridSpec(columns: columns, spacing: spacing, tileW: tileW, tileH: tileH);
}
