import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

export 'responsive/breakpoints.dart';
export 'responsive/responsive_extensions.dart';
export 'responsive/responsive_helper.dart';
export 'responsive/responsive_values.dart';
import 'responsive/breakpoints.dart';

class ResponsiveService {
  ResponsiveService._();

  static Size getScreenUtilDesignSize({required double width}) {
    final layout = AppBreakpoints.fromWidth(width);

    return switch (layout) {
      ScreenLayout.mobile => const Size(375, 812),
      ScreenLayout.tabletSmall => const Size(768, 1024),
      ScreenLayout.tabletMedium => const Size(768, 1024),
      ScreenLayout.tabletLarge => const Size(1440, 900),
      ScreenLayout.desktop => const Size(1512, 1344),
    };
  }

  static Size getScreenUtilDesignSizeFromContext(BuildContext context) {
    final layout = AppBreakpoints.fromContext(context);
    final isLandscape = MediaQuery.orientationOf(context) == Orientation.landscape;

    final designSize = switch (layout) {
      ScreenLayout.mobile => const Size(375, 812),
      ScreenLayout.tabletSmall => const Size(768, 1024),
      ScreenLayout.tabletMedium => const Size(768, 1024),
      ScreenLayout.tabletLarge => const Size(1440, 900),
      ScreenLayout.desktop => const Size(1512, 1344),
    };

    if (!isLandscape || layout == ScreenLayout.desktop) return designSize;
    return Size(designSize.height, designSize.width);
  }
}

class _ScreenLayoutNotifier extends StateNotifier<ScreenLayout> {
  _ScreenLayoutNotifier() : super(ScreenLayout.desktop);

  int? _lastWidthPx;
  int? _lastHeightPx;

  void update(double width, double height) {
    final next = AppBreakpoints.fromWidth(width);

    final widthPx = width.round();
    final heightPx = height.round();

    final hasSizeChanged = _lastWidthPx != widthPx || _lastHeightPx != heightPx;
    final hasLayoutChanged = next != state;

    if (!hasSizeChanged && !hasLayoutChanged) return;

    _lastWidthPx = widthPx;
    _lastHeightPx = heightPx;

    if (kDebugMode) {
      print(
        '\x1B[35m[responsive] [$next] '
        '$widthPx×$heightPx\x1B[0m',
      );
    }
    state = next;
  }
}

final screenLayoutProvider = StateNotifierProvider<_ScreenLayoutNotifier, ScreenLayout>(
  (ref) => _ScreenLayoutNotifier(),
);

class LayoutBreaker extends ConsumerStatefulWidget {
  const LayoutBreaker({required this.builder, this.child, super.key});

  final Widget Function(BuildContext context, ScreenLayout layout, Widget? child) builder;
  final Widget? child;

  @override
  ConsumerState<LayoutBreaker> createState() => _LayoutBreakerState();
}

class _LayoutBreakerState extends ConsumerState<LayoutBreaker> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = MediaQuery.of(context).size;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ref.read(screenLayoutProvider.notifier).update(size.width, size.height);
        });
        final layout = AppBreakpoints.fromContext(context);
        return widget.builder(context, layout, widget.child);
      },
    );
  }
}

T _resolve<T>(
  ScreenLayout layout, {
  required T mobile,
  T? tabletSmall,
  T? tabletMedium,
  T? tabletLarge,
  required T desktop,
}) {
  switch (layout) {
    case ScreenLayout.mobile:
      return mobile;
    case ScreenLayout.tabletSmall:
      return tabletSmall ?? mobile;
    case ScreenLayout.tabletMedium:
      return tabletMedium ?? tabletSmall ?? mobile;
    case ScreenLayout.tabletLarge:
      return tabletLarge ?? tabletMedium ?? tabletSmall ?? mobile;
    case ScreenLayout.desktop:
      return desktop;
  }
}

extension ScreenLayoutContext on BuildContext {
  ScreenLayout get screenLayout => AppBreakpoints.fromContext(this);

  bool get isMobileLayout => screenLayout.isMobile;
  bool get isTabletLayout => screenLayout.isTablet;
  bool get isDesktopLayout => screenLayout.isDesktop;

  T responsive<T>({required T mobile, T? tablet, required T desktop}) => _resolve(
    screenLayout,
    mobile: mobile,
    tabletSmall: tablet,
    tabletMedium: tablet,
    tabletLarge: tablet,
    desktop: desktop,
  );

  T responsiveFine<T>({required T mobile, T? tabletSmall, T? tabletMedium, T? tabletLarge, required T desktop}) =>
      _resolve(
        screenLayout,
        mobile: mobile,
        tabletSmall: tabletSmall,
        tabletMedium: tabletMedium,
        tabletLarge: tabletLarge,
        desktop: desktop,
      );
}

extension ScreenLayoutRef on WidgetRef {
  ScreenLayout get screenLayout => watch(screenLayoutProvider);

  bool get isMobileLayout => screenLayout.isMobile;
  bool get isTabletLayout => screenLayout.isTablet;
  bool get isDesktopLayout => screenLayout.isDesktop;

  T responsive<T>({required T mobile, T? tablet, required T desktop}) => _resolve(
    screenLayout,
    mobile: mobile,
    tabletSmall: tablet,
    tabletMedium: tablet,
    tabletLarge: tablet,
    desktop: desktop,
  );

  T responsiveFine<T>({required T mobile, T? tabletSmall, T? tabletMedium, T? tabletLarge, required T desktop}) =>
      _resolve(
        screenLayout,
        mobile: mobile,
        tabletSmall: tabletSmall,
        tabletMedium: tabletMedium,
        tabletLarge: tabletLarge,
        desktop: desktop,
      );
}
